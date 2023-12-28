#!/bin/bash

# Given an IP, performs an initial sync scan with nmap, saves the output in a text file, and then scans for vulnerabilities, exporting the results to a file.
# Check if an argument is provided
if [ $# -eq 0 ]; then
    echo "Please provide an IP address as an argument."
    exit 1
fi

# Define the target IP
target_ip="$1"

# Launch initial nmap scan
nmap_output=$(nmap -p- -sS -Pn --min-rate 5000 "$target_ip")
echo "$nmap_output" | grep -E "^[0-9]+/tcp\s+open" | cut -d'/' -f 1 > non_unknown_ports.txt

# Create a comma-separated list of non-unknown ports
targeted_ports=$(tr '\n' ',' < non_unknown_ports.txt | sed 's/,$//')

# Check if ports are found
if [ -z "$targeted_ports" ]; then
    echo "No open ports found. Exiting."
    rm non_unknown_ports.txt
    exit 1
fi

# Launch targeted nmap scan
sudo nmap -p "$targeted_ports" -sCV -Pn --min-rate 5000 "$target_ip" > targeted.txt

# Clean up temporary files
rm non_unknown_ports.txt

echo "Scan complete. Results saved in targeted.txt"
