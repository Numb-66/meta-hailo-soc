import subprocess
import os
import sys
import signal


def run_uart_flash_mmc_programming():
    script_path = os.path.join(os.path.dirname(__file__), "uart_flash_mmc_programming.sh")
    # Get all command line arguments passed to this Python script
    args = sys.argv[1:]  # Skip the first argument which is the script name

    # Combine the shell script path with any additional arguments
    command = ["bash", script_path] + args

    process = subprocess.Popen(command,
                               stdout=subprocess.PIPE,
                               stderr=subprocess.STDOUT,
                               text=True,
                               bufsize=1,
                               universal_newlines=True,
                               preexec_fn=os.setsid)

    def signal_handler(signum, frame):
        # Forward the signal to the entire process group
        os.killpg(process.pid, signal.SIGINT)

    # Set up the signal handler
    signal.signal(signal.SIGINT, signal_handler)

    while True:
        output = process.stdout.readline()
        if output == '' and process.poll() is not None:
            break
        if output:
            # Check if this is sz output (it will contain \r)
            if output.strip().startswith('Ymodem'):
                print(output.strip(), end='\r', flush=True)
            else:
                print(output.strip())  # normal line with newline

    return process.poll()
