Add-PSSnapin Microsoft.SharePoint.PowerShell

$stateService = New-SPStateServiceApplication -Name "State Service"
New-SPStateServiceDatabase -Name "SharePoint_StateService" -ServiceApplication $stateService
New-SPStateServiceApplicationProxy -Name "State Service" -ServiceApplication $stateService -DefaultProxyGroup