$computer = "COMPUTERNAME.FQDN"
$PSExec = "PSExec DIR HERE"
$LoggedUser = "FQDN\sysadmin"

#$User = Read-Host "Enter username"
#$Pass = Read-Host "Enter password"

#Start-Process -Filepath "$PSExec" -ArgumentList "\\$computer -u $user -p $pass $command"

Start-Process -Filepath "$PSExec" -Credential "$LoggedUser" -ArgumentList "\\$computer cmd"