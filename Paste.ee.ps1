function _Invoke-Request
{
	param (
		$url,
		$parametros
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

function New-Paste
{	
	param (
		$api_key = "",
		$format = "simple",
		$language = "plain",
		$description = '',
		$paste = '',
		$encrypted = 0,
		# 'views;'
		$expire = 0,
		$format = 'json'
	)
	$formats = "json", "xml", "simple"
	
	$url = "http://paste.ee/api"

	$description			= [uri]::EscapeDataString($description);
	$paste			= [uri]::EscapeDataString($paste);

	$params = "key=$api_key&format=$format&language$language&description=$description&paste=$paste&encrypted=$encrypted&expire=$expire&format=$format"
	write-host $params

	_Invoke-Request $url $params
}
