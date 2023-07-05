#$credential = Get-Credential
#$credential | Export-CliXml -Path "C:\Users\%username%\documents\myCred_${env:USERNAME}_${env:COMPUTERNAME}.xml"

$credential = Import-CliXml -Path "C:\Users\%username%\documents\myCred_${env:USERNAME}_${env:COMPUTERNAME}.xml"
#Write-Host $credential
$credential.GetNetworkCredential().UserName
