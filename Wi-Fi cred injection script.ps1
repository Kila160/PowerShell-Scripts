### CODIGOS DE VALIDACAO DO NOME DOS ADAPTADORES DE REDE
# Get-NetAdapter | SELECT name, status, speed, fullduplex | where status -eq UP
# Get-NetAdapter | SELECT name, status, speed, fullduplex | where status -eq Disconnected
$netadapter = Get-NetAdapter | Where-Object Name -EQ Ethernet
function CheckCable{
    param(
    [parameter(Mandatory=$true)]
    $adapter
    )
if($adapter.status -ne "Up"){
        do{
# Detalhes principais da rede WIFI
$WirelessNetworkSSID = 'SSIDNAMEHERE'
$WirelessNetworkPassword = 'PASSWORDHERE'
$Authentication = 'WPA2PSK' # WPA2 also works
$Encryption = 'AES'

# Cria o perfil de WIFI num XML, e coloca o perfil para se autoconnectar
$WirelessProfile = @'
<WLANProfile xmlns="http://www.microsoft.com/networking/WLAN/profile/v1">
	<name>{0}</name>
	<SSIDConfig>
		<SSID>
			<name>{0}</name>
		</SSID>
	</SSIDConfig>
	<connectionType>ESS</connectionType>
	<connectionMode>auto</connectionMode>
	<MSM>
		<security>
			<authEncryption>
				<authentication>{2}</authentication>
				<encryption>{3}</encryption>
				<useOneX>false</useOneX>
			</authEncryption>
			<sharedKey>
				<keyType>passPhrase</keyType>
				<protected>false</protected>
				<keyMaterial>{1}</keyMaterial>
			</sharedKey>
		</security>
	</MSM>
</WLANProfile>
'@ -f $WirelessNetworkSSID, $WirelessNetworkPassword, $Authentication, $Encryption

# Crima o XML localmente na pasta TEMP
$random = Get-Random -Minimum 1111 -Maximum 99999999
$tempProfileXML = "$env:TEMP\tempProfile$random.xml"
$WirelessProfile | Out-File $tempProfileXML

# Adiciona o perfil WIFI e conecta
Start-Process netsh ('wlan add profile filename={0}' -f $tempProfileXML)

# Conecta a rede WIFI - apenas se necessitar (validação)
Start-Process netsh ('wlan connect name="{0}"' -f $WirelessNetworkSSID)
        }
        until($adapter.Status -eq "Disconnected")
    }
}
CheckCable -adapter $netadapter