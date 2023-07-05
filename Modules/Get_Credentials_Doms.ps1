[CmdletBinding()]
Param (
	[Parameter(Mandatory = $False)]
	[Int]$MaxAttempts = 5
)

# Prompt for Credentials and verify them using the DirectoryServices.AccountManagement assembly.
Write-Host "Please provide your credentials so the script can continue."
Add-Type -AssemblyName System.DirectoryServices.AccountManagement
# Extract the current user's domain and also pre-format the user name to be used in the credential prompt.
If (!(Test-Path "$ScriptDir\myCred_${env:USERNAME}_${env:COMPUTERNAME}_FV.xml"))
{
$UserDomain = $env:USERDOMAIN
$UserName = "$UserDomain\"
# Define the starting number (always #1) and the initial credential prompt message to use.
$Attempt = 1
$CredentialPrompt = "Introduza a sua password associada a conta sysadmin (tentativa #$Attempt de $MaxAttempts):"
# Set ValidAccount to false so it can be used to exit the loop when a valid account is found (and the value is changed to $True).
$ValidAccount = $False

# Loop through prompting for and validating credentials, until the credentials are confirmed, or the maximum number of attempts is reached.
Do {
	# Blank any previous failure messages and then prompt for credentials with the custom message and the pre-populated domain\user name.
	$FailureMessage = $Null
	$Credentials = Get-Credential -UserName $UserName -Message $CredentialPrompt
	# Verify the credentials prompt wasn't bypassed.
	If ($Credentials) {
		# If the user name was changed, then switch to using it for this and future credential prompt validations.
		If ($Credentials.UserName -ne $UserName) {
			$UserName = $Credentials.UserName
		}
		# Test the user name (even if it was changed in the credential prompt) and password.
		$ContextType = [System.DirectoryServices.AccountManagement.ContextType]::Domain
		Try {
			$PrincipalContext = New-Object System.DirectoryServices.AccountManagement.PrincipalContext $ContextType,$UserDomain
		} Catch {
			If ($_.Exception.InnerException -like "*Não foi possivel contactar este servidor*") {
				$FailureMessage = "Não foi possível contactar o servidor do domínio especificado na tentativa #$Attempt de $MaxAttempts."
			} Else {
				$FailureMessage = "Erro não esperado: `"$($_.Exception.Message)`" na tentativa #$Attempt de $MaxAttempts."
			}
		}
		# If there wasn't a failure talking to the domain test the validation of the credentials, and if it fails record a failure message.
		If (-not($FailureMessage)) {
			$ValidAccount = $PrincipalContext.ValidateCredentials($UserName,$Credentials.GetNetworkCredential().Password)
			If (-not($ValidAccount)) {
				$FailureMessage = "Utilizador ou password incorreta na tentativa da busca de credenciais #$Attempt de $MaxAttempts."
			}
		}
	# Otherwise the credential prompt was (most likely accidentally) bypassed so record a failure message.
	} Else {
		$FailureMessage = "Prompt de credenciais fechado/skipped na tentativa #$Attempt de $MaxAttempts."
	}

	# If there was a failure message recorded above, display it, and update credential prompt message.
	If ($FailureMessage) {
		Write-Warning "$FailureMessage"
		$Attempt++
		If ($Attempt -lt $MaxAttempts) {
			$CredentialPrompt = "Erro de autenticação. Por favor tente de novo. (tentativa #$Attempt de $MaxAttempts):"
		} ElseIf ($Attempt -eq $MaxAttempts) {
			$CredentialPrompt = "Erro de autenticação. ÚLTIMA CHANCE (tentativa #$Attempt de $MaxAttempts):"
		}
	}
} Until (($ValidAccount) -or ($Attempt -gt $MaxAttempts))

# If the credentials weren't successfully verified, then exit the script, otherwise pass them through for further use.
Write-Host ""
If (-not($ValidAccount)) {
	Write-Host -ForegroundColor Red "Falhou $MaxAttemps vezes na introdução de credenciais válidas. Fechando a script... "
	EXIT
} Else {
	Write-Host 'Your confirmed credentials have been saved to the $Credentials variable and is available after this script finishes.'
	#$Global:Credentials = $Credentials
    $Global:Credentials | Export-CliXml -Path "$ScriptDir\myCred_${env:USERNAME}_${env:COMPUTERNAME}_FV.xml"
}

}
else
{
Write-Host "FV EXISTS"
}
If (!(Test-Path "$ScriptDir\myCred_${env:USERNAME}_${env:COMPUTERNAME}_FQDN.xml"))
{
$UserDomain = $env:USERDOMAIN
$UserName = "FQDN\"
# Define the starting number (always #1) and the initial credential prompt message to use.
$Attempt = 1
$CredentialPrompt = "Introduza a sua password associada a conta sysadmin (tentativa #$Attempt de $MaxAttempts):"
# Set ValidAccount to false so it can be used to exit the loop when a valid account is found (and the value is changed to $True).
$ValidAccount = $False

# Loop through prompting for and validating credentials, until the credentials are confirmed, or the maximum number of attempts is reached.
Do {
	# Blank any previous failure messages and then prompt for credentials with the custom message and the pre-populated domain\user name.
	$FailureMessage = $Null
	$Credentials = Get-Credential -UserName $UserName -Message $CredentialPrompt
	# Verify the credentials prompt wasn't bypassed.
	If ($Credentials) {
		# If the user name was changed, then switch to using it for this and future credential prompt validations.
		If ($Credentials.UserName -ne $UserName) {
			$UserName = $Credentials.UserName
		}
		# Test the user name (even if it was changed in the credential prompt) and password.
		$ContextType = [System.DirectoryServices.AccountManagement.ContextType]::Domain
		Try {
			$PrincipalContext = New-Object System.DirectoryServices.AccountManagement.PrincipalContext $ContextType,$UserDomain
		} Catch {
			If ($_.Exception.InnerException -like "*Não foi possivel contactar este servidor*") {
				$FailureMessage = "Não foi possível contactar o servidor do domínio especificado na tentativa #$Attempt de $MaxAttempts."
			} Else {
				$FailureMessage = "Erro não esperado: `"$($_.Exception.Message)`" na tentativa #$Attempt de $MaxAttempts."
			}
		}
		# If there wasn't a failure talking to the domain test the validation of the credentials, and if it fails record a failure message.
		If (-not($FailureMessage)) {
			$ValidAccount = $PrincipalContext.ValidateCredentials($UserName,$Credentials.GetNetworkCredential().Password)
			If (-not($ValidAccount)) {
				$FailureMessage = "Utilizador ou password incorreta na tentativa da busca de credenciais #$Attempt de $MaxAttempts."
			}
		}
	# Otherwise the credential prompt was (most likely accidentally) bypassed so record a failure message.
	} Else {
		$FailureMessage = "Prompt de credenciais fechado/skipped na tentativa #$Attempt de $MaxAttempts."
	}

	# If there was a failure message recorded above, display it, and update credential prompt message.
	If ($FailureMessage) {
		Write-Warning "$FailureMessage"
		$Attempt++
		If ($Attempt -lt $MaxAttempts) {
			$CredentialPrompt = "Erro de autenticação. Por favor tente de novo. (tentativa #$Attempt de $MaxAttempts):"
		} ElseIf ($Attempt -eq $MaxAttempts) {
			$CredentialPrompt = "Erro de autenticação. ÚLTIMA CHANCE (tentativa #$Attempt de $MaxAttempts):"
		}
	}
} Until (($ValidAccount) -or ($Attempt -gt $MaxAttempts))

# If the credentials weren't successfully verified, then exit the script, otherwise pass them through for further use.
Write-Host ""
If (-not($ValidAccount)) {
	Write-Host -ForegroundColor Red "Falhou $MaxAttemps vezes na introdução de credenciais válidas. Fechando a script... "
	EXIT
} Else {
	Write-Host 'Your confirmed credentials have been saved to the $Credentials variable and is available after this script finishes.'
	#$Global:Credentials = $Credentials
    $Global:Credentials | Export-CliXml -Path "$ScriptDir\myCred_${env:USERNAME}_${env:COMPUTERNAME}_FQDN.xml"
}

}
else
{
Write-Host "FQDN EXISTS"
}