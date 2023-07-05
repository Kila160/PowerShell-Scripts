#Check for Connected USB and order them by type
gwmi Win32_USBControllerDevice |%{[wmi]($_.Dependent)} | Sort Manufacturer,Description,DeviceID | Ft -GroupBy Manufacturer Description,Service,DeviceID


#Get Credencials and save "file"
$credential = Get-Credential
$credential | Export-CliXml -Path "C:\Users\%username%\documents\myCred_${env:USERNAME}_${env:COMPUTERNAME}.xml"


#Import saved Credencials
$credential = Import-CliXml -Path 'C:\Users\%username%\documents\myCred_${env:USERNAME}_${env:COMPUTERNAME}.xml'


################# Check for logged in users on $computer #################
#Older PC's | Windows XP - 7
Get-WmiObject –ComputerName CLIENT1 –Class Win32_ComputerSystem | Select-Object UserName

#New Pc's | Windows 8 - 10
Get-CimInstance –ComputerName CLIENT1 –ClassName Win32_ComputerSystem | Select-Object UserName


#Check for User Net user /domain Info (Locked, name, user, Last password, Last password change, etc)
$user = "usernamehere"
net user $user /domain > C:\Users\%username%\Documents\User_$user.txt

$test = get-content C:\Users\%username%\Documents\User_$user.txt -ReadCount 1000 | foreach { $_ -match "User Name" }
$test2 = get-content C:\Users\%username%\Documents\User_$user.txt -ReadCount 1000 | foreach { $_ -match "Full Name" }
$test3 = get-content C:\Users\%username%\Documents\User_$user.txt -ReadCount 1000 | foreach { $_ -match "Password last set" }
$test4 = get-content C:\Users\%username%\Documents\User_$user.txt -ReadCount 1000 | foreach { $_ -match "Password changeable" }
$test5 = get-content C:\Users\%username%\Documents\User_$user.txt -ReadCount 1000 | foreach { $_ -match "Account Active" }

Write-Host $teste
$test2
$test3
$test4
$test5


#Check active
$contents = Get-Content C:\Users\%username%\Documents\User_username.txt
foreach ($line in $contents) {
  if ($line -match 'Active') { 
    Write-Host "Exists"
  }
  else {
   Write-Host "No"
  }
}


#All doc search
$contents = Get-Content C:\Users\UID01551\Documents\User_username.txt
if ($contents -match "Account Active") {
    Write-Host "Y"
 }else {
Write-Host "No"
}

#After starting the PSExec session
#CMD - Send a message to the users PC.
msg * /v /w Mensage here

#Check logged users
Get-WmiObject –ComputerName PCNAMEHERE –Class Win32_ComputerSystem | Select-Object UserName