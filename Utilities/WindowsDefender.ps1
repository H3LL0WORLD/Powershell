Function Set-WindowsDefender {
	Param (
		[ValidateSet('Enabled','Disabled')]
		$Mode
	)
	$WindowsDefenderPolicyPath = 'HKLM:\SOFTWARE\Policies\Microsoft\Windows Defender'
	$PolicyName = 'DisableAntiSpyware'
	if ($Mode -eq 'Enabled') {
		Remove-ItemProperty -Path $WindowsDefenderPolicyPath -Name $PolicyName -Force -ErrorAction SilentlyContinue
	} elseif ($Mode -eq 'Disabled') {
		Remove-ItemProperty -Path $WindowsDefenderPolicyPath -Name $PolicyName -Force -ErrorAction SilentlyContinue
		New-ItemProperty -Path $WindowsDefenderPolicyPath -Name $PolicyName -Value '1' -PropertyType DWord -Force | Out-Null
	}
}
