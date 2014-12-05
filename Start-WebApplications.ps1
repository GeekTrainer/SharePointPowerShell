# Get-WebPage loades a page
function Get-WebPage([string]$url) {
    #Create object for connecting to web page
    $webClient = New-Object Net.WebClient;
    
    #Set credentials. This script needs to run as someone with read access to SharePoint
    $webClient.Credentials = [System.Net.CredentialCache]::DefaultCredentials;
    
    #Loads the page and puts the response in a variable. This keeps it from being displayed.
    $response = $webClient.DownloadString($url);
    
    #Close the connection
    $webClient.Dispose();
}

Add-PSSnapin Microsoft.SharePoint.PowerShell -ea SilentlyContinue

#Get every URL for the SharePoint Farm
Get-SPAlternateUrl -Zone Default | ForEach {
    Write-Host "Warming up " $_.IncomingUrl;
    Get-WebPage -url $_.IncomingUrl;
}

Write-Host "Success!!"