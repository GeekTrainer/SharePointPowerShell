Add-PSSnapin Microsoft.SharePoint.PowerShell -ErrorAction SilentlyContinue

# Settings 
$IndexLocation = "C:\Index”
$SearchAppPoolName = "SharePoint - Search" 
$SearchAppPoolAccountName = "geektrainer\sp2013service" 
$SearchServerName = "SP2013Search1"; 
$SearchServiceName = "SharePoint Search Service" 
$SearchServiceProxyName = "SharePoint Search Service" 
$DatabaseName = "SharePoint_Search_Admin" 
Write-Host -ForegroundColor Yellow "Checking if Search Application Pool exists" 
$SPAppPool = Get-SPServiceApplicationPool -Identity $SearchAppPoolName -ErrorAction SilentlyContinue

if (!$SPAppPool) 
{ 
    Write-Host -ForegroundColor Green "Creating Search Application Pool" 
    $spAppPool = New-SPServiceApplicationPool -Name $SearchAppPoolName -Account $SearchAppPoolAccountName -Verbose 
}

# Start Services search service instance 
Write-host "Start Search Service instances...." 
Start-SPEnterpriseSearchServiceInstance $SearchServerName -ErrorAction SilentlyContinue 
Start-SPEnterpriseSearchQueryAndSiteSettingsServiceInstance $SearchServerName -ErrorAction SilentlyContinue

Write-Host -ForegroundColor Yellow "Checking if Search Service Application exists" 
$ServiceApplication = Get-SPEnterpriseSearchServiceApplication -Identity $SearchServiceName -ErrorAction SilentlyContinue

if (!$ServiceApplication) 
{ 
    Write-Host -ForegroundColor Green "Creating Search Service Application" 
    $ServiceApplication = New-SPEnterpriseSearchServiceApplication -Partitioned -Name $SearchServiceName -ApplicationPool $spAppPool.Name  
-DatabaseName $DatabaseName 
}

Write-Host -ForegroundColor Yellow "Checking if Search Service Application Proxy exists" 
$Proxy = Get-SPEnterpriseSearchServiceApplicationProxy -Identity $SearchServiceProxyName -ErrorAction SilentlyContinue

if (!$Proxy) 
{ 
    Write-Host -ForegroundColor Green "Creating Search Service Application Proxy" 
    New-SPEnterpriseSearchServiceApplicationProxy -Partitioned -Name $SearchServiceProxyName -SearchApplication $ServiceApplication 
}


$ServiceApplication.ActiveTopology 
Write-Host $ServiceApplication.ActiveTopology

# Clone the default Topology (which is empty) and create a new one and then activate it 
Write-Host "Configuring Search Component Topology...." 
$clone = $ServiceApplication.ActiveTopology.Clone() 
$SSI = Get-SPEnterpriseSearchServiceInstance -local 
New-SPEnterpriseSearchAdminComponent –SearchTopology $clone -SearchServiceInstance $SSI 
New-SPEnterpriseSearchContentProcessingComponent –SearchTopology $clone -SearchServiceInstance $SSI 
New-SPEnterpriseSearchAnalyticsProcessingComponent –SearchTopology $clone -SearchServiceInstance $SSI 
New-SPEnterpriseSearchCrawlComponent –SearchTopology $clone -SearchServiceInstance $SSI

Remove-Item -Recurse -Force -LiteralPath $IndexLocation -ErrorAction SilentlyContinue 
mkdir -Path $IndexLocation -Force

New-SPEnterpriseSearchIndexComponent –SearchTopology $clone -SearchServiceInstance $SSI -RootDirectory $IndexLocation 
New-SPEnterpriseSearchQueryProcessingComponent –SearchTopology $clone -SearchServiceInstance $SSI 
$clone.Activate()

Write-host "Your search service application $SearchServiceName is now ready"
