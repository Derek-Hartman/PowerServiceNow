<#
.Synopsis
    Get ServiceNow user by username

.EXAMPLE
    Get-ServiceNowUserByUsername -CompURL "verabradley" -AdminUser "fdsaf" -AdminPass "fasdf" -Username "bsaget"

.NOTES
    Modified by: Derek Hartman
    Date: 3/24/2023

#>
[Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls12
Function Get-ServiceNowUserByUsername {
    [CmdletBinding()]

    param(
        [Parameter(Mandatory = $True,
            ValueFromPipeline = $True,
            HelpMessage = "Enter your Companies URL.")]
        [string[]]$CompURL,

        [Parameter(Mandatory = $True,
            ValueFromPipeline = $True,
            HelpMessage = "Enter your Admin Username.")]
        [string[]]$AdminUser,

        [Parameter(Mandatory = $True,
            ValueFromPipeline = $True,
            HelpMessage = "Enter your Admin Password.")]
        [string[]]$AdminPass,

        [Parameter(Mandatory = $True,
            ValueFromPipeline = $True,
            HelpMessage = "Enter the ServiceNow Username you are searching.")]
        [string[]]$Username

    )

    # Build auth header
    $base64AuthInfo = [Convert]::ToBase64String([Text.Encoding]::ASCII.GetBytes(("{0}:{1}" -f $($AdminUser), $($AdminPass))))
    # Set proper headers
    $headers = New-Object "System.Collections.Generic.Dictionary[[String],[String]]"
    $headers.Add('Authorization',('Basic {0}' -f $base64AuthInfo))
    $headers.Add('Accept','application/json')


    # Specify endpoint uri
    $uri = "https://$($CompURL).service-now.com/api/now/table/sys_user?sysparm_query=user_name%3D$($Username)&sysparm_limit=1"

    # Send HTTP request
    $response = Invoke-RestMethod -Method Get -Headers $headers -Uri $uri 

    Write-Output $response.Result
}