function Send-Email {
<#
.SYNOPSIS
Envia un correo via Gmail

.DESCRIPTION
Enviar correo desde gmail, requiere tener activado el acceso a aplicaciones menos seguras: https://www.google.com/settings/security/lesssecureapps

.EXAMPLE
Send-Email -From Hola@Mundo.com -Password !P4ss - Subject Ejemplo -Body "Hey!`nEsto es una prueba" -Attachment C:\prueba.txt

.LINK
https://www.patreon.com/HelloWorldYT
https://www.facebook.com/HolaMundo.YT
https://twitter.com/H3LL0WORLD
https://www.youtube.com/channel/UCN1R36uVmYCnfKj-1YTSivA
#>
	param (
		[Parameter (Mandatory)][String] $From,
		[Parameter (Mandatory)][String] $Password,
		[Parameter (Mandatory)][String] $To,
		[Parameter (Mandatory)][String] $Subject,
		[String] $Body=" ",
		[String] $Attachment=" "
		)
		
		$Passwd = ConvertTo-SecureString $Password -AsPlainText -Force
		$Credentials = New-Object System.Management.Automation.PSCredential($From,$Passwd)
		$SMTPServer = "smtp.gmail.com"
		$SMTPPort = "587"
		
		if ( $Attachment -eq " ") {
		Send-MailMessage -From $From -to $To -Subject $Subject `
		-Body $Body -SmtpServer $SMTPServer -port $SMTPPort -UseSsl `
		-Credential $Credentials
		} else {
		Send-MailMessage -From $From -to $To -Subject $Subject `
		-Body $Body -SmtpServer $SMTPServer -port $SMTPPort -UseSsl `
		-Credential $Credentials -Attachments $Attachment
		}
}