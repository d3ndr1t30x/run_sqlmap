SQLMap Automation Script

This Bash script automates SQL injection testing using SQLMap across a list of URLs provided in a file. It offers flexibility in setting SQLMap options such as delay, threads, safe URL, and timeout per request, allowing for customized scanning approaches.
Features

    Automated SQL Injection Testing: Easily scan multiple URLs for SQL injection vulnerabilities using SQLMap.
    Customizable Scanning Parameters: Set delay, threads, safe URL, and timeout per request to tailor the scanning approach.
    Combined Results: Consolidates SQLMap results from multiple URLs into a single output file with timestamps.

Requirements

    sqlmap: Ensure SQLMap is installed and accessible via the command line.
    Bash Shell: The script is designed to run on Unix-like systems with Bash.

Usage

```./sqlmap_auto.sh [options] <url_list_file>```

Options

    -d, --delay <seconds>: Set the delay between requests (default: 10 seconds).
    -t, --threads <number>: Set the number of threads for concurrent requests (default: 1).
    -f, --safe-freq <number>: Set the safe frequency of requests (default: 1).
    -T, --time-sec <seconds>: Set the timeout for each request in seconds (default: 10 seconds).

Examples
Stealthy Scan
```./sqlmap_auto.sh -d 10 -t 1 -f 1 -T 10 urls.txt```

Aggressive Scan
```./sqlmap_auto.sh -d 1 -t 10 -f 100 -T 5 urls.txt```

Balanced Scan
```./sqlmap_auto.sh -d 5 -t 5 -f 50 -T 10 urls.txt```

Notes

Safe URL: The script includes a predefined safe URL (http://www.example.com/) for testing purposes.
Output: Results for each URL are saved in individual files with timestamps. Additionally, a combined results file (combined_results_<timestamp>.txt) is generated. Sudo Password: The script prompts for the sudo password to execute SQLMap with elevated privileges (if required).
