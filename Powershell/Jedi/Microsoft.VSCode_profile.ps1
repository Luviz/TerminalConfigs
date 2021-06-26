##
## VS Code PS CORE Profile
##

Import-Module posh-git 
Import-Module oh-my-posh 
Import-Module "$HOME\Documents\Powershell\JediModule.psm1"

$ThemeSettings.MyThemesLocation = "$HOME\Documents\Powershell\jediThemes"

Set-Theme theJedi 
