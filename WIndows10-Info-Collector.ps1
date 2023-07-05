$ErrorActionPreference = "SilentlyContinue"

$time = (get-date).ToString("dd/MM/yyyy HH:mm:ss")
"Time: $time"


"Computer: $env:computername"


"*****************FIREWALL STATUS**********************"
Get-NetFirewallProfile

"*****************FIREWALL INBOUND**********************"
netsh advfirewall show allprofiles

"*****************FIREWALL OUTBOUND**********************"
netsh advfirewall show allprofiles

"*****************FIREWALL RULES***********************" 
Get-NetFirewallRule | Sort-Object Enabled

"*****************WINDOWS DEFENDER STATUS***********************" 
Get-Service -Name "*windefend*"

"*******************ALL SERVICES***************************" 
$service = Get-Service | Sort-Object Status -Descending | Format-Table
$service

"**************UNQUOTED SERVICE PATH*******************"
cmd.exe /c 'wmic service get name,displayname,pathname,startmode |findstr /i "auto" |findstr /i /v "c:\windows\\" |findstr /i /v """'

"**************RECOVERY*******************"
Get-WmiObject win32_osrecoveryConfiguration  -Property WriteToSystemLog

"***************NETWORK INTERFACES*********************" 
ipconfig /all

"*********************PORTS****************************" 
netstat -ano

"****************LISTENING PORTS***********************" 
Get-NetTCPConnection -State Listen

"******************ARP TABLE***************************" 
arp -a

"****************SNMP Service**************************" 
Get-Service SNMPTRAP | Format-List -Property Name, Status
Get-Service SNMP | Format-List -Property Name, Status
Get-Service nscp | Format-List -Property Name, Status
 
"*****************TCP/IP STACK*************************" 
Get-ItemProperty -Path Registry::HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\services\Tcpip\Parameters

"******************RDP USERS***************************" 
net localgroup "Usuarios de escritorio remoto"
net localgroup "Remote Desktop Users"

"********************SSL 2.0 CLIENT********************" 
Get-ItemProperty -Path 'Registry::HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\Control\SecurityProviders\SCHANNEL\Protocols\SSL 2.0\Client'

"********************SSL 2.0 SERVER********************" 
Get-ItemProperty -Path 'Registry::HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\Control\SecurityProviders\SCHANNEL\Protocols\SSL 2.0\Server'

"*******************SSL 3.0 CLIENT*********************" 
Get-ItemProperty -Path 'Registry::HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\Control\SecurityProviders\SCHANNEL\Protocols\SSL 3.0\Client'

"*******************SSL 3.0 SERVER*********************" 
Get-ItemProperty -Path 'Registry::HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\Control\SecurityProviders\SCHANNEL\Protocols\SSL 3.0\Server'

"*******************TLS 1.0 CLIENT*********************" 
Get-ItemProperty -Path 'Registry::HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\Control\SecurityProviders\SCHANNEL\Protocols\TLS 1.0\Client'

"*******************TLS 1.0 SERVER*********************" 
Get-ItemProperty -Path 'Registry::HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\Control\SecurityProviders\SCHANNEL\Protocols\TLS 1.0\Server'

"*******************TLS 1.1 CLIENT*********************" 
Get-ItemProperty -Path 'Registry::HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\Control\SecurityProviders\SCHANNEL\Protocols\TLS 1.1\Client'

"*******************TLS 1.1 SERVER*********************" 
Get-ItemProperty -Path 'Registry::HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\Control\SecurityProviders\SCHANNEL\Protocols\TLS 1.1\Server'

"*******************TLS 1.2 CLIENT*********************" 
Get-ItemProperty -Path 'Registry::HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\Control\SecurityProviders\SCHANNEL\Protocols\TLS 1.2\Client'

"*******************TLS 1.2 SERVER*********************" 
Get-ItemProperty -Path 'Registry::HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\Control\SecurityProviders\SCHANNEL\Protocols\TLS 1.2\Server'


"*******************REMOTE REGISTRY*********************" 
Get-ItemProperty -Path 'Registry::HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\Services\RemoteRegistry'

"*******************OS UPGRADE*********************" 
Get-ItemProperty -Path 'Registry::HKEY_LOCAL_MACHINE\SOFTWARE\Policies\Microsoft\WindowsStore'

"*******************WINDOWS REMOTE MANAGEMENT*********************" 
Get-ItemProperty -Path 'Registry::HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\Services\WinRM'

"**************SECURITY OPTIONS************************" 
secedit /export /areas SECURITYPOLICY /cfg securityPolicy.txt
Get-Content .\securityPolicy.txt
Remove-Item .\securityPolicy.txt

"********************USERS BY DEFAULT******************" 
net localgroup "Usuarios"
net localgroup "Users"

"****************SYSTEM INFORMATION********************"
systeminfo.exe

"************************1USERS************************" 
net localgroup "Usuarios"
net localgroup "Users"

"************************GROUPS************************" 
net localgroup 

"******************AUTOMATIC LOGON********************" 
Get-ItemProperty -Path 'Registry::HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Winlogon\AutoLogonChecked'
Get-ItemProperty -Path 'Registry::HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Winlogon'

"**********************NTP*****************************" 
w32tm /query /status

"********************EVENT LOG*************************"
auditpol /get /category:* 

"******************EVENTLOG LIST***********************" 
Get-EventLog -List | Select-Object LogDisplayName, MaximumKilobytes


"******************SYSTEM EVENTS***********************" 
$EndDate = Get-EventLog -Newest 1 -LogName "System" | Select-Object TimeGenerated
$EndDateDateTime = Get-Date $EndDate.TimeGenerated
$StartDate = (Get-Date)
New-TimeSpan -Start $StartDate -end $EndDateDateTime

"***************APPLICATION EVENTS*********************" 
$Enddate = Get-EventLog -Newest 1 -LogName "Application" | Select-Object TimeGenerated 
$EndDateDateTime = Get-Date $EndDate.TimeGenerated
$StartDate = (Get-Date)
New-TimeSpan -Start $StartDate -end $EndDateDateTime

"*****************SECURITY EVENTS**********************" 
$Enddate = Get-EventLog -Newest 1 -LogName "Security" | Select-Object TimeGenerated
$EndDateDateTime = Get-Date $EndDate.TimeGenerated
$StartDate = (Get-Date)
New-TimeSpan -Start $StartDate -end $EndDateDateTime

"************SYSTEM LOGS PERMISSIONS*******************" 
Get-Acl "C:\Windows\System32\winevt\Logs\System.evtx"

"************APPLICATION LOGS PERMISSIONS*******************" 
Get-Acl "C:\Windows\System32\winevt\Logs\Application.evtx"

"************SECURITY LOGS PERMISSIONS*******************" 
Get-Acl "C:\Windows\System32\winevt\Logs\Security.evtx"

"******************PENDING UPDATES*********************"
$UpdateSession = New-Object -ComObject Microsoft.Update.Session
$UpdateSearcher = $UpdateSession.CreateupdateSearcher()
$Updates = @($UpdateSearcher.Search("IsHidden=0 and IsInstalled=0").Updates)
$Updates | Select-Object Title


"************WINDOWS UPDATE CONFIG********************"
Get-ItemProperty -Path 'Registry::HKEY_LOCAL_MACHINE\Software\Policies\Microsoft\Windows\WindowsUpdate\AU'
Get-ItemProperty -Path 'Registry::HKEY_LOCAL_MACHINE\Software\Policies\Microsoft\Windows\WindowsUpdate\'

"********************2USERS BY GROUP********************" 
$adsi = [ADSI]"WinNT://$env:COMPUTERNAME"

$adsi.Children | where {$_.SchemaClassName -eq 'user'} | Foreach-Object {
    $groups = $_.Groups() | Foreach-Object {$_.GetType().InvokeMember("Name", 'GetProperty', $null, $_, $null)}
    $_ | Select-Object @{n='UserName';e={$_.Name}},@{n='Groups';e={$groups -join ';'}}
} | Format-Table -Wrap

"****************DISK INFORMATION**********************" 
Get-WmiObject -Class Win32_LogicalDisk |
    Where-Object {$_.DriveType -ne 5} |
    Sort-Object -Property Name | 
    Select-Object Name, VolumeName, VolumeSerialNumber,SerialNumber, FileSystem, Description, VolumeDirty, `
        @{"Label"="DiskSize(GB)";"Expression"={"{0:N}" -f ($_.Size/1GB) -as [float]}}, `
        @{"Label"="FreeSpace(GB)";"Expression"={"{0:N}" -f ($_.FreeSpace/1GB) -as [float]}}, `
        @{"Label"="%Free";"Expression"={"{0:N}" -f ($_.FreeSpace/$_.Size*100) -as [float]}} |
    Format-Table -AutoSize

"**************INSTALLED PROGRAMS**********************" 
Get-WmiObject -Class Win32_Product | Select Name, Version 
"
Información de Uninstall 32 bits:"
Get-ItemProperty HKLM:\Software\Wow6432Node\Microsoft\Windows\CurrentVersion\Uninstall\* | Select-Object DisplayName, DisplayVersion, Publisher, InstallDate |
Format-Table –AutoSize

"
Información de Uninstall nativos:"

Get-ItemProperty HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Uninstall\* | Select-Object DisplayName, DisplayVersion, Publisher, InstallDate |
Format-Table –AutoSize

"*******************************************************"