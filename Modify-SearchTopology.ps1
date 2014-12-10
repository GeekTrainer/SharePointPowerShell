Add-PSSnapin Microsoft.SharePoint.PowerShell -ea SilentlyContinue

# Get the secondary server
$newServer = Get-SPEnterpriseSearchServiceInstance -Identity "SecondaryAppServer"

# Start the search service
Start-SPEnterpriseSearchServiceInstance -Identity $newServer

#Wait for service to start
Get-SPEnterpriseSearchServiceInstance -Identity $newServer

# Clone the existing topology
$ssa = Get-SPEnterpriseSearchServiceApplication
$currentTopology = Get-SPEnterpriseSearchTopology -Active -SearchApplication $ssa
$newTopology = New-SPEnterpriseSearchTopology -SearchTopology $currentTopology `
    -SearchApplication $ssa -Clone

# Modify topology
New-SPEnterpriseSearchIndexComponent -SearchTopology $newTopology `
    -SearchServiceInstance $newServer -IndexPartition 1

# Save settings
Set-SPEnterpriseSearchTopology -Identity $newTopology