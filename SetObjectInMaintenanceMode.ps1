Param(
    [string]$mmdevice,
    [string]$mmdurationminutes,
       [int]$mmcomment,
    [string]$mmreason
)

# Import SCOM module
Import-Module OperationsManager

# Copy the environment variables to their parameters
if (test-path env:\SNC_collection) {
  $mmdevice          = $env:SNC_mmdevice
  $mmdurationminutes = $env:SNC_mmdurantionminutes
  $mmcomment         = $env:SNC_mmcomment
  $mmreason          = $env:SNC_mmreason
}

SNCLog-ParameterInfo @("Running SetObjectToMaintenanceMode", $mmdevice)

function Set-ObjectToMaintenanceMode() {
  New-SCOMManagementGroupConnection -computer $computer
  
  $mmdevice = $args[0];
  $mmdurationminutes = $args[1];
  $mmcomment = $args[2];
  $mmreason = $args[3];

  $endTime = ((Get-Date).AddMinutes($mmdurationminutes))
  $instance = Get-SCOMClassInstance -Name $mmdevice
  Start-SCOMMaintenanceMode -Instance $instance -EndTime $endTime -Comment $mmcomment -Reason $mmreason
}

$session = Create-PSSession -scomServerName $computer -credential $cred

try {
    SNCLog-DebugInfo "`tInvoking Invoke-Command -ScriptBlock `$'{function:Set-ObjectToMaintenanceMode}' -ArgumentList $instance $endTime $mmcomment $mmreason"
    Invoke-Command -Session $session -ScriptBlock ${function:Set-ObjectToMaintenanceMode} -ArgumentList $instance $endTime $mmcomment $mmreason
} finally {
    Remove-PSSession -session $session
}