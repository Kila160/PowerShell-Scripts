## -----------------------------
## Enviar e-mails aos utilizadores onde a password ira° expirar em: 7,3,1 dia(s)
## -----------------------------

#Import AD Module
Import-Module ActiveDirectory

 
#Criar Avisos em dias
$SevenDayWarnDate = (get-date).adddays(7).ToLongDateString()
$ThreeDayWarnDate = (get-date).adddays(3).ToLongDateString()
$OneDayWarnDate = (get-date).adddays(1).ToLongDateString()
 
#Vari√°veis e-mail
$MailSender = " Lembrete Password <email@email.com> "
$Subject = '[ INFO ] - Your password will expire soon.'
$EmailStub1 = 'This e-mail was sent Automaticaly. The password for the user "'
$EmailStub2 = '" Will expire in '
$EmailStub3 = 'days(s) '
$EmailStub4 = ', change the password before the change..'
$SMTPServer = 'SMTPSERVERNAME.FQDN'
$port = '465'
$HTML = Get-Content "C:\Users\%username%\Documents\Template.html"
$HTML=$HTML|foreach-object {$_}
$DataeHora = (Get-Date).ToString()
 

$users = Get-ADUser -Server 'FQDN' -filter {Enabled -eq $True -and PasswordNeverExpires -eq $False -and PasswordLastSet -gt 0 } `
 -Properties "Name", "EmailAddress", "msDS-UserPasswordExpiryTimeComputed" | Select-Object -Property "Name", "EmailAddress", `
 @{Name = "PasswordExpiry"; Expression = {[datetime]::FromFileTime($_."msDS-UserPasswordExpiryTimeComputed").tolongdatestring() }}
 
#Verifica a data de expira√ß√£o da password e envia o e-mail ao confirmar essa informa√ß√£o
foreach ($user in $users) {
    $colaboradornome = $user.name.Replace('·','a').Replace('È','e').Replace('‡','a').Replace('Ì','i').Replace('Á','c').Replace('Í','e').Replace('„','a').Replace('ı','o')
    $colaboradorendereco = $user.EmailAddress

    #debugging here #
    #$colaboradorendereco = 'email@email.com'
    #debugging here #

     if ($user.PasswordExpiry -eq $SevenDayWarnDate) {
         $days = 7
         $EmailBody = $EmailStub1, $colaboradornome, $EmailStub2, $days, $EmailStub3, $SevenDayWarnDate, $EmailStub4 -join ' '
         
         $test = $HTML -replace ("#colaboradornome#",$colaboradornome) -replace ("#days#",$days) -replace ("#warning#",$SevenDayWarnDate) -replace ("#DataeHora#",$DataeHora)
         
         Send-MailMessage -To $colaboradorendereco -From $MailSender -SmtpServer $SMTPServer -Port $port -Subject $Subject -Body ($test | Out-String)  -BodyAsHtml -Priority High
         #Send-MailMessage -To $colaboradorendereco -From $MailSender -SmtpServer $SMTPServer -Port $port -Subject $Subject -Body $EmailBody -Priority High
     }
     elseif ($user.PasswordExpiry -eq $ThreeDayWarnDate) {
         $days = 3
         $EmailBody = $EmailStub1, $colaboradornome, $EmailStub2, $days, $EmailStub3, $ThreeDayWarnDate, $EmailStub4 -join ' '
           
         $test = $HTML -replace ("#colaboradornome#",$colaboradornome) -replace ("#days#",$days)  -replace ("#warning#",$ThreeDayWarnDate) -replace ("#DataeHora#",$DataeHora)

         Send-MailMessage -To $colaboradorendereco -From $MailSender -SmtpServer $SMTPServer -Port $port -Subject $Subject -Body ($test | Out-String) -BodyAsHtml -Priority High
     }
     elseif ($user.PasswordExpiry -eq $oneDayWarnDate) {
         $days = 1
         $EmailBody = $EmailStub1, $colaboradornome, $EmailStub2, $days, $EmailStub3, $OneDayWarnDate, $EmailStub4 -join ' '
         
         $test = $HTML -replace ("#colaboradornome#",$colaboradornome) -replace ("#days#",$days) -replace ("#warning#",$oneDayWarnDate) -replace ("#DataeHora#",$DataeHora)

         Send-MailMessage -To $colaboradorendereco -From $MailSender -SmtpServer $SMTPServer -Port $port -Subject $Subject -Body ($test | Out-String) -BodyAsHtml -Priority High
     }
    else {}
 }