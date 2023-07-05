Add-Type -AssemblyName PresentationCore
Add-Type -AssemblyName WindowsBase

#MAIN_SCRIPT DIR | FIX TEMP PARA PROBLEMA DE DIR
$ScriptDir = Split-Path $script:MyInvocation.MyCommand.Path

#MODULES
Import-Module -Name "$ScriptDir\Modules\Custom_WPF_Powershell_Module.psm1"
Import-Module -Name "$ScriptDir\Modules\Get_Monitor_info.psm1"
Import-Module -Name "$ScriptDir\Modules\Get_Credentials_Doms.psm1"

#VERIFY IF GETCRED.XML IS OLDER THAN 7 DAYS | IF TRUE DELETES AND ASKS TO CREATE A NEW CREDENTIAL SESSION AGAIN, IF FALSE THEN REUSES THE PREVIOUS EXISTING FILE

##
###
####    Company FQDN here if you see this: "myCred_${env:USERNAME}_${env:COMPUTERNAME}.xml"
#####
######

if (!(Test-Path "$ScriptDir\myCred_${env:USERNAME}_${env:COMPUTERNAME}_FV.xml"))
{
Get_Cred
#$credential = Get-Credential
#$credential | Export-CliXml -Path "$ScriptDir\myCred_${env:USERNAME}_${env:COMPUTERNAME}.xml"
Add-Content -path $ScriptDir\log.txt -value "`r[$(get-date)] - Creating new mycred.xml..."
}
else
{
Add-Content -path $ScriptDir\log.txt -value "`r[$(get-date)] - Validation 1 on mycred existance..."
}

$credpathFV = "$ScriptDir\myCred_${env:USERNAME}_${env:COMPUTERNAME}_FV.xml"
$chkcredage = Test-Path $credpathFV -OlderThan (Get-Date).AddDays(-1)

if($chkcredage -eq $true){
Remove-Item "$ScriptDir\myCred_${env:USERNAME}_${env:COMPUTERNAME}_FV.xml"
Add-Content -path $ScriptDir\log.txt -value "`r[$(get-date)] - Deleting old mycred.xml"
#$credential = Get-Credential
#$credential | Export-CliXml -Path "$ScriptDir\myCred_${env:USERNAME}_${env:COMPUTERNAME}.xml"
Add-Content -path $ScriptDir\log.txt -value "`r[$(get-date)] - Creating new mycred.xml"
}else{
Add-Content -path $ScriptDir\log.txt -value "`r[$(get-date)] - mycred is not older than 7 days"
$credentialimpFV = Import-CliXml -Path "$ScriptDir\myCred_${env:USERNAME}_${env:COMPUTERNAME}_FV.xml"
$HD_Username = $credentialimpFV.GetNetworkCredential().UserName
}


[xml]$inputXML = @"
<Window 
xmlns="http://schemas.microsoft.com/winfx/2006/xaml/presentation" 
Title="All-in-One Tool v1.0.0.1" Width="750" Height="810" Background="#FF212121" Icon="$ScriptDir\Icons\logo_32x32.ICO" ResizeMode="NoResize" WindowStartupLocation="CenterScreen">
   <Grid Margin="0,0,0,-2">
      <Image Height="70" Margin="256,8,256,0" VerticalAlignment="Top" Source="$ScriptDir\Icons\Logo_wamos.png" Stretch="None" />
      <Label Width="236" Margin="489,734,0,0" HorizontalAlignment="Left" VerticalAlignment="Top" Content="Copyright © 2020, Bruno Silva under MIT LICENSE" Foreground="#FFD8D9DA" FontSize="10"/>
      <TabControl Name="TabCtrl" Height="349" Margin="39,56,39,0" VerticalAlignment="Top">
         <TabItem Name="Validacoes_Tab" BorderBrush="#FFACACAC" Header="Validations">
            <Grid Background="#FF393939">
               <Grid.ColumnDefinitions>
                  <ColumnDefinition Width="53*" />
                  <ColumnDefinition Width="277*" />
               </Grid.ColumnDefinitions>
               <GroupBox Grid.ColumnSpan="2" Height="100" Margin="10,2,10,0" VerticalAlignment="Top" BorderBrush="#FF1BDC08" Foreground="White" Header="User Validations" />
               <TextBox Name="AD_Username" Grid.ColumnSpan="2" Width="120" Height="24" Margin="92,23,0,0" HorizontalAlignment="Left" VerticalAlignment="Top" CharacterCasing="Upper" MaxLength="13" MaxLines="1" TabIndex="1" Text="" TextWrapping="Wrap" />
               <Label Margin="16,20,0,0" HorizontalAlignment="Left" VerticalAlignment="Top" Content="Username:" FontSize="14" Foreground="White" />
               <Button Name="User_info" Grid.Column="1" Width="82" Height="22" Margin="121,24,0,0" HorizontalAlignment="Left" VerticalAlignment="Top" TabIndex="3">
                  <StackPanel Orientation="Horizontal">
                    <Image Height="16" Source="$ScriptDir\Icons\User_info.png" />
                     <TextBlock FontWeight="Bold" Text=" User Info" />
                  </StackPanel>
               </Button>
               <Button Name="CoofStateBtn" Grid.Column="1" Width="145" Height="22" Margin="215,24,0,0" IsEnabled="False" HorizontalAlignment="Left" VerticalAlignment="Top" TabIndex="4">
                  <StackPanel Orientation="Horizontal">
                    <Image Height="16" Source="$ScriptDir\Icons\out_office.png" />
                     <TextBlock FontWeight="Bold" Text=" Check Out-of-Office" />
                  </StackPanel>
               </Button>
               <GroupBox Grid.ColumnSpan="2" Height="181" Margin="10,118,10,0" VerticalAlignment="Top" BorderBrush="#FF1BDC08" Foreground="White" Header="Validações PC">
                  <ComboBox Name="ComboBoxDom" Height="24" Margin="220,6,278,0" VerticalAlignment="Top" SelectedIndex="0">
                    <ComboBoxItem Content="FQDN1" />
                    <ComboBoxItem Content="FQDN2" />
                  </ComboBox>
               </GroupBox>
               <TextBox Name="AD_Computer" Grid.Column="1" Width="120" Height="24" Margin="4.339,141,0,0" HorizontalAlignment="Left" VerticalAlignment="Top" CharacterCasing="Upper" MaxLength="13" MaxLines="1" TabIndex="5" Text="" TextWrapping="Wrap" />
               <Label Grid.ColumnSpan="2" Margin="16,137,0,0" HorizontalAlignment="Left" VerticalAlignment="Top" Content="Computador:" FontSize="14" Foreground="White" />
               <Label Grid.Column="1" Margin="44,254,0,0" HorizontalAlignment="Left" VerticalAlignment="Top" Content="-- Placeholder Text IGNORE --" FontSize="14" Foreground="White" />
               <Ellipse Grid.Column="1" Margin="405,137,25,67" Stroke="Black">
                  <Ellipse.Fill>
                  <ImageBrush ImageSource="$ScriptDir\Icons\piechart_exmaple.png" />  
                  </Ellipse.Fill>
               </Ellipse>
               <Button Name="Delete_LixoBtn" Grid.Column="1" Width="92" Height="20" Margin="137,178,0,0" IsEnabled="False" HorizontalAlignment="Left" VerticalAlignment="Top" TabIndex="10">
                  <StackPanel Orientation="Horizontal">
                      <Image Height="16" Source="$ScriptDir\Icons\deletetrash.png" />
                     <TextBlock FontWeight="Bold" Text=" Delete trash" />
                  </StackPanel>
               </Button>
               <Button Name="Chck_Logg_UsersBtn" Grid.Column="1" Width="118" Height="20" IsEnabled="False" Margin="241,178,0,0" HorizontalAlignment="Left" VerticalAlignment="Top" TabIndex="11">
                  <StackPanel Orientation="Horizontal">
                  <Image Height="16" Source="$ScriptDir\Icons\loggedinusers.png" />
                     <TextBlock FontWeight="Bold" Text=" Logged in Users" />
                  </StackPanel>
               </Button>
               <Button Name="Remote_CMDBtn" Grid.Column="1" Width="102" Height="20" IsEnabled="true" Margin="79,209,0,0" HorizontalAlignment="Left" VerticalAlignment="Top" TabIndex="7">
                  <StackPanel Orientation="Horizontal">
                   <Image Height="16" Source="$ScriptDir\Icons\remote_cmd.png" />
                     <TextBlock FontWeight="Bold" Text=" Remote CMD" />
                  </StackPanel>
               </Button>
               <Button Name="Remote_dsk_explorerBtn" Grid.ColumnSpan="2" Width="146" Height="20" IsEnabled="False" Margin="30,209,0,0" HorizontalAlignment="Left" VerticalAlignment="Top" TabIndex="12">
                  <StackPanel Orientation="Horizontal">
                  <Image Height="16" Source="$ScriptDir\Icons\explorer.png" />
                     <TextBlock FontWeight="Bold" Text=" Remote Disk Explorer" />
                  </StackPanel>
               </Button>
               <Button Name="DiskSpaceBtn" Grid.Column="1" Width="89" Height="21" Margin="423,264,0,0" HorizontalAlignment="Left" VerticalAlignment="Top" TabIndex="13">
                  <StackPanel Orientation="Horizontal">
                  <Image Height="16" Source="$ScriptDir\Icons\piechart.png" />
                     <TextBlock FontWeight="Bold" Text=" Disk Space" />
                  </StackPanel>
               </Button>
               <Button Name="PC_ConnectBtn" Grid.Column="1" Width="79" Height="21" IsEnabled="False" Margin="270,143,0,0" HorizontalAlignment="Left" VerticalAlignment="Top" TabIndex="6">
                  <StackPanel Orientation="Horizontal">
                    <Image Height="16" Source="$ScriptDir\Icons\connect.png" />
                     <TextBlock FontWeight="Bold" Text=" Connect" />
                  </StackPanel>
               </Button>
               <Button Name="Monitor_infoBtn" Grid.ColumnSpan="2" IsEnabled="true" Width="103" Height="20" Margin="30,178,0,0" HorizontalAlignment="Left" VerticalAlignment="Top" TabIndex="8">
                  <StackPanel Orientation="Horizontal">
                    <Image Height="16" Source="$ScriptDir\Icons\monitor.png" />
                     <TextBlock FontWeight="Bold" Text=" Monitor Info" />
                  </StackPanel>
               </Button>
               <Button Name="Reset_GPSBtn" Grid.Column="1" Width="93" Height="20" IsEnabled="False" Margin="35,178,0,0" HorizontalAlignment="Left" VerticalAlignment="Top" TabIndex="9">
                  <StackPanel Orientation="Horizontal">
                  <Image Height="16" Source="$ScriptDir\Icons\REDACTED.png" />
                     <TextBlock FontWeight="Bold" Text=" Reset REDACTED" />
                  </StackPanel>
               </Button>
            </Grid>
         </TabItem>
         <TabItem Name="OOF_Tab" Header="Out of office">
            <Grid Background="#FF393939">
               <Label Margin="10,10,0,0" HorizontalAlignment="Left" VerticalAlignment="Top" Content="Username/E-mail:" FontSize="14" Foreground="White" />
               <TextBox Name="AD_UserEmail" Width="235" Height="24" Margin="134,14,0,0" HorizontalAlignment="Left" VerticalAlignment="Top" CharacterCasing="Upper" IsEnabled="False" MaxLength="41" MaxLines="1" TabIndex="1" Text="" TextWrapping="Wrap" />
               <CheckBox Name="Env_apenasBTN" Margin="402,18,0,0" HorizontalAlignment="Left" VerticalAlignment="Top" Content="Send only between (Start/End)" FontSize="14" Foreground="White" IsEnabled="False" TabIndex="2" />
               <Label Margin="13,51,0,0" HorizontalAlignment="Left" VerticalAlignment="Top" Content="Start:" FontSize="14" Foreground="White" />
               <DatePicker Name="Date_inicio" Margin="60,55,0,0" HorizontalAlignment="Left" VerticalAlignment="Top" Cursor="" IsEnabled="False" SelectedDateFormat="Short" TabIndex="3" />
               <Label Margin="196,52,0,0" HorizontalAlignment="Left" VerticalAlignment="Top" Content="End:" FontSize="14" Foreground="White" />
               <DatePicker Name="Date_fim" Margin="234,56,0,0" HorizontalAlignment="Left" VerticalAlignment="Top" Cursor="" IsEnabled="False" IsTodayHighlighted="False" SelectedDateFormat="Short" TabIndex="4" />
               <Label Margin="7,91,0,0" HorizontalAlignment="Left" VerticalAlignment="Top" Content="Internal OOF Message:" FontSize="14" Foreground="White" />
               <RichTextBox Name="Msg_int" Height="157" Margin="10,120,340,0" VerticalAlignment="Top" Background="#BF545454" Foreground="White" IsEnabled="False" IsReadOnly="False" TabIndex="5" VerticalScrollBarVisibility="Auto">
                  <FlowDocument>
                     <Paragraph>
                        <Run Text="" />
                     </Paragraph>
                  </FlowDocument>
               </RichTextBox>
               <Label Margin="333,91,0,0" HorizontalAlignment="Left" VerticalAlignment="Top" Content="External OOF Message:" FontSize="14" Foreground="White" />
               <RichTextBox Name="Msg_ext" Height="157" Margin="335,120,10,0" VerticalAlignment="Top" Background="#BF545454" Foreground="White" IsEnabled="False" IsReadOnly="False" TabIndex="6" VerticalScrollBarVisibility="Auto">
                  <FlowDocument>
                     <Paragraph>
                        <Run Text="" />
                     </Paragraph>
                  </FlowDocument>
               </RichTextBox>
               <Button Name="Oof_ExecBTN" Width="82" Height="21" Margin="563,290,0,0" HorizontalAlignment="Left" VerticalAlignment="Top" Content="Executar" IsEnabled="False" TabIndex="8" />
               <Button Name="clear_OofBTN" Width="94" Height="21" Margin="457,290,0,0" HorizontalAlignment="Left" VerticalAlignment="Top" Content="Limpar Campos" IsEnabled="False" TabIndex="7" />
              <Image Width="660" Height="321" HorizontalAlignment="Left" VerticalAlignment="Top" IsEnabled="False" Opacity="0.8" Source="$ScriptDir\Icons\Coming_soon.png" Stretch="Fill" />
            </Grid>
         </TabItem>
         <TabItem Name="APL_Tab" Header="Aplicações">
   <Grid Background="#FF393939">
      <GroupBox Width="640" Margin="10,3,0,10" HorizontalAlignment="Left" BorderBrush="#FF1BDC08" Foreground="White" Header="Apps using the Sysadmin user" />
      <Button Name="MyCompBtn" Width="88" Height="60" Margin="388,28,0,0" HorizontalAlignment="Left" VerticalAlignment="Top">
         <StackPanel Orientation="Vertical">
            <Image Height="30" Source="C:\Users\%username%\Documents\PS-REP\PS-GUI\Icons\MyComp.ICO" />
            <TextBlock FontSize="10" FontWeight="Bold" Text="Computer Man." TextAlignment="Center" />
         </StackPanel>
      </Button>
      <Button Name="ActDirBtn" Width="88" Height="60" Margin="58,28,0,0" HorizontalAlignment="Left" VerticalAlignment="Top">
         <StackPanel Orientation="Vertical">
            <Image Height="30" Source="C:\Users\%username%\Documents\PS-REP\PS-GUI\Icons\Active_Dir.ICO" />
            <TextBlock FontSize="10" FontWeight="Bold" Text="Active Directory" TextAlignment="Center" />
         </StackPanel>
      </Button>
      <Button Name="DNSBtn" Width="88" Height="60" Margin="168,28,0,0" HorizontalAlignment="Left" VerticalAlignment="Top">
         <StackPanel Orientation="Vertical">
            <Image Height="30" Source="C:\Users\%username%\Documents\PS-REP\PS-GUI\Icons\DNS.ICO" />
            <TextBlock FontSize="10" FontWeight="Bold" Text="DNS" TextAlignment="Center" />
         </StackPanel>
      </Button>
      <Button Name="DHCPBtn" Width="88" Height="60" Margin="278,28,0,0" HorizontalAlignment="Left" VerticalAlignment="Top">
         <StackPanel Orientation="Vertical">
            <Image Height="30" Source="C:\Users\%username%\Documents\PS-REP\PS-GUI\Icons\DHCP.ICO" />
            <TextBlock FontSize="10" FontWeight="Bold" Text="DHCP" TextAlignment="Center" />
         </StackPanel>
      </Button>
      <Button Name="Addaplic1Btn" Width="88" Height="60" Margin="497,28,0,0" HorizontalAlignment="Left" VerticalAlignment="Top">
         <StackPanel Orientation="Vertical">
            <Image Name="AddImg1Btn" Height="35" Source="$ScriptDir\Icons\Add_prog.png" />
            <TextBlock Name="AddTxt1Btn" FontSize="10" FontWeight="Bold" Text="Add program" TextAlignment="Center" />
         </StackPanel>
      </Button>
      <Button Name="Addaplic2Btn" Width="88" Height="60" Margin="58,105,0,0" Visibility = "Hidden" HorizontalAlignment="Left" VerticalAlignment="Top">
         <StackPanel Orientation="Vertical">
            <Image Name="AddImg2Btn" Height="35" Source="$ScriptDir\Icons\Add_prog.png" />
            <TextBlock Name="AddTxt2Btn" FontSize="10" FontWeight="Bold" Text="Add program" TextAlignment="Center" />
         </StackPanel>
      </Button>
      <Button Name="Addaplic3Btn" Width="88" Height="60" Margin="168,105,0,0" Visibility = "Hidden" HorizontalAlignment="Left" VerticalAlignment="Top">
         <StackPanel Orientation="Vertical">
            <Image Name="AddImg3Btn" Height="35" Source="$ScriptDir\Icons\Add_prog.png" />
            <TextBlock Name="AddTxt3Btn" FontSize="10" FontWeight="Bold" Text="Add program" TextAlignment="Center" />
         </StackPanel>
      </Button>
      <Button Name="Addaplic4Btn" Width="88" Height="60" Margin="278,105,0,0" Visibility = "Hidden" HorizontalAlignment="Left" VerticalAlignment="Top">
         <StackPanel Orientation="Vertical">
            <Image Name="AddImg4Btn" Height="35" Source="$ScriptDir\Icons\Add_prog.png" />
            <TextBlock Name="AddTxt4Btn" FontSize="10" FontWeight="Bold" Text="Add program" TextAlignment="Center" />
         </StackPanel>
      </Button>
      <Button Name="Addaplic5Btn" Width="88" Height="60" Margin="388,105,0,0" Visibility = "Hidden" HorizontalAlignment="Left" VerticalAlignment="Top">
         <StackPanel Orientation="Vertical">
            <Image Name="AddImg5Btn" Height="35" Source="$ScriptDir\Icons\Add_prog.png" />
            <TextBlock Name="AddTxt5Btn" FontSize="10" FontWeight="Bold" Text="Add program" TextAlignment="Center" />
         </StackPanel>
      </Button>
      <Button Name="Addaplic6Btn" Width="88" Height="60" Margin="498,105,0,0" Visibility = "Hidden" HorizontalAlignment="Left" VerticalAlignment="Top">
         <StackPanel Orientation="Vertical">
            <Image Name="AddImg6Btn" Height="35" Source="$ScriptDir\Icons\Add_prog.png" />
            <TextBlock Name="AddTxt6Btn" FontSize="10" FontWeight="Bold" Text="Add program" TextAlignment="Center" />
         </StackPanel>
      </Button>
      <Button Name="Addaplic7Btn" Width="88" Height="60" Margin="498,105,0,0" Visibility = "Hidden" HorizontalAlignment="Left" VerticalAlignment="Top">
         <StackPanel Orientation="Vertical">
            <Image Name="AddImg7Btn" Height="35" Source="$ScriptDir\Icons\Add_prog.png" />
            <TextBlock Name="AddTxt7Btn" FontSize="10" FontWeight="Bold" Text="Add program" TextAlignment="Center" />
         </StackPanel>
      </Button>
      <Button Name="Addaplic8Btn" Width="88" Height="60" Margin="58,183,0,0" Visibility = "Hidden" HorizontalAlignment="Left" VerticalAlignment="Top">
         <StackPanel Orientation="Vertical">
            <Image Name="AddImg8Btn" Height="35" Source="$ScriptDir\Icons\Add_prog.png" />
            <TextBlock Name="AddTxt8Btn" FontSize="10" FontWeight="Bold" Text="Add program" TextAlignment="Center" />
         </StackPanel>
      </Button>
      <Button Name="Addaplic9Btn" Width="88" Height="60" Margin="168,183,0,0" Visibility = "Hidden" HorizontalAlignment="Left" VerticalAlignment="Top">
         <StackPanel Orientation="Vertical">
            <Image Name="AddImg9Btn" Height="35" Source="$ScriptDir\Icons\Add_prog.png" />
            <TextBlock Name="AddTxt9Btn" FontSize="10" FontWeight="Bold" Text="Add program" TextAlignment="Center" />
         </StackPanel>
      </Button>
      <Button Name="Addaplic10Btn" Width="88" Height="60" Margin="278,183,0,0" Visibility = "Hidden" HorizontalAlignment="Left" VerticalAlignment="Top">
         <StackPanel Orientation="Vertical">
            <Image Name="AddImg10Btn" Height="35" Source="$ScriptDir\Icons\Add_prog.png" />
            <TextBlock Name="AddTxt10Btn" FontSize="10" FontWeight="Bold" Text="Add program" TextAlignment="Center" />
         </StackPanel>
      </Button>
      <Button Name="Addaplic11Btn" Width="88" Height="60" Margin="388,183,0,0" Visibility = "Hidden" HorizontalAlignment="Left" VerticalAlignment="Top">
         <StackPanel Orientation="Vertical">
            <Image Name="AddImg11Btn" Height="35" Source="$ScriptDir\Icons\Add_prog.png" />
            <TextBlock Name="AddTxt11Btn" FontSize="10" FontWeight="Bold" Text="Add program" TextAlignment="Center" />
         </StackPanel>
      </Button>
      <Button Name="Addaplic12Btn" Width="88" Height="60" Margin="498,183,0,0" Visibility = "Hidden" HorizontalAlignment="Left" VerticalAlignment="Top">
         <StackPanel Orientation="Vertical">
            <Image Name="AddImg12Btn" Height="35" Source="$ScriptDir\Icons\Add_prog.png" />
            <TextBlock Name="AddTxt12Btn" FontSize="10" FontWeight="Bold" Text="Add program" TextAlignment="Center" />
         </StackPanel>
      </Button>
   </Grid>
</TabItem>
      </TabControl>
      <Image Width="666" Height="306" Margin="39,421,0,0" HorizontalAlignment="Left" VerticalAlignment="Top" Source="$ScriptDir\Icons\output_img.png" />
      <TextBox Name="OutputBox" Height="306" Margin="39,421,39,0" BorderThickness="3" VerticalAlignment="Top" Background="#BF545454" Foreground="White" IsReadOnly="True" TabIndex="12" TextWrapping="Wrap" VerticalScrollBarVisibility="Auto" />
      <Button Name="Limp_OutBtn" Width="134" Height="21" Margin="39,736,0,0" HorizontalAlignment="Left" VerticalAlignment="Top" Content="Limpar Output Console" TabIndex="14" />
      <Label Name="User_logged" Width="179" Margin="561,8,0,0" HorizontalAlignment="Left" VerticalAlignment="Top" Foreground="White">
         <StackPanel Orientation="Horizontal">
           <Image Name="Status" Height="13" Source="$ScriptDir\Icons\online.png" />
            <Image Height="16" Source="$ScriptDir\Icons\user_log.png" />
            <TextBlock Name="HD_LogUserTxt" FontWeight="Bold" Text=" User: No user" />
         </StackPanel>
      </Label>
      <Button Name="Helpbtn" Width="23" Height="21" Margin="463,736,0,0" HorizontalAlignment="Left" VerticalAlignment="Top" TabIndex="15">
         <StackPanel Orientation="Horizontal">
           <Image Height="16" Source="$ScriptDir\Icons\help.png" />
         </StackPanel>
      </Button>
   </Grid>
</Window>
"@

$XMLReader = (New-Object System.Xml.XmlNodeReader $inputXML)
$XMLForm = [Windows.Markup.XamlReader]::Load($XMLReader)

#Load Controls

$inputXML.SelectNodes("//*[@*[contains(translate(name(.),'n','N'),'Name')]]")  | ForEach {

New-Variable  -Name $_.Name -Value $XMLForm.FindName($_.Name) -Force
}


#APLICATION LOGGING
if (!(Test-Path "$ScriptDir\log.txt"))
{
   New-Item -path $ScriptDir -name log.txt -type "file" -value "------------------------------------ Logging PSMSMove ------------------------------------"
   Add-Content -path $ScriptDir\log.txt -value "`r[$(get-date)] - Starting..."
}
else
{
  Add-Content -path $ScriptDir\log.txt -value "`r[$(get-date)] - Starting..."
}


#CHANGE STATUS COLOR | ADD AFTER CHECK FOR REMOTE INPUT
#$status.Source = "$ScriptDir\Icons\away.png"
#$status.Source = "$ScriptDir\Icons\offline.png"

#WELCOME TEXT
$HD_LogUserTxt.text = " Welcome " + $HD_Username

#JOIN ENTRE ADCOMPUTER + DOMINIO


#Check for Ad user info
$User_info.Add_Click({
if ($AD_Username.TextLength -eq 0){
$AD_Usernamemsg = "USER IS NULL"
#New-WPFMessageBox -Content $AD_Usernamemsg -Title "ALERT" -TitleFontSize 28 -TitleBackground Orange
}
else{
$user = $AD_Username.Text

net user $user /domain > $ScriptDir\User_$user.txt

$teste = get-content $ScriptDir\User_$user.txt -ReadCount 1000 | foreach { $_ -match "User Name" }
$teste2 = get-content $ScriptDir\User_$user.txt -ReadCount 1000 | foreach { $_ -match "Full Name" }
$teste3 = get-content $ScriptDir\User_$user.txt -ReadCount 1000 | foreach { $_ -match "Password last set" }
$teste4 = get-content $ScriptDir\User_$user.txt -ReadCount 1000 | foreach { $_ -match "Password changeable" }
$teste5 = get-content $ScriptDir\User_$user.txt -ReadCount 1000 | foreach { $_ -match "Account Active" }


$OutputBox.Text = $OutputBox.Text + "`n" + $teste2 + "`n" + $teste3 + "`n" + $teste4 + "`n" + $teste5 + "`n"
Remove-Item "$ScriptDir\User_$user.txt"
Add-Content -path $ScriptDir\log.txt -value "`r[$(get-date)] - CheckADUser $AD_Username"

}
})


#MONITOR INFO DO REMOTE CLIENT
$Monitor_infoBtn.Add_Click({
Monitor_info > $ScriptDir\Monitor_Search_$user.txt
$MSearch = Get-Content -path "$ScriptDir\Monitor_Search_$user.txt" | Out-String
$Outputbox.Text = $Outputbox.text + $MSearch
Remove-Item "$ScriptDir\Monitor_Search_$user.txt"
Add-Content -path $ScriptDir\log.txt -value "`r[$(get-date)] - Monitor info: $AD_Computer"
})

#REMOTE CMD PARA REMOTE CLIENT
$Remote_CMDBtn.Add_Click({
Add-Content -path $ScriptDir\log.txt -value "`r[$(get-date)] - Remote CMD: $AD_Computer"
$PSExec = "$ScriptDir\PSTools\PsExec.exe"
$PCompDOMTxt = $AD_Computer.Text + "." + $ComboBoxDom.text
sleep -Seconds 0.2
Start-Process -Filepath "$PSExec" -Credential $credentialimpFV -ArgumentList "\\$PCompDOMTxt cmd"
})


#CHECK FOR TEXT IN AD_COMPUTER | IF NO TEXT IS THERE IT WILL DISABLE THE OTHER BUTTONS | IF TEXT EXISTS BUTTONS WILL BE ENABLED

$AD_Computer.add_TextChanged({$PC_ConnectBtn.IsEnabled = $AD_Computer.Text})


#STUFF
#$AD_Computer.add_TextChanged({$Monitor_infoBtn.IsEnabled = $AD_Computer.Text})
#$AD_Computer.add_TextChanged({$Delete_LixoBtn.IsEnabled = $AD_Computer.Text})
#$AD_Computer.add_TextChanged({$Chck_Logg_UsersBtn.IsEnabled = $AD_Computer.Text})
#$AD_Computer.add_TextChanged({$Chck_Logg_UsersBtn.IsEnabled = $AD_Computer.Text})
#$AD_Computer.add_TextChanged({$Chck_Logg_UsersBtn.IsEnabled = $AD_Computer.Text})
#$AD_Computer.add_TextChanged({$Chck_Logg_UsersBtn.IsEnabled = $AD_Computer.Text})



#CHECK FOR LOGGED USERS IN $AD_COMPUTER
$Chck_Logg_UsersBtn.Add_Click({
$logusers = Get-CimInstance –ComputerName $AD_Computer –ClassName Win32_ComputerSystem | Select-Object UserName
$OutputBox.Text = $OutputBox.Text + $logusers + "`n" + "`n"
Add-Content -path C:\Users\%username%\Documents\log.txt -value "`r[$(get-date)] - CheckLoggUsers $logusers"
})

#Run selective buttons | AD | DHCP | ETC   #################### FIX Start-Process
$ActDirBtn.Add_Click({
Start-Process powershell -Credential $credentialimpFV -ArgumentList “Start-Process -FilePath $env:SystemRoot\System32\mmc.exe -WorkingDirectory $PSHOME -ArgumentList $env:SystemRoot\System32\dsa.msc -Verb RunAs” -windowstyle hidden

})

$DNSBtn.Add_Click({
Start-Process powershell -Credential $credentialimpFV -ArgumentList “Start-Process -FilePath $env:SystemRoot\System32\mmc.exe -WorkingDirectory $PSHOME -ArgumentList $env:SystemRoot\System32\dnsmgmt.msc -Verb RunAs” -windowstyle hidden
})

$DHCPBtn.Add_Click({
Start-Process powershell -Credential $credentialimpFV -ArgumentList “Start-Process -FilePath $env:SystemRoot\System32\mmc.exe -WorkingDirectory $PSHOME -ArgumentList $env:SystemRoot\System32\dhcpmgmt.msc -Verb RunAs” -windowstyle hidden
})

$MyCompBtn.Add_Click({
Start-Process powershell -Credential $credentialimpFV -ArgumentList “Start-Process -FilePath $env:SystemRoot\System32\mmc.exe -WorkingDirectory $PSHOME -ArgumentList $env:SystemRoot\System32\compmgmt.msc -Verb RunAs” -windowstyle hidden
})


#Add aplication buttons
<#$Addaplic1Btn.Add_Click({
if(){[regex.button]

}
$Addaplic2Btn.visibility = "Visible"
})
#>




#CLEAR OUTPUT BOX
$Limp_OutBtn.Add_Click({
$OutputBox.clear()
Add-Content -path C:\Users\%username%\Documents\log.txt -value "`r[$(get-date)] - "
})


#Start GUI
$XMLForm.ShowDialog()





<#

$cred=Get-Credential
$sess = New-PSSession -Credential $cred -ComputerName "REDDACTED.FQDN"
Enter-PSSession $sess


#Get number of connected monitors
$Monitor_Count = (Get-CimInstance -Namespace root\wmi -ClassName WmiMonitorBasicDisplayParams | where {$_.Active -like "True"}).Active.Count

Write-Host "Nrº Monitors: " + $Monitor_Count + "Teste"



#Some Other Stuff

#Get-PSDrive | Where {$_.Free -gt 0}

#Exit-PSSession
#Remove-PSSession $sess

#>