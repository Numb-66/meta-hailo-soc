# Function to align a file by adding padding to make its size a multiple of `pad_size`
align_file() {
    binary_file="$1"
    pad_size="$2"

    # Get the current size of the file
    current_size=$(stat --format=%s "$binary_file")

    # Calculate padding needed to make the file size a multiple of `pad_size`
    padding_needed=$(expr $pad_size - \( $current_size % $pad_size \))

    # If no padding is needed (already aligned), exit early
    if [ "$padding_needed" -eq "$pad_size" ]; then
        return
    fi

    # Use dd to add zero padding (or any other byte pattern) to the file
    dd if=/dev/zero bs=1 count="$padding_needed" >> "$binary_file"
}
