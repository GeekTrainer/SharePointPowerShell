$machinesToActivate = @("dev")
$serviceInstanceNames = @("Word Viewing Service", "PowerPoint Service", "Excel Calculation Services")
foreach ($machine in $machinesToActivate) 
{
  foreach ($serviceInstance in $serviceInstanceNames)
  {
     $serviceID = $(Get-SPServiceInstance | where {$_.TypeName -match $serviceInstance} | where {$_.Server -match "SPServer Name="+$machine}).ID
     Start-SPServiceInstance -Identity $serviceID 
  } 
}

$appPool = Get-SPServiceApplicationPool -Identity "SharePoint Web Services Default"
New-SPWordViewingServiceApplication -Name "WdView" -ApplicationPool $appPool | New-SPWordViewingServiceApplicationProxy -Name "WdProxy"
New-SPPowerPointServiceApplication -Name "PPT" -ApplicationPool $appPool | New-SPPowerPointServiceApplicationProxy -Name "PPTProxy" 
New-SPExcelServiceApplication -Name "Excel" -ApplicationPool $appPool

$webAppsFeatureId = $(Get-SPFeature -limit all | where {$_.displayname -eq "OfficeWebApps"}).Id 
Get-SPSite -limit ALL |foreach{Enable-SPFeature $webAppsFeatureId -url $_.URL }  