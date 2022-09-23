# Change the default replication interval to instant
By default your intersite replication is to 15 min. For example, considering you have 2 sites (On-Prem and Azure), you have to wait 15 min to have your modification done in Azure.
This can lead to business issues (users have to wait 15 min) or security issues (accounts will be disabled after 15 min).

![image](./images/SitesAndServices.png)

## Automatically
Via PowerShell
```
$NamingContext = (Get-ADRootDSE).configurationNamingContext
Get-ADObject -LDAPFilter "(objectCategory=sitelink)" –Searchbase $NamingContext -Properties options | ForEach-Object { 
    Set-ADObject $_ –replace @{ options = $($_.options -bor 1) }
}
```

Via GUI

![image](./images/Automatically.png)


## Validate
Be sure you have "USE_NOTIFY".

![image](./images/Validate-Option.png)


# Disclaimer
See [DISCLAIMER](./DISCLAIMER.md).