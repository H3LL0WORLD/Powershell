Function ConvertTo-UnSecureString {
	Param (
		[Parameter(Mandatory = $true)]
		[SecureString]
		$SecureString
	)
	try
	{
		$UnmanagedString  = [System.Runtime.InteropServices.Marshal]::SecureStringToGlobalAllocUnicode($SecureString);
		$UnSafeString = [System.Runtime.InteropServices.Marshal]::PtrToStringUni($UnmanagedString);
		return $UnSafeString;
	}
	finally
	{
		[System.Runtime.InteropServices.Marshal]::ZeroFreeGlobalAllocUnicode($UnmanagedString);
	}
}