param (
    [Parameter(Mandatory=$true)]
    [string] $azureDevOpsTeam, 
    [Parameter(Mandatory=$true)]
    [string] $azureDevOpsPat, 
    [Parameter(Mandatory=$true)]
    [string] $azureDevOpsAgentPool,
    [string] $dockerImageName = "win",
    [string] $dockerRegistry, 
    [string] $dockerTag = "latest"
    )

# $dockerImageName = "win"
# $dockerRegistry = ""
# $dockerTag = ":latest"
$dockerImage = $dockerRegistry + $dockerImageName + $dockerTag
$agentName = $dockerImageName + "-" + [System.guid]::NewGuid().toString().SubString(0, 6)

Write-Output "Running docker image: $dockerImage with agent name: $agentName"

docker run `
    -d `
    --name $agentName `
    --restart unless-stopped `
    -e AZP_POOL=$azureDevOpsAgentPool `
    -e AZP_URL="https://dev.azure.com/$azureDevOpsTeam" `
    -e AZP_TOKEN=$azureDevOpsPat `
    -e AZP_AGENT_NAME=$agentName `
    $dockerImage
