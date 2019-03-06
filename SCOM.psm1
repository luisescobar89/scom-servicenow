<# 
 .Synopsis
 SCOM Module

 .Description
  Contains common PowerShell functions for SCOM support

 .Author
  HIGHMETRIC\luis.escobar

 Requires -Version 3.0
#>

<# 
 .Synopsis
  Create SCOM session.

 .Description
  Returns the created PowerShell session object to be used.

 .Parameter SCCM Server Name
  The hostname of the SCOM server.

 .Parameter credential
  The credential object used to access the server.

 .Example
   # Create a powershell session.
   Create-PSSession -scomServerName $theServer -credential $userCredential;

 Requires -Version 3.0
#>
function Create-PSSession {
	param(
		[Parameter(Mandatory=$true)] [string]$scomServerName,
		[Parameter(Mandatory=$true)] $credential
	);

        SNCLog-ParameterInfo @("Running Create-PSSession", $scomServerName, $credential)

        $session = New-PSSession -ComputerName $scomServerName -ConfigurationName Microsoft.PowerShell -Credential $credential;

	# Return the created session
	$session;
}