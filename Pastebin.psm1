function Invoke-Request
{
	param (
		$parametros,
		$url
	)
	$bytes = [System.Text.Encoding]::ASCII.GetBytes($parametros)
	$ch = [System.Net.WebRequest]::Create($url)
	$ch.Method = "POST";
	$ch.ContentType = "application/x-www-form-urlencoded"
	$ch.ContentLength = $bytes.Length

	$stream = $ch.GetRequestStream()
	$stream.Write($bytes, 0, $bytes.Length)
	$stream.Flush()
	$stream.Close()
	$resp = $ch.GetResponse()
	$sr = [System.IO.StreamReader] $resp.GetResponseStream()
	$return = $sr.ReadToEnd().Trim()
	return $return
}
function Create-NewPaste
{
	param (
		[Parameter(Mandatory=$True)]
		$DevKey, # api_developer_key
		[Parameter(Mandatory=$True)]
		$PasteCode, # paste text
		[Int32]
		[ValidateSet(0, 1, 2)] # 0=public 1=unlisted 2=private
		$PastePrivacy = 1,
		[Parameter(Mandatory=$True)]
		$PasteName, # name or title of your paste
		[ValidateSet("N", "10M", "1H", "1D", "1M")]
		$PasteExpireDate = '10M',
		[Parameter(Mandatory=$False)]
		[ValidateSet("4cs", "6502acme", "6502kickass", "6502tasm", "abap", "actionscript", "actionscript3", "ada", "aimms", "algol68", "apache", "applescript", "apt_sources", "arm", "asm", "asp", "asymptote", "autoconf", "autohotkey", "autoit", "avisynth", "awk", "bascomavr", "bash", "basic4gl", "dos", "bibtex", "blitzbasic", "b3d", "bmx", "bnf", "boo", "bf", "c", "c_winapi", "c_mac", "cil", "csharp", "cpp", "cp", "cp", "c_loadrunner", "caddcl", "cadlisp", "cfdg", "chaiscript", "chapel", "clojure", "klonec", "klonecpp", "cmake", "cobol", "coffeescript", "cfm", "css", "cuesheet", "d", "dart", "dcl", "dcpu16", "dcs", "delphi", "oxygene", "diff", "div", "dot", "e", "ezt", "ecmascript", "eiffel", "email", "epc", "erlang", "euphoria", "fsharp", "falcon", "filemaker", "fo", "f1", "fortran", "freebasic", "freeswitch", "gambas", "gml", "gdb", "genero", "genie", "gettext", "go", "groovy", "gwbasic", "haskell", "haxe", "hicest", "hq9plus", "html4strict", "html5", "icon", "idl", "ini", "inno", "intercal", "io", "ispfpanel", "j", "java", "java5", "javascript", "jcl", "jquery", "json", "julia", "kixtart", "latex", "ldif", "lb", "lsl2", "lisp", "llvm", "locobasic", "logtalk", "lolcode", "lotusformulas", "lotusscript", "lscript", "lua", "m68k", "magiksf", "make", "mapbasic", "matlab", "mirc", "mmix", "modula2", "modula3", "68000devpac", "mpasm", "mxml", "mysql", "nagios", "netrexx", "newlisp", "nginx", "nimrod", "text", "nsis", "oberon2", "objeck", "objc", "ocam", "ocaml", "octave", "oorexx", "pf", "glsl", "oobas", "oracle11", "oracle8", "oz", "parasail", "parigp", "pascal", "pawn", "pcre", "per", "perl", "perl6", "php", "ph", "pic16", "pike", "pixelbender", "pli", "plsql", "postgresql", "postscript", "povray", "powershell", "powerbuilder", "proftpd", "progress", "prolog", "properties", "providex", "puppet", "purebasic", "pycon", "python", "pys60", "q", "qbasic", "qml", "rsplus", "racket", "rails", "rbs", "rebol", "reg", "rexx", "robots", "rpmspec", "ruby", "gnuplot", "rust", "sas", "scala", "scheme", "scilab", "scl", "sdlbasic", "smalltalk", "smarty", "spark", "sparql", "sqf", "sql", "standardml", "stonescript", "sclang", "swift", "systemverilog", "tsql", "tcl", "teraterm", "thinbasic", "typoscript", "unicon", "uscript", "upc", "urbi", "vala", "vbnet", "vbscript", "vedit", "verilog", "vhdl", "vim", "visualprolog", "vb", "visualfoxpro", "whitespace", "whois", "winbatch", "xbasic", "xml", "xorg_conf", "xpp", "yaml", "z80", "zxbasic")]
		$PasteFormat,
		[Parameter(Mandatory=$False)]
		$UserKey = '' # if an invalid api_user_key or no key is used, the paste will be create as a guest
	)
	$api_dev_key 			= $DevKey;
	$api_paste_code 		= $PasteCode;
	$api_paste_private 		= $PastePrivacy;
	$api_paste_name			= $PasteName;
	$api_paste_expire_date  = $PasteExpireDate;
	$api_paste_format 		= $PasteFormat;
	$api_user_key 			= $UserKey;
	
	$api_paste_name			= [uri]::EscapeDataString($api_paste_name);
	$api_paste_code			= [uri]::EscapeDataString($api_paste_code);

	$url 				= 'http://pastebin.com/api/api_post.php';
	$parametros = "api_option=paste&api_user_key=$api_user_key&api_paste_private=$api_paste_private&api_paste_name=$api_paste_name&api_paste_expire_date=$api_paste_expire_date&api_paste_format=$api_paste_format&api_dev_key=$api_dev_key&api_paste_code=$api_paste_code"
	
	Invoke-Request $parametros $url
}

function Create-Api_User_Key
{
	param (
		[Parameter(Mandatory=$True)]
		$DevKey,
		[Parameter(Mandatory=$True)]
		$UserName,
		[Parameter(Mandatory=$True)]
		$UserPassword
	)
	$api_dev_key 			= $DevKey;
	$api_user_name 		= $UserName;
	$api_user_password 	= $UserPassword;
	
	$api_user_name 		= [uri]::EscapeDataString($api_user_name);
	$api_user_password 	= [uri]::EscapeDataString($api_user_password);
	
	$url			= 'http://pastebin.com/api/api_login.php';
	$parametros = "api_dev_key=$api_dev_key&api_user_name=$api_user_name&api_user_password=$api_user_password"

	Invoke-Request $parametros $url
}

function List-Pastes
{
	param (
		[Parameter(Mandatory=$True)]
		$DevKey,
		[Parameter(Mandatory=$True)]
		$UserKey,
		[Int32]
		[Parameter(Mandatory=$False)]
		$ResultsLimit = 50 # this is not required, by default its set to 50, min value is 1, max value is 1000
	)
	$api_dev_key 			= $DevKey;
	$api_user_key 		= $UserKey;
	$api_results_limit 	= $ResultsLimit;
	
	$url 			= 'http://pastebin.com/api/api_post.php';
	$parametros = "api_option=list&api_user_key=$api_user_key&api_dev_key=$api_dev_key&api_results_limit=$api_results_limit"
	
	Invoke-Request $parametros $url
}

function List-TrendingPastes
{
	param (
		[Parameter(Mandatory=$True)]
		$DevKey
	)
	$api_dev_key 		= $DevKey;
	
	$url 			= 'http://pastebin.com/api/api_post.php';
	$parametros = "api_option=trends&api_dev_key=$api_dev_key"
	
	Invoke-Request $parametros $url
}

function Delete-Paste
{
	param (
		[Parameter(Mandatory=$True)]
		$DevKey,
		[Parameter(Mandatory=$True)]
		$UserKey,
		[Parameter(Mandatory=$True)]
		$PasteKey
	)
	$api_dev_key 		= $DevKey;
	$api_user_key 		= $UserKey;
	$api_paste_key      = $PasteKey;
	
	$url 			= 'http://pastebin.com/api/api_post.php';
	$parametros = "api_option=delete&api_user_key=$api_user_key&api_dev_key=$api_dev_key&api_paste_key=$api_paste_key"
	
	Invoke-Request $parametros $url	
}

function Get-UserInformationAndSettings
{
	param (
		[Parameter(Mandatory=$True)]
		$DevKey,
		[Parameter(Mandatory=$True)]
		$UserKey
	)
	
	$api_dev_key 		= $DevKey;
	$api_user_key 		= $UserKey;
	
	$url 			= 'http://pastebin.com/api/api_post.php';
	$parametros = "api_option=userdetails&api_user_key=$api_user_key&api_dev_key=$api_dev_key"
	
	Invoke-Request $parametros $url
}

function Get-RawPasteOfUsers
{
	param (
		[Parameter(Mandatory=$True)]
		$DevKey,
		[Parameter(Mandatory=$True)]
		$UserKey,
		[Parameter(Mandatory=$True)]
		$PasteKey
	)
	$api_dev_key 		= $DevKey;
	$api_user_key 		= $UserKey;
	$api_paste_key      = $PasteKey;
	
	$url 			= 'http://pastebin.com/api/api_post.php';
	$parametros = "api_option=show_paste&api_user_key=$api_user_key&api_dev_key=$api_dev_key&api_paste_key=$api_paste_key"
	
	Invoke-Request $parametros $url
}

function Get-RawPaste
{
	Param (
		[Parameter(Mandatory=$True)]
		$PasteKey
	)
	$api_paste_key      = $PasteKey;
	$return = $(New-Object Net.WebClient).DownloadString("http://pastebin.com/raw/$api_paste_key")
	if ($return.Contains('AD-BLOCK DETECTED')) {
		return 'AD-BLOCK DETECTED';
	} else {
		return $return
	}
}
