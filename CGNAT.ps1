
# Get the current public IP
try {
    $publicIP = ((Invoke-WebRequest ifconfig.me/ip).Content.Trim())
} catch {
    Write-Output "Error fetching public IP. Check your internet connection."
    exit 1
}

function Get-TracertHops {
    # Run tracert and capture the output
    $traceroute_output = tracert -d $wan_ip
    # Count the number of hops, excluding the first line
    $hop_count = ($traceroute_output | Select-Object -Skip 1).Count
    return $hop_count
}

# Get the number of hops
$hops = Get-TracertHops

# Check the number of hops and return appropriate message
if ($hops -eq 1) {
    Write-Output "You're good"
} else {
    Write-Output "There were $hops hops detected. Possible CGNAT. Seek advice."
}


function Convert-IPToInt {
    param ([string]$ip)
    $octets = $ip -split "\."
    return ([int64]$octets[0] * [math]::Pow(256, 3)) + 
           ([int64]$octets[1] * [math]::Pow(256, 2)) + 
           ([int64]$octets[2] * 256) + 
           [int64]$octets[3]
}

function Is-CGNATIP {
    param ([string]$ip)
    
    # Convert IP to integer
    $ipInt = Convert-IPToInt -ip $ip
    $cgnatStart = Convert-IPToInt -ip "100.64.0.0"
    $cgnatEnd = Convert-IPToInt -ip "100.127.255.255"

    if ($ipInt -ge $cgnatStart -and $ipInt -le $cgnatEnd) {
        Write-Output "Yes, $ip is within the CGNAT range (100.64.0.0/10). This will be a problem hosting a node."
    }
}




# Check if it's in the CGNAT range
Write-Output "Checking IP: $publicIP"
Is-CGNATIP -ip $publicIP
