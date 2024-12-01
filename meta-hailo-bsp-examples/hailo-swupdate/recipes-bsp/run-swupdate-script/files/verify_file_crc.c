#include <stdio.h>
#include <stdint.h>
#include <stdbool.h>
#include <stdlib.h>

#include <stdio.h>
#include <stdint.h>
#include <stdbool.h>
#include <stdlib.h>
#include <string.h>

#define CRC32_SIZE_BYTES 4
#define TEMP_FILE_NAME "/tmp/tmp_crc_file.bin"
#define MAX_CONFIG_SIZE_BYTES 0x1000
#define MIN_CONFIG_SIZE_BYTES 8 

// Function to print an error message, free buffer, close input file and exit the program
bool error_exit(const char* message, uint8_t* buffer, FILE *input_file) 
{
    perror(message);

    if(buffer != NULL)
    {
        free(buffer);
    }
    
    if(input_file != NULL)
    {
        fclose(input_file);
    }
    return false;
}

// Verify the CRC32 value of a file, with the following assumptions:
// - CRC32 value is stored in the first 4 bytes of the file
// - Actual data size is stored in the next 2 bytes of the file
bool verify_crc32(const char* input_filename) 
{
    char string[256];
    uint32_t calculated_crc = 0, reversed_crc = 0;
    uint32_t original_crc = 0;
    uint8_t* buffer = NULL;
    int8_t returned_length = 0;
    uint16_t actual_config_size_bytes = 0, actual_data_size_bytes = 0;
    
    FILE *input_file = NULL;
    FILE *tmp_file = NULL;
    FILE *crc_output_file = NULL;

    // Open the file in binary mode
    input_file = fopen(input_filename, "rb");
    if (input_file == NULL) 
    {
        snprintf(string, sizeof(string), "Error opening file %s", input_filename);
        return error_exit(string, NULL, NULL);
    }

    // Read the original CRC32 value from the file, which is stored in the first 4 bytes
    returned_length = fread(&original_crc, sizeof(uint32_t), 1, input_file);

    if(returned_length != 1)
    {
        snprintf(string, sizeof(string), "Error reading original CRC32 value, fread result= %d", returned_length);
        return error_exit(string, NULL, input_file);
    }

    // Read the actual config size in bytes from the file, which is located in the next 2 bytes
    returned_length = fread(&actual_config_size_bytes, sizeof(uint16_t), 1, input_file);

    if(returned_length != 1)
    {
        snprintf(string, sizeof(string), "Error reading actual_config_size_bytes value, fread result= %d", returned_length);
        return error_exit(string, NULL, input_file);
    }

    if(((actual_config_size_bytes % 4) != 0) ||
        (actual_config_size_bytes < MIN_CONFIG_SIZE_BYTES) ||
        (actual_config_size_bytes > MAX_CONFIG_SIZE_BYTES))
    {
        snprintf(string, sizeof(string), "actual_config_size_bytes (=%d) is not valid (should be aligned to 4 bytes, min %d, max %d)",
                 actual_config_size_bytes, MIN_CONFIG_SIZE_BYTES, MAX_CONFIG_SIZE_BYTES);
        return error_exit(string, NULL, input_file);
    }

    // Remove the 4-bytes CRC length from the actual data size
    actual_data_size_bytes = actual_config_size_bytes - CRC32_SIZE_BYTES;

    // Allocate a buffer to store the remaining data
    buffer = (uint8_t*)malloc(sizeof(uint8_t) * actual_data_size_bytes);

    if (buffer == NULL) 
    {
        snprintf(string, sizeof(string), "Error allocating memory for buffer of %d bytes", actual_data_size_bytes);
        return error_exit(string, buffer, input_file);
    }

    // Seek back to the beginning of the data
    fseek(input_file, CRC32_SIZE_BYTES, SEEK_SET);

    // Read the remaining data as 4-byte words into a buffer
    returned_length = fread(buffer, sizeof(uint32_t), actual_data_size_bytes / 4, input_file);

    if(returned_length != (actual_data_size_bytes / 4))
    {
        snprintf(string, sizeof(string), "Error reading data of expected length %d bytes, fread result= %d", actual_data_size_bytes, returned_length);
        return error_exit(string, buffer, input_file);
    }   

    // Reverse the bytes of each 32-bit word
    for (size_t i = 0; i < actual_data_size_bytes; i+=4)
    {
        uint32_t* word = (uint32_t*)(buffer + i);
        *word = ((*word & 0xFF000000) >> 24) | ((*word & 0x00FF0000) >> 8) |
                ((*word & 0x0000FF00) << 8) | ((*word & 0x000000FF) << 24);
    }

    // Bit reverse each byte
    for (size_t i = 0; i < actual_data_size_bytes; i++)
    {
        uint8_t byte = buffer[i];
        byte = ((byte & 0x01) << 7) | ((byte & 0x02) << 5) | ((byte & 0x04) << 3) |
               ((byte & 0x08) << 1) | ((byte & 0x10) >> 1) | ((byte & 0x20) >> 3) |
               ((byte & 0x40) >> 5) | ((byte & 0x80) >> 7);
        buffer[i] = byte;
    }

    tmp_file = fopen(TEMP_FILE_NAME, "wb");

    if (tmp_file == NULL) 
    {
        snprintf(string, sizeof(string), "Error opening file %s", TEMP_FILE_NAME);
        return error_exit(string, buffer, input_file);
    }  
    
    returned_length = fwrite(buffer, 1, actual_data_size_bytes, tmp_file);

    if(returned_length != actual_data_size_bytes)
    {
        snprintf(string, sizeof(string), "Error writing data to %s, fwrite result= %d", TEMP_FILE_NAME, returned_length);
        fclose(tmp_file);
        return error_exit(string, buffer, input_file);
    }

    fclose(tmp_file);

    // Calculate the CRC32 value using the crc32 library
    snprintf(string, sizeof(string), "crc32 %s", TEMP_FILE_NAME);

    crc_output_file = popen(string, "r");
    if (crc_output_file == NULL) 
    {
        snprintf(string, sizeof(string), "Error running crc32 command");
        return error_exit(string, buffer, input_file);
    }
    fscanf(crc_output_file, "%X", &calculated_crc);
    pclose(crc_output_file);

    // Bit-reverse the calculated CRC32 value
    for (size_t i = 0; i < 32; i++) 
    {
        reversed_crc <<= 1;
        if (calculated_crc & 1) 
        {
            reversed_crc |= 1;
        }
        calculated_crc >>= 1;
    }

    // XOR the calculated CRC32 value with 0xFFFFFFFF
    reversed_crc ^= 0xFFFFFFFF;

    // free buffer, close files
    free(buffer);
    fclose(input_file);

    // Remove the temp file
    remove(TEMP_FILE_NAME);

    return (reversed_crc == original_crc);
}

int main(int argc, char* argv[])
{
    if (argc != 2) {
        printf("Usage: %s <input_filename>\n", argv[0]);
        printf("Assumptions:\n");
        printf(" - CRC32 value is stored in the first 4 bytes of the file\n");
        printf(" - Actual data size is stored in the next 2 bytes of the file\n");
        return 1;
    }

    // Compare the calculated CRC32 value with the original CRC32 value
    // If verification is successful, return zero, otherwise return non-zero
    if (verify_crc32(argv[1])) {
        return 0;
    }
    else {
        return 1;
    }
}
