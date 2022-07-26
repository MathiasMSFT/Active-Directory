# Change the default path for computer objects or user objects
By default when you don't precreate the computer object, it will be placed in computer container. Only GPOs linked to the root path will be applied to those machine (same thing for user container).


## Parameters
### List
List the current configuration
```
PS> .\Container-Mgmt.ps1 -List -DomainName contoso.com
```

![image](./images/List.png)


### Replace
Change the path of a specific container
```
PS> .\Container-Mgmt.ps1 -Replace -Container Computers -OldPath "CN=Computers,DC=contoso,DC=com" -NewPath "OU=Computer Quarantine,DC=contoso,DC=com" -DomainName contoso.com
```

![image](./images/Replace.png)

![image](./images/Result-Replace.png)

## Error you could see

![image](./images/Error.png)


# Disclaimer
See [DISCLAIMER](./DISCLAIMER.md).