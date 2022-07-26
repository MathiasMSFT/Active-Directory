<#
.SYNOPSIS
    PowerShell Script to read the default path of container and change some of them

.DESCRIPTION
    The script lists the default path for each container. You can also change some of them.

.EXAMPLE
    List default path
    PS C:\> .\Container-Mgmt.ps1 -List -DomainName contoso.com

.EXAMPLE
    Change path for specific container
    PS C:\> .\Container-Mgmt.ps1 -Replace -Container Computers -OldPath "CN=Computers,DC=contoso,DC=com" -NewPath "OU=Computer Quarantine,DC=contoso,DC=com" -DomainName contoso.com

.NOTES

.LINK


#>
[CmdletBinding()]
param (
    [Switch]$List,
    [Switch]$Replace,
    [Parameter(Mandatory=$false, Position=1)]
    [ValidateSet("Users", "Computers")]
    $Container,
    [Parameter(Mandatory=$false, Position=2)]
    $OldPath,
    [Parameter(Mandatory=$false, Position=3)]
    $NewPath,
    [Parameter(Mandatory=$true, Position=4)]
    $DomainName
)


Set-Variable -Scope Script -Option Constant -Name SystemContainersId -Value @{
    'NTDSQuotas' = '6227F0AF1FC2410D8E3BB10615BB5B0F'
    'Microsoft' = 'F4BE92A4C777485E878E9421D53087DB'
    'ProgramData' = '09460C08AE1E4A4EA0F64AEE7DAA1E5A'
    'ForeignSecurityPrincipals' = '22B70C67D56E4EFB91E9300FCA3DC1AA'
    'DeletedObjects' = '18E2EA80684F11D2B9AA00C04F79F805'
    'Infrastructure' = '2FBAC1870ADE11D297C400C04FD8D5CD'
    'LostAndFound' = 'AB8153B7768811D1ADED00C04FD8D5CD'
    'System' = 'AB1D30F3768811D1ADED00C04FD8D5CD'
    'DomainControllers' = 'A361B2FFFFD211D1AA4B00C04FD7D83A'
    'Computers' = 'AA312825768811D1ADED00C04FD8D5CD'
    'Users' = 'A9D1CA15768811D1ADED00C04FD8D5CD'
    'ManagedServiceAccounts' = '1EB93889E40C45DF9F0C64D23BBB6237'
}

[Microsoft.ActiveDirectory.Management.ADDomain]$Domain = Get-ADDomain $DomainName

$Parameter = $MyInvocation.BoundParameters.Keys
Switch ($Parameter) {
    "List" {
        ## Get information
        (Get-ADObject -Identity $($Domain.DistinguishedName) -Properties wellKnownObjects).wellKnownObjects
    }
    "Replace" {
        try {
            ## Replace value
            $attr = 'wellKnownObjects'
            $ContainerId = $script:SystemContainersId[$Container]
            $old = "B:32:$($ContainerId):$OldPath"
            $new = "B:32:$($ContainerId):$NewPath"
            Set-ADObject -Identity $Domain.DistinguishedName `
                            -Add @{ $attr = $new } `
                            -Remove @{ $attr = $old }
            Write-Host "NewPath for '$($Container)' has been replaced" -ForegroundColor Green
        } catch {
            Write-Host "Unable to redirect system container '$($Container)' to '$($new)'." -ForegroundColor Red
        }
    }
}
