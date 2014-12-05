Add-PSSnapin Microsoft.SharePoint.PowerShell -ErrorAction SilentlyContinue;

Get-SPServiceInstance | Where { $_.TypeName -like "*Subscription Settings*" -or $_.TypeName -like "*App Management*" } | Start-SPServiceInstance;

$appPool = Get-SPServiceApplicationPool -Identity "SharePoint 2013 - Web Services";

$subscriptionSettingsApp = New-SPSubscriptionSettingsServiceApplication -ApplicationPool $appPool -Name "Subscription Settings" -DatabaseServer "sql2012primary.geektrainer.com\SharePoint" -DatabaseName "SharePoint_SubscriptionServices";
$subscriptionSettingsAppProxy = New-SPSubscriptionSettingsServiceApplicationProxy -ServiceApplication $subscriptionSettingsApp;

$appManagementApp = New-SPAppManagementServiceApplication -ApplicationPool $appPool -Name "App Management" -DatabaseServer "sql2012primary.geektrainer.com\sharepoint" -DatabaseName "SharePoint_AppManagement";
$appManagementAppProxy = New-SPAppManagementServiceApplicationProxy -Name "App Management" -ServiceApplication $appManagementApp;

Set-SPAppDomain "apps.sharepoint2013.com";
Set-SPAppSiteSubscriptionName -Name "app" -Confirm:$false;