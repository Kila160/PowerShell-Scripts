$wired = Get-NetAdapter | Where-Object {($_.name -like "Ethernet")}
$wifi = Get-NetAdapter | Where-Object {($_.name -like "Wi-Fi")}

# no wired 
#if ($wired -eq $null -and $wifi.Status -ne "up") {
#    $wifi | Enable-NetAdapter -Confirm:$false
#}

# no wifi
if ($wifi -eq $null -and $wired.Status -ne "up") {
    wired | Enable-NetAdapter -Confirm:$false
}

# all off
if ($wired -ne $null -and $wifi -ne $null -and $wired.status -ne "up" -and $wifi.status -ne "up") {
    $wired | Enable-NetAdapter -Confirm:$false
}

# all on
if ($wired -ne $null -and $wifi -ne $null -and $wired.status -eq "up" -and $wifi.status -eq "up") {
    $wifi | Disable-NetAdapter -Confirm:$false
}

# wifi on, wired off
if ($wired -ne $null -and $wifi -ne $null -and $wired.status -ne "up" -and $wifi.status -eq "up") {
    $wired | Enable-NetAdapter -Confirm:$false
    $wifi | Disable-NetAdapter -Confirm:$false
}