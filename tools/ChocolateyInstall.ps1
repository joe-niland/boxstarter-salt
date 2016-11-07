try {

	$SALT_VERSION = '2016.3.4'
	$SALT_SERVICE = 'salt-minion'
	$SALT_HOME = 'C:\salt'

	$downloadDir = "${env:temp}\salt\"

	if (!(Test-Path $downloadDir)) {
		New-Item -Type Directory $downloadDir
	}

	(new-object net.webclient).DownloadFile('https://raw.githubusercontent.com/saltstack/salt-bootstrap/stable/bootstrap-salt.ps1', "${downloadDir}\bootstrap-salt.ps1") | Out-Null

	if (!(Test-Path "${downloadDir}\bootstrap-salt.ps1")) {
		throw "There was a problem downloading the bootstrap-salt.ps1 file to ${downloadDir}"
	}

	# Stop service if exists
	if ( Get-WmiObject -Class Win32_Service -Filter "Name='$($SALT_SERVICE)'" ) {
		Stop-Service "$SALT_SERVICE"
	}

	Invoke-Expression "${downloadDir}\bootstrap-salt.ps1 -version $SALT_VERSION -runservice true -minion salt-minion -master `"masterless`""

	# Configure Salt Minion to run masterless
	Add-Content "$($SALT_HOME)\conf\minion.d\minion.conf" "file_client: local"

	# Ensure service is started
	if ( Get-WmiObject -Class Win32_Service -Filter "Name='$($SALT_SERVICE)'" ) {
		Start-Service "$SALT_SERVICE"
   } else {
		Write-Host "Salt service $SALT_SERVICE not found"   	
	}

	# Add Salt minion dir to path if not already done

	# Build path
	$saltExePath = $SALT_HOME

	# Ensure salt-minion path is in the current session's path if not there
	$currentMachinePath = [Environment]::GetEnvironmentVariable('Path', [System.EnvironmentVariableTarget]::Machine)
	if ($($currentMachinePath).ToLower().Contains($($saltExePath).ToLower()) -eq $false) {
	  Write-Debug "Adding Salt bin location to persistent machine PATH"
	  $env:Path = [Environment]::SetEnvironmentVariable('Path', $currentMachinePath + ";" + $saltExePath, [System.EnvironmentVariableTarget]::Machine)
	}

} catch {
	throw $_.Exception
}