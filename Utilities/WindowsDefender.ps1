Function Set-WindowsDefender {
<#
.SYNOPSIS
	Enable/Disable WindowsDefender by using a policy in the register
.AUTHOR
	H3LL0WORLD
.EXAMPLE
	Set-WindowsDefender -Mode Enabled
	## Description
	# Enable Windows Defender
.EXAMPLE
	Set-WindowsDefender -Mode Disabled
	## Description
	#Disable Windows Defender
#>
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
