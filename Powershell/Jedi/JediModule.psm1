$JEDI= [PSCustomObject]@{
    repos="$HOME\source\repos"
}

function Enter-AzMode {
    param (
        # Parameter help description
        [Parameter()]
        [bool]
        $yeah=$true
    )
    $global:ThemeSettings.Options["AzMode"]=$yeah
    $mod = Get-Module Az.Accounts
    if ($null -ne $mod){
        Update-AzConnection
    }else {
        Write-Host "Az.Accounts not loaded, trying to import..."
        Import-Module az
    }
}

function Update-AzConnection {
    $global:ThemeSettings.Options["AzContext"]= Get-AzContext    
}


function Set-Repo {
    Set-Location $JEDI.repos
}
