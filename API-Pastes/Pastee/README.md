#Paste.ee API wrapper for Powershell
Powershell function to upload pastes to [Paste.ee](https://paste.ee/).
## Description
This function allow you to submit pastes of their text files to [Paste.ee](https://paste.ee/) by using [Powershell](https://github.com/powershell/powershell).
## Usage example
As simple as *"import and upload"* :smirk:
####1) Import the module
```powershell
PS /> Import-Module ./Pastee.psm1
```
####2) Upload the paste
```powershell
PS /> New-Paste -ApiKey <here_your_api_key> -Paste 'Hello World!'
```
####You will get something like this:
```
id       : XXXXX
link     : http://paste.ee/p/XXXXX
raw      : http://paste.ee/r/XXXXX
download : http://paste.ee/d/XXXXX
min      : http://min.paste.ee/XXXXX
```
####3) Aditional parameters (optional)
- Description (Description of the paste, Optional)
- Language: (Syntax highlighting, Optional, Default 'plain', Should be tab-completable on powershell 3+)
- Encrypted: (This will make it so that it isn't syntax highlighted via GeSHi in the paste view page, Optional, default '0')
- Expire: (Expiration time in SECONDS, Optional, Default 0 = 'Never')

##Requirements
* **Api Key**: Grab your own api key by signing up at [Paste.ee](https://paste.ee/register).

#####Remember to check the **"_Register an API key to this account_"** box.
