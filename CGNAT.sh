#!/bin/bash

echo "Checking if your ISP is using CGNAT..."
# Get the current WAN IP
wan_ip=$(curl -s ifconfig.me)

GetTracertHops() {
    traceroute_output=$(traceroute $wan_ip)
    hop_count=$(echo "$traceroute_output" | tail -n +2 | wc -l)
    echo "$hop_count"
}

hops=$(GetTracertHops)

if [ "$hops" -eq 1 ]; then
    echo "You're good"
else
    echo "There were $hops hops detected. Possible CGNAT. Seek advice."
fi


# Function to check if an IP is in the CGNAT range (100.64.0.0/10)
is_cgnat_ip() {
    local ip="$1"

    # Convert IP to integer
    ip_int=$(printf "%u\n" $(echo "$ip" | awk -F'.' '{print ($1 * 256**3) + ($2 * 256**2) + ($3 * 256) + $4}'))

    # CGNAT range: 100.64.0.0 (1681915904) to 100.127.255.255 (1686110207)
    cgnat_start=1681915904  # 100.64.0.0
    cgnat_end=1686110207    # 100.127.255.255

    if [[ "$ip_int" -ge "$cgnat_start" && "$ip_int" -le "$cgnat_end" ]]; then
        echo "Your IP $wan_ip is within a typical CGNAT range (100.64.0.0/10)."
    fi
}
is_cgnat_ip "$wan_ip"
