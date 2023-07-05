<#
Add-Type -AssemblyName System.Windows.Forms

while ($true)
{
  $Pos = [System.Windows.Forms.Cursor]::Position
  $x = ($pos.X % 500) + 1
  $y = ($pos.Y % 500) + 1
  [System.Windows.Forms.Cursor]::Position = New-Object System.Drawing.Point($x, $y)
  Start-Sleep -Seconds 5
  $x2 = ($pos.X % 500) - 1
  $y2 = ($pos.Y % 500) - 1
  [System.Windows.Forms.Cursor]::Position = New-Object System.Drawing.Point($x2, $y2)
  Start-Sleep -Seconds 5
}
#>



Add-Type -AssemblyName System.Windows.Forms

$myshell = New-Object -com "Wscript.Shell"
#$PSDefaultParameterValues = @{"Get-Date:format"="dd-MM-yyyy HH:mm:ss"}

if (!(Test-Path "C:\Users\%username%\Documents\log.txt"))
{
   New-Item -path C:\Users\%username%\Documents\ -name log.txt -type "file" -value "------------------------------------ Loging PSMSMove ------------------------------------"
}
else
{
  Add-Content -path C:\Users\%username%\Documents\log.txt -value "`r[$(get-date)] - Starting..."
  Import-Module -Name "C:\Users\%username%\Desktop\Scripts .bat ou .ps (testes)\Custom_WPF_Powershell_Module.psm1"

$Image = New-Object System.Windows.Controls.Image
$Image.Source = "http://icons.iconarchive.com/icons/paomedia/small-n-flat/256/sign-warning-icon.png"
$Image.Height = 50
$Image.Width = 50
$Image.Margin = 5
 
$TextBlock = New-Object System.Windows.Controls.TextBlock
$TextBlock.Text = "Starting Schedule procedure..."
$TextBlock.Padding = 10
$TextBlock.FontFamily = "Verdana"
$TextBlock.FontSize = 16
$TextBlock.VerticalAlignment = "Center"
 
$StackPanel = New-Object System.Windows.Controls.StackPanel
$StackPanel.Orientation = "Horizontal"
$StackPanel.AddChild($Image)
$StackPanel.AddChild($TextBlock)
 
New-WPFMessageBox -Content $StackPanel -Title "ALERT" -TitleFontSize 28 -TitleBackground Orange

$n = 0
#While($n -lt 2) {

While(1) {
$p1 = [System.Windows.Forms.Cursor]::Position
Start-Sleep -Seconds 5  # or use a shorter intervall with the -milliseconds parameter
$p2 = [System.Windows.Forms.Cursor]::Position
Write-Host "Cycle:"$n

if($p1.X -eq $p2.X -and $p1.Y -eq $p2.Y) {
  Add-Content -path C:\Users\%username%\Documents\log.txt -value "`r[$(get-date)] - No Movement, executing -1 and +1 to ($p1)"
  [System.Reflection.Assembly]::LoadWithPartialName("System.Drawing") | out-null
[System.Reflection.Assembly]::LoadWithPartialName("System.Windows.Forms") | out-null
$bounds = [System.Windows.Forms.Screen]::PrimaryScreen.Bounds
$center = $bounds.Location
$center.X += $bounds.Width / 2
$center.Y += $bounds.Height / 2
[System.Windows.Forms.Cursor]::Position = $center
  $Pos = [System.Windows.Forms.Cursor]::Position
  $x = $pos.X + 1
  $y = $pos.Y + 1
  $myshell.sendkeys('+{F15}')
  [System.Windows.Forms.Cursor]::Position = New-Object System.Drawing.Point($x, $y)
  Start-Sleep -Seconds 3
  $x2 = $pos.X - 1
  $y2 = $pos.Y - 1
  [System.Windows.Forms.Cursor]::Position = New-Object System.Drawing.Point($x2, $y2)
  Start-Sleep -Seconds 3
} else {
       Write-Host "The mouse moved"
       Add-Content -path C:\Users\%username%\Documents\log.txt -value "`r[$(get-date)] - The Mouse moved... on Cycle $n"
}
$n++Add-Content -path C:\Users\%username%\Documents\log.txt -value "`r[$(get-date)] - End of cycle, waiting 1.5 min..."#start-sleep -seconds 90}}