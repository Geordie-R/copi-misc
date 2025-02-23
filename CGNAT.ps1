


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
    } else {
        Write-Output "You're good! Your IP $ip is NOT within the CGNAT range."
    }
}



# Get the current public IP
try {
    $publicIP = ((Invoke-WebRequest ifconfig.me/ip).Content.Trim())
} catch {
    Write-Output "Error fetching public IP. Check your internet connection."
    exit 1
}

# Check if it's in the CGNAT range
Write-Output "Checking IP: $publicIP"
Is-CGNATIP -ip $publicIP
