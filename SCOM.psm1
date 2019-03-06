# Create SCOM session. Returns the created PowerShell session object to be used.
# 
# Version History
# ----------------------------
# 1.0      initial release       HM\LE
# # # # # # # # # # # # # # # # # # # # # # # # # #
# Parameter SCOM Server: Name The hostname of the SCOM server.
# Parameter credential: The credential object used to access the server.
# Example: Create-PSSession -scomServerName $theServer -credential $userCredential; 

function Create-PSSession {
	param(
		[Parameter(Mandatory=$true)] [string]$scomServerName,
		[Parameter(Mandatory=$true)] $credential
	);

        #SNCLog-ParameterInfo @("Running Create-PSSession", $scomServerName, $credential)

        $session = New-PSSession -ComputerName $scomServerName -ConfigurationName Microsoft.PowerShell -Credential $credential;

	# Return the created session
	$session;
}