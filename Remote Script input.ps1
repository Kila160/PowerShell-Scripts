Add-Type -AssemblyName PresentationCore
Add-Type -AssemblyName WindowsBase

$cred=Get-Credential
$sess = New-PSSession -Credential $cred -ComputerName "PCname.FQDN"
Enter-PSSession $sess


#Get number of connected monitors
$Monitor_Count = (Get-CimInstance -Namespace root\wmi -ClassName WmiMonitorBasicDisplayParams | where {$_.Active -like "True"}).Active.Count

Write-Host "Nrº Monitors: " + $Monitor_Count + "Teste"

Get-PSDrive | Where {$_.Free -gt 0}

#Exit-PSSession
#Remove-PSSession $sess

#>