Function Set-WindowsDefender {
<#
.SYNOPSIS
	Enable/Disable WindowsDefender by using a policy in the registry

.AUTHOR
	H3LL0WORLD

.EXAMPLE
	Set-WindowsDefender -Mode Enabled
	Enable Windows Defender

.EXAMPLE
	Set-WindowsDefender -Mode Disabled
	Disable Windows Defender
#>
	Param (
		[ValidateSet('Enabled','Disabled')]
		$Mode
	)
	$WindowsDefenderPolicyPath = 'HKLM:\SOFTWARE\Policies\Microsoft\Windows Defender'
	$PolicyName = 'DisableAntiSpyware'
	
	# Check if admin
	if (-not ([Bool] (([Security.Principal.WindowsIdentity]::GetCurrent()).Groups -Match 'S-1-5-32-544') -And ([Security.Principal.WindowsPrincipal] [Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole] 'Administrator'))) {
		Write-Warning "This script must run as a privileged user"
		break
	}
	
	if ($Mode -eq 'Enabled') {
		# If 'enabled' delete the value
		try {
			Remove-ItemProperty -Path $WindowsDefenderPolicyPath -Name $PolicyName -Force -ErrorAction SilentlyContinue
		} catch {}
	} elseif ($Mode -eq 'Disabled') {
		# Create the key if does not exist
		if (!(Test-Path $WindowsDefenderPolicyPath)) {
			New-Item -Path $WindowsDefenderPolicyPath
		}
		# If 'disabled' create and/or set the value to 1
		New-ItemProperty -Path $WindowsDefenderPolicyPath -Name $PolicyName -Value '1' -PropertyType DWord -Force | Out-Null
	}
}
