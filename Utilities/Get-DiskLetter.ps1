Function Get-DiskLetter {
<#
.SYNOPSIS
Obtener la letra de un disco dependiendo de la etiqueta.

.DESCRIPTION
Este payload usa Wmi para obtener la informacion de los discos e identificar que disco tiene la etiqueta indicada.

.EXAMPLE
PS > Get-DiskLetter -Label "HolaMundo"

.LINK
https://www.patreon.com/HelloWorldYT
https://www.facebook.com/HolaMundo.YT
https://twitter.com/H3LL0WORLD
https://www.youtube.com/channel/UCN1R36uVmYCnfKj-1YTSivA
#>
	param([Parameter (Mandatory)][String]$Label)
	$(Get-WmiObject -Class win32_logicaldisk -Filter "VolumeName='$Label'").Name
}
