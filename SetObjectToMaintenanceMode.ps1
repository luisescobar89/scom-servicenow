Param(
  [string]$scomserver,
  [string]$mmdevice,
     [int]$mmdurationminutes,
  [string]$mmcomment,
  [string]$mmreason
)

# Import SCOM module
$filepath = Split-Path -Path $MyInvocation.MyCommand.Definition -Parent 
Import-Module "$filepath\SCOM" -DisableNameChecking

# Copy the environment variables to their parameters
if (test-path env:\SNC_collection) {
  $scomserver        = $env:SNC_scomserver
  $mmdevice          = $env:SNC_mmdevice
  $mmdurationminutes = $env:SNC_mmdurantionminutes
  $mmcomment         = $env:SNC_mmcomment
  $mmreason          = $env:SNC_mmreason
}

SNCLog-ParameterInfo @("Running SetObjectToMaintenanceMode", $scomserver, $mmdevice, $mmdurationminutes, $mmcomment, $mmreason)

function Set-ObjectToMaintenanceMode() {

  $scomserver        = $args[0];
  $mmdevice          = $args[1];
  $mmdurationminutes = $args[2];
  $mmcomment         = $args[3];
  $mmreason          = $args[4];
  
  # Import SCOM module
  Import-Module OperationsManager
  # Connect to the Management Server and set working location
  New-SCOMManagementGroupConnection $scomserver 

  $endTime = ((Get-Date).AddMinutes($mmdurationminutes))
  $instance = Get-SCOMClassInstance -Name "'$($mmdevice)'"
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