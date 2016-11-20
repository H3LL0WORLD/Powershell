Function New-Paste {
    [CmdletBinding()]
    Param(
        [Parameter(Mandatory = $true)]
        [String] $ApiKey,

        [Parameter(Mandatory = $false)]
        [String] $Description,

        [Parameter(Mandatory = $false)]
        [ValidateSet('plain','bash','c','cpp','java','javascript','php','python','ruby','abap','algol68','arm','asm','asp','actionscript','actionscript3','ada','apache','applescript','apt_sources','autoit','autoconf','autohotkey','avisynth','bascomavr','basic4gl','bibtex','blitzbasic','boo','bf','c_loadrunner','c_mac','csharp','cpp-qt','caddcl','cadlisp','cfdg','cil','cmake','cobol','css','chaiscript','clojure','coffeescript','cfm','cuesheet','d','dcl','dcpu16','dcs','div','dos','delphi','diff','e','ecmascript','epc','eiffel','erlang','euphoria','fsharp','fo','falcon','f1','fortran','freebasic','freeswitch','4cs','gambas','gdb','gml','gettext','octave','make','genie','gnuplot','go','groovy','gwbasic','hq9plus','html4strict','html5','haskell','haxe','hicest','ini','intercal','icon','inno','io','j','java5','klonec','klonecpp','kixtart','ldif','llvm','lolcode','lsl2','lscript','latex','lb','lisp','locobasic','logtalk','lotusformulas','lotusscript','lua','mmix','6502acme','6502kickass','6502tasm','mxml','magiksf','mapbasic','matlab','mpasm','reg','modula2','modula3','68000devpac','m68k','mysql','nsis','nagios','netrexx','ocaml','ocaml-brief','oz','oberon2','objeck','objc','pf','oobas','oracle11','oracle8','oxygene','parigp','pcre','php-brief','pic16','pli','plsql','povray','properties','parasail','pascal','pawnamxx','perl','perl6','pike','pixelbender','postgresql','powerbuilder','powershell','proftpd','progress','prolog','providex','purebasic','pycon','pys60','qbasic','rsplus','rebol','rpmspec','rails','sas','spark','sparql','sql','scala','scheme','scilab','smalltalk','smarty','sourcepawn','stonescript','systemverilog','tsql','tcl','teraterm','text','typoscript','upc','unicon','idl','uscript','urbi','vhdl','vala','vedit','verilog','vim','vb','visualfoxpro','visualprolog','whitespace','whois','winbatch','xpp','xbasic','xml','xorg_conf','yaml','zxbasic','z80','asymptote','awk','bnf','dot','email','genero','glsl','jquery','mirc','newlisp','oorexx','per','q','rexx','robots','sdlbasic','thinbasic','vbnet')]
        [String] $Language = 'plain',

        [Parameter(Mandatory = $true)]
        [String] $Paste,

        [Parameter(Mandatory = $false)]
        [String] $Format,

        [Parameter(Mandatory = $false)]
        [ValidateSet(0,1)]
        [Int32] $Encrypted = 0,

        [Parameter(Mandatory = $false)]
        [Int32] $Expire = 0
    )

    $Uri = 'http://paste.ee/api'
    $Paste = [uri]::EscapeDataString($Paste)
    if ($Description) {
        $Description = [uri]::EscapeDataString($Description)
    }
    $Params = "key=$ApiKey&description=$Description&language=$Language&paste=$Paste&format=$Format&encrypted=$Encrypted&expire=$Expire"

    $errors = @{
        error_no_key = 'No Key present'
        error_no_paste = 'Nothing to paste'
        error_invalid_key = 'Please pass Valid Key'
        error_invalid_language ='Invalid Language'
    }

    if ([Environment]::Version.Major -le 2) {
        $Bytes = [Text.Encoding]::ASCII.GetBytes($Params)
        
        $ch = [Net.WebRequest]::Create($Uri)
        $ch.Method = 'POST';
        $ch.ContentType = 'application/x-www-form-urlencoded'
        $ch.ContentLength = $Bytes.Length

        $Stream = $ch.GetRequestStream()
        $Stream.Write($Bytes, 0, $Bytes.Length)
        $Stream.Flush()
        $Stream.Close()
        $Resp = $ch.GetResponse()
        $SR = [IO.StreamReader] $Resp.GetResponseStream()
        $Request = $SR.ReadToEnd().Trim()

        Add-Type -AssemblyName System.Web.Extensions
        $Content = (New-Object Web.Script.Serialization.JavascriptSerializer).DeserializeObject($Request)
    } else {
        $Request = Invoke-WebRequest -Uri ($Uri+"?$Params") -ContentType 'application/x-www-form-urlencoded' -Method Post
        $Content = ConvertFrom-Json $Request.Content
    }
    if ($Content.status -eq 'error') {
        Write-Host '[!] Error: ' -NoNewLine -ForegroundColor Red
        Write-Host $errors.($Content.error)
    } elseif ($Content.status -eq 'success') {
        return $Content.paste
    }
}
