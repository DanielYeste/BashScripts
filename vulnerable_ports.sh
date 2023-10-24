#!/bin/bash

# Pass a txt with the ports from an nmap scan and obtain vulnerable ports number.
# Check if an argument is provided
if [ $# -eq 0 ]; then
    echo "Please provide the file name as an argument."
    exit 1
fi

# Check if the file exists
if [ ! -f "$1" ]; then
    echo "The file $1 does not exist."
    exit 1
fi

# Extract non-unknown ports
non_unknown_ports=$(grep -E "^[0-9]+/tcp\s+open" "$1" | grep -v "unknown" | cut -d'/' -f 1)

# Create a comma-separated list of ports
targeted_ports=$(echo $non_unknown_ports | tr '\n' ',' | sed 's/,$//')

# Display the result
echo "Targeted ports: $targeted_ports"

