#!/bin/bash

#Given an Ip, proceeds to first do a sync scan with nmap and after saving the ouput in a txt file it scans looking for vulns and exports it to a file
# Check if an argument is provided
if [ $# -eq 0 ]; then
    echo "Please provide an IP address as an argument."
    exit 1
fi

# Define the target IP
target_ip="$1"

# Launch initial nmap scan
nmap -p- -sS -Pn --min-rate 5000 "$target_ip" | grep -E "^[0-9]+/tcp\s+open" | cut -d'/' -f 1 > non_unknown_ports.txt

# Create a comma-separated list of non-unknown ports
targeted_ports=$(cat non_unknown_ports.txt | tr '\n' ',' | sed 's/,$//')

# Launch targeted nmap scan
sudo nmap -p "$targeted_ports" -sCV -Pn --min-rate 5000 "$target_ip" > targeted.txt

# Clean up temporary files
rm non_unknown_ports.txt

echo "Scan complete. Results saved in targeted.txt"
