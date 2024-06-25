#!/bin/bash

# Function to display the help menu
show_help() {
    echo "Usage: $0 [options] <url_list_file>"
    echo
    echo "Options:"
    echo "  -h, --help             Display this help message."
    echo "  -d, --delay            Set the SQLMap request delay in seconds (default: 10)."
    echo "  -t, --threads          Set the SQLMap number of threads (default: 1)."
    echo "  -f, --safe-freq        Set the safe request frequency for SQLMap (default: 1)."
    echo "  -T, --time-sec         Set the SQLMap timeout for each request in seconds (default: 10)."
    echo
    echo "Arguments:"
    echo "  url_list_file          File containing full URLs for testing."
    echo
    echo "Examples:"
    echo "  Stealthy Scan:"
    echo "    $0 -d 10 -t 1 -f 1 -T 10 urls.txt"
    echo "    Description: Uses low risk and level, single thread, and high delays to avoid detection."
    echo
    echo "  Aggressive Scan:"
    echo "    $0 -d 1 -t 10 -f 100 -T 5 urls.txt"
    echo "    Description: Uses higher levels of testing, multiple threads, and minimal delays for thorough testing."
    echo
    echo "  Balanced Scan:"
    echo "    $0 -d 5 -t 5 -f 50 -T 10 urls.txt"
    echo "    Description: A balanced approach between stealthy and aggressive scanning."
    echo
    echo "Example:"
    echo "  $0 -d 15 -t 1 -f 2 -T 15 urls.txt"
}

# Function to handle script exit and cleanup
cleanup() {
    echo -e "\nTerminating script..."
    sudo -K
    exit 0
}

# Trap SIGINT (Ctrl+C) to call cleanup function
trap cleanup SIGINT

# Default SQLMap options for stealth mode
delay=10
threads=1
safe_url="http://www.example.com/" # Predefined safe URL
safe_freq=1
time_sec=10

# Parse options
while [[ "$1" =~ ^- && ! "$1" == "--" ]]; do case $1 in
  -h | --help )
    show_help
    exit
    ;;
  -d | --delay )
    shift; delay=$1
    ;;
  -t | --threads )
    shift; threads=$1
    ;;
  -f | --safe-freq )
    shift; safe_freq=$1
    ;;
  -T | --time-sec )
    shift; time_sec=$1
    ;;
  * )
    echo "Error: Invalid option '$1'"
    show_help
    exit 1
    ;;
esac; shift; done

# Remaining argument should be the url_list_file
if [[ -z "$1" ]]; then
    echo "Error: No URL list file provided."
    show_help
    exit 1
fi

url_list_file=$1

# Combined results file with timestamp
timestamp=$(date +"%Y%m%d%H%M%S")
combined_results="combined_results_$timestamp.txt"
> "$combined_results" # Clear the combined results file

# Prompt for the sudo password once and store it
read -s -p "Enter your sudo password: " SUDO_PASSWORD
echo

# Test the sudo password once and store the timestamp
echo $SUDO_PASSWORD | sudo -S -v || { echo "Error: Incorrect sudo password."; exit 1; }

# Prompt for POST data and cookie if needed
read -p "Enter POST data (leave empty if GET): " data
read -p "Enter cookie (leave empty if none): " cookie

# Read URLs from file
while IFS= read -r url; do
    # Output filename based on URL path with timestamp
    output_file=$(echo "$url" | sed 's|[^a-zA-Z0-9]|_|g')_$timestamp.sqlmap.out

    # Construct SQLMap command
    command="echo $SUDO_PASSWORD | sudo -S sqlmap -u '$url' --level=1 --risk=1 --random-agent --delay=$delay --threads=$threads --safe-url='$safe_url' --safe-freq=$safe_freq --time-sec=$time_sec -o $output_file --batch"

    # Add POST data and cookie if provided
    if [[ -n "$data" ]]; then
        command+=" --data='$data'"
    fi
    if [[ -n "$cookie" ]]; then
        command+=" --cookie='$cookie'"
    fi

    # Execute SQLMap command and append to combined results
    eval $command
    echo "==== Results for URL: $url ====" >> "$combined_results"
    cat "$output_file" >> "$combined_results"
    echo -e "\n" >> "$combined_results"

done < "$url_list_file"

# Clear the stored sudo timestamp
sudo -K

echo "Combined results have been saved to $combined_results."
