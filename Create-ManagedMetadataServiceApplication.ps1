Add-PSSnapin Microsoft.SharePoint.PowerShell -ErrorAction SilentlyContinue;

Get-SPServiceInstance | Where { $_.TypeName -like "*Metadata*" -and $_.Server -like "*App*" } | Start-SPServiceInstance;
New-SPMetadataServiceApplication -ApplicationPool "SharePoint 2013 - Web Services" -Name "Managed Metadata Services" -DatabaseName "SharePoint_ManagedMetadataServices" -DatabaseServer "sql2012primary.geektrainer.com\SharePoint";
New-SPMetadataServiceApplicationProxy -Name "Managed Metadata Services" -ServiceApplication "Managed Metadata Services" -DefaultProxyGroup -DefaultKeywordTaxonomy -DefaultSiteCollectionTaxonomy