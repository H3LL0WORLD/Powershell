function Clean-RunMRU
{
	param(
		# Clear the full Most-Recently-Used (MRU) list.
		[Switch] $All,
		# Remove the last MRU in the list
		[Switch] $Last,
		# Remove the MRU that match with the pattern
		[String] $Pattern
	)
	
	$RunMRUPath = 'HKCU:\Software\Microsoft\Windows\CurrentVersion\Explorer\RunMRU\'
	if ($All) {
		if ($Last -or $Pattern) {
			Write-Warning 'Solo seleccionar una opcion.'
			break
		}
		Remove-ItemProperty -Path $RunMRUPath -Name * -Force
	}
	if ($Last) {
		if ($All -or $Pattern) {
			Write-Warning 'Solo seleccionar una opcion.'
			break
		}
		$OldMRUList = (Get-ItemProperty -Path $RunMRUPath).MRUList
		$LastCommandID = $OldMRUList[0]
		Remove-ItemProperty -Path $RunMRUPath -Name $LastCommandID -Force
		$NewMRUList = $OldMRUList.Remove(0,1)
		Set-ItemProperty -Path $RunMRUPath -Name 'MRUList' -Value $NewMRUList -Force
	}
	
	if ($Pattern) {
		if ($All -or $Last) {
			Write-Warning 'Solo seleccionar una opcion.'
			break
		}
		$RunMRU = Get-ItemProperty -Path $RunMRUPath
		$MRUList = $RunMRU.MRUList
		0 .. ($MRUList.Length - 1) | foreach { $MRUList[$_] } | foreach {
			if ($RunMRU.$_.Contains($Pattern)) {
				Remove-ItemProperty -Path $RunMRUPath -Name $_ -Force
				$NewMRUList = $MRUList.Replace("$_","")
				Set-ItemProperty -Path $RunMRUPath -Name 'MRUList' -Value $NewMRUList -Force
			}
		}
	}
}
