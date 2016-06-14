try {

	$SALT_VERSION = '2016.3.0'

	$downloadDir = "${env:temp}\salt\"

	if (!(Test-Path $downloadDir)) {
		New-Item -Type Directory $downloadDir
	}

	(new-object net.webclient).DownloadFile('https://raw.githubusercontent.com/saltstack/salt-bootstrap/stable/bootstrap-salt.ps1', "${downloadDir}\bootstrap-salt.ps1") | Out-Null

	if (!(Test-Path "${downloadDir}\bootstrap-salt.ps1")) {
		throw "There was a problem downloading the bootstrap-salt.ps1 file to ${downloadDir}"
	}

	Invoke-Expression "${downloadDir}\bootstrap-salt.ps1 -version $SALT_VERSION -runservice true -minion salt-minion -master `"master`""

} catch {
	throw $_.Exception
}