<#
.Synopsis
    Updates the Phone Number of a location within ServiceNow

.EXAMPLE
    Set-ServiceNowLocationPhone -CompURL "verabradley" -AdminUser "fdsaf" -AdminPass "fasdf" -LocationSysID "1245fe46d324632c4632a45" -PhoneNum "367-853-9850"

.NOTES
    Modified by: Derek Hartman
    Date: 3/29/2023

#>
[Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls12
Function Set-ServiceNowLocationPhone {
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
            HelpMessage = "Enter the ServiceNow Location Sys ID.")]
        [string[]]$LocationSysID,

        [Parameter(Mandatory = $True,
            ValueFromPipeline = $True,
            HelpMessage = "Enter the New Phone Number.")]
        [string[]]$PhoneNum

    )

    # Build auth header
    $base64AuthInfo = [Convert]::ToBase64String([Text.Encoding]::ASCII.GetBytes(("{0}:{1}" -f $($AdminUser), $($AdminPass))))
    # Set proper headers
    $headers = New-Object "System.Collections.Generic.Dictionary[[String],[String]]"
    $headers.Add('Authorization',('Basic {0}' -f $base64AuthInfo))
    $headers.Add('Accept','application/json')


    # Specify endpoint uri
    $uri = "https://$($CompURL).service-now.com/api/now/table/cmn_location/$($LocationSysID)"

    # Specify request body
    $body = "{`"phone`":`"$($PhoneNum)`"}"

    # Send HTTP request
    $response = Invoke-RestMethod -Method Put -Headers $headers -Uri $uri -Body $body

    Write-Output $response.Result
}