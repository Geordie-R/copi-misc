#!/bin/bash

echo "Checking if your ISP is using CGNAT..."

# Function to check if an IP is in the CGNAT range (100.64.0.0/10)
is_cgnat_ip() {
    local ip="$1"

    # Convert IP to integer
    ip_int=$(printf "%u\n" $(echo "$ip" | awk -F'.' '{print ($1 * 256**3) + ($2 * 256**2) + ($3 * 256) + $4}'))

    # CGNAT range: 100.64.0.0 (1681915904) to 100.127.255.255 (1686110207)
    cgnat_start=1681915904  # 100.64.0.0
    cgnat_end=1686110207    # 100.127.255.255

    if [[ "$ip_int" -ge "$cgnat_start" && "$ip_int" -le "$cgnat_end" ]]; then
        echo "Yes, $ip is within the CGNAT range (100.64.0.0/10). This will be a problem hosting a node."
    else
        echo "You're good your IP $ip is NOT within the CGNAT range."
    fi
}

# Get the current WAN IP
wan_ip=$(curl -s ifconfig.me)

# Check if it's in the CGNAT range
echo "Checking your WAN IP: $wan_ip"
is_cgnat_ip "$wan_ip"
