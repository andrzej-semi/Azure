#variables
$regionalsettingsURL = "https://raw.githubusercontent.com/andrzej-semi/Azure/master/101-ServerBuild/AURegion.xml"
$RegionalSettings = "D:\AURegion.xml"


#downdload regional settings file
$webclient = New-Object System.Net.WebClient
$webclient.DownloadFile($regionalsettingsURL,$RegionalSettings)


# Set Locale, language etc. 
& $env:SystemRoot\System32\control.exe "intl.cpl,,/f:`"$RegionalSettings`""

# Set languages/culture. Not needed perse.
Set-WinSystemLocale en-GB
Set-WinUserLanguageList -LanguageList en-GB -Force
Set-Culture -CultureInfo en-GB
Set-WinHomeLocation -GeoId 242
Set-TimeZone -Name "GMT Standard Time"

# Setup RDS policies
#Set Time limit for logoff of RemoteApp sessions 
reg add "HKLM\SOFTWARE\Policies\Microsoft\Windows NT\Terminal Services" /v RemoteAppLogoffTimeLimit /t REG_DWORD /d 3600000 /f
#Set time limit for disconnected session
reg add "HKLM\SOFTWARE\Policies\Microsoft\Windows NT\Terminal Services" /v MaxDisconnectionTime /t REG_DWORD /d 3600000 /f
#Set time limit for active but idle Remote Desktop Services sessions
reg add "HKLM\SOFTWARE\Policies\Microsoft\Windows NT\Terminal Services" /v MaxIdleTime /t REG_DWORD /d 3600000 /f

#install CW Control
msiexec /i "https://connect.newlineasp.com/Bin/ScreenConnect.ClientSetup.msi?e=Access&y=Guest&c=Newline&c=Azure&c=&c=&c=United%20Kingdom&c=&c=&c=NAS%20Server" /q
#install Datto RMM
(New-Object System.Net.WebClient).DownloadFile("https://merlot.centrastage.net/csm/profile/downloadAgent/e7f63885-e0f6-40e2-a9e4-afc821d1066b", "$env:TEMP/AgentInstall.exe");start-process "$env:TEMP/AgentInstall.exe"
#install SnakeTail
msiexec /i "https://github.com/snakefoot/snaketail-net/releases/download/1.9.7/SnakeTail.v1.9.7.x64.msi" /q



# restart virtual machine to apply regional settings to current user. You could also do a logoff and login.
Start-sleep -Seconds 40
Restart-Computer

