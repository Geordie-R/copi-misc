

# Get the current public IP
try {
    $publicIP = ((Invoke-WebRequest ifconfig.me/ip).Content.Trim())
} catch {
    Write-Output "Error fetching public IP. Check your internet connection."
    exit 1
}



function Get-TracertHops {
    param (
        [string]$TargetIP
    )
 
    # Run tracert and capture output as an array of lines
    $traceroute_output = tracert -d "$TargetIP" 2>&1

    # Remove the first line (header) and last line ("Trace complete.")  
    $filtered_output = $traceroute_output | Select-Object -Skip 1 | Where-Object { 
        $_ -match "^\s*\d+\s+"  # Matches lines starting with a hop number (ignores empty lines)
    }
  
    # Count the number of hops
    return $filtered_output.Count
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









# Get the current public IP
try {
    $publicIP = ((Invoke-WebRequest ifconfig.me/ip).Content.Trim())
} catch {
    Write-Output "Error fetching public IP. Check your internet connection."
    exit 1
}

Write-Output "########## Checking for CGNAT ##########"
# Check if it's in the CGNAT range
Write-Output "Checking The IP: $publicIP"

# Get the number of hops


$hops = Get-TracertHops -TargetIP $publicIP




# Check the number of hops and return appropriate message
if ($hops -eq 1) {
    Write-Output "You're good CGNAT NOT detected"
} else {
    Write-Output "There were $hops hops detected. Possible CGNAT. Seek advice."
}
Write-Output "########################################"



