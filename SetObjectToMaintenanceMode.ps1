Param(
  [string]$scomserver,
  [string]$mmdevice,
     [int]$mmdurationminutes,
  [string]$mmcomment,
  [string]$mmreason
)

# Import SCOM module
Import-Module "$executingScriptDirectory\SCOM" -DisableNameChecking

# Copy the environment variables to their parameters
if (test-path env:\SNC_scomserver) {
  $scomserver        = $env:SNC_scomserver
  $mmdevice          = $env:SNC_mmdevice
}

if (test-path env:\SNC_mmdurationminutes) {
  $mmdurationminutes = $env:SNC_mmdurationminutes
  $mmcomment         = $env:SNC_mmcomment
  $mmreason          = $env:SNC_mmreason
}

SNCLog-ParameterInfo @("Running SetObjectToMaintenanceMode", $scomserver, $mmdevice, $mmdurationminutes, $mmcomment, $mmreason)

function Set-ObjectToMaintenanceMode() {
  # Connect to the Management Server and set working location
  add-pssnapin "Microsoft.EnterpriseManagement.OperationsManager.Client" 
	Set-Location "OperationsManagerMonitoring::"

  $scomserver        = $args[0];
  $mmdevice          = $args[1];
  $mmdurationminutes = $args[2];
  $mmcomment         = $args[3];
  $mmreason          = $args[4];
  
  New-SCOMManagementGroupConnection $scomserver
  $endTime = ((Get-Date).AddMinutes($mmdurationminutes))
  $instance = Get-SCOMClassInstance -Name $mmdevice
  Start-SCOMMaintenanceMode -Instance $instance -EndTime $endTime -Comment $mmcomment -Reason $mmreason
}

# Create a powershell session.
$session = Create-PSSession -scomServerName $computer -credential $cred

try {
    SNCLog-DebugInfo "`tInvoking Invoke-Command -ScriptBlock `$'{function:Set-ObjectToMaintenanceMode}' -ArgumentList $scomserver, $mmdevice, $mmdurationminutes, $mmcomment, $mmreason"
    Invoke-Command -Session $session -ScriptBlock ${function:Set-ObjectToMaintenanceMode} -ArgumentList $scomserver, $mmdevice, $mmdurationminutes, $mmcomment, $mmreason
} finally {
    Remove-PSSession -session $session
}