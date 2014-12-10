Add-PSSnapin Microsoft.SharePoint.PowerShell -ErrorAction SilentlyContinue

New-SPWeb https://intranet.sharepoint2013.com/FromScript -Template "STS#0"