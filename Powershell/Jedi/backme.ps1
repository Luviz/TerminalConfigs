$dir = Split-Path $MyInvocation.InvocationName
# Write-Host $dir

$ignore = "Modules|testchar"

$items = Get-ChildItem $dir | Where-Object {$_.Name -notmatch $ignore}
$items

# $currLoc = $PWD

# Set-Location $dir
$items | Copy-Item -Recurse -Destination ./PowerShell/Jedi 


# Set-Location $currLoc