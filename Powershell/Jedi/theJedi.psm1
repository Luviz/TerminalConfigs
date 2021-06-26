#requires -Version 2 -Modules posh-git

function Write-Theme {

    param(
        [bool]
        $lastCommandFailed,
        [string]
        $with
    )
    $prompt += Set-Newline
    if ($sl.Options["AzMode"]) {
        # check Az.Accounts

        $prompt = Write-Prompt -Object ([char]::ConvertFromUtf32(0x250C)) -ForegroundColor $sl.Colors.PromptSymbolColor

        $mod = Get-Module Az.Accounts
        if ($null -ne $mod) {
            $azConnection = $sl.Options["AzContext"] # Get-AzContext # the daley is abit too loang 
            if ($null -ne $azConnection) {
                $mail = $azConnection.Account.Id
                $tenant = $azConnection.Tenant.Id
                $subName = $azConnection.Subscription.Name
                $prompt += Write-Segment -content "$mail T:$tenant S:$subName "
            }
            else {
                $prompt += Write-Segment -content "Not connected try Login-AzAccount"
            }
        }
        else {
            $prompt += Write-Segment -content "Could not find Az"
        }
        $prompt += Set-Newline
        $prompt = Write-Prompt -Object ([char]::ConvertFromUtf32(0x251C)) -ForegroundColor $sl.Colors.PromptSymbolColor

    }
    else {
        # ln 1
        $prompt = Write-Prompt -Object ([char]::ConvertFromUtf32(0x250C)) -ForegroundColor $sl.Colors.PromptSymbolColor
    }
    
    # # PS version
    if ($PSVersionTable.PSVersion.Major -eq 5) {
        $prompt += Write-Segment -content '5' -endWith '-'
    }
    else {
        $prompt += Write-Segment -content $PSVersionTable.PSVersion.ToString() -endWith '-'
    }
    
    # print path 
    $path = Get-FullPath -dir $pwd
    $prompt += Write-Segment -content $path -ForegroundColor $sl.Colors.PromptForegroundColor


    $status = Get-VCSStatus
    if ($status) {
        $vcsInfo = Get-VcsInfo -status ($status)
        $info = $vcsInfo.VcInfo
        $prompt += Write-Segment -content $info -foregroundColor $vcsInfo.BackgroundColor
    }

    #check for elevated prompt
    If (Test-Administrator) {
        $prompt += Write-Segment -content $sl.PromptSymbols.ElevatedSymbol -foregroundColor $sl.Colors.AdminIconForegroundColor
    }

    #check the last command state and indicate if failed
    If ($lastCommandFailed) {
        $prompt += Write-Segment -content $sl.PromptSymbols.FailedCommandSymbol -foregroundColor $sl.Colors.CommandFailedIconForegroundColor
    }

    $prompt += ''

    # SECOND LINE
    $prompt += Set-Newline
    $prompt += Write-Prompt -Object ([char]::ConvertFromUtf32(0x2514)) -ForegroundColor $sl.Colors.PromptSymbolColor
    
    if (Test-VirtualEnv) {
        $prompt += Write-Prompt -Object "$($sl.PromptSymbols.SegmentForwardSymbol) $($sl.PromptSymbols.SegmentBackwardSymbol)" -ForegroundColor $sl.Colors.PromptSymbolColor
        $prompt += Write-Prompt -Object "$($sl.PromptSymbols.VirtualEnvSymbol) $(Get-VirtualEnvName)" -ForegroundColor $sl.Colors.VirtualEnvForegroundColor
    }

    if ($with) {
        $prompt += Write-Prompt -Object "$($sl.PromptSymbols.SegmentForwardSymbol) $($sl.PromptSymbols.SegmentBackwardSymbol)" -ForegroundColor $sl.Colors.PromptSymbolColor
        $prompt += Write-Prompt -Object "$($with.ToUpper())" -ForegroundColor $sl.Colors.WithForegroundColor
    }

    # [host@user]
    $user = $sl.CurrentUser
    $computer = $sl.CurrentHostname #26A1 #0x1F525 #1F4A9
    $centersymbole = [char]::ConvertFromUtf32(0x1F525) #""#$sl.PromptSymbols.ElevatedSymbol
    $prompt += Write-Segment -content "$user$centersymbole$computer" -foregroundColor $sl.Colors.PromptForegroundColor
    
    $prompt += Write-Prompt -Object "$($sl.PromptSymbols.PromptIndicator) " -ForegroundColor $sl.Colors.PromptSymbolColor
    $prompt
}

function Write-Segment {

    param(
        $content,
        $foregroundColor,
        $backgroundColor,
        $endWith = ''
    )

    $prompt += Write-Prompt -Object $sl.PromptSymbols.SegmentBackwardSymbol -ForegroundColor $sl.Colors.PromptSymbolColor
    $prompt += Write-Prompt -Object $content -ForegroundColor $foregroundColor -BackgroundColor $backgroundColor
    $prompt += Write-Prompt -Object "$($sl.PromptSymbols.SegmentForwardSymbol)" -ForegroundColor $sl.Colors.PromptSymbolColor
    $prompt += Write-Prompt -Object $endWith -ForegroundColor $sl.Colors.PromptSymbolColor
    return $prompt
}

$sl = $global:ThemeSettings #local settings
$sl.PromptSymbols.PromptIndicator = '|>'
$sl.PromptSymbols.SegmentForwardSymbol = ']'
$sl.PromptSymbols.SegmentBackwardSymbol = '['
$sl.PromptSymbols.PathSeparator = '\'
$sl.Colors.PromptForegroundColor = [ConsoleColor]::Gray
$sl.Colors.PromptSymbolColor = [ConsoleColor]::Cyan
$sl.Colors.PromptHighlightColor = [ConsoleColor]::DarkBlue
$sl.Colors.GitForegroundColor = [ConsoleColor]::Red
$sl.Colors.WithForegroundColor = [ConsoleColor]::White
$sl.Colors.WithBackgroundColor = [ConsoleColor]::Magenta
$sl.Colors.VirtualEnvBackgroundColor = [System.ConsoleColor]::Magenta
$sl.Colors.VirtualEnvForegroundColor = [System.ConsoleColor]::White
$sl.Options["AzMode"] = $false
$sl.Options["PnPMode"] = $false

if (Test-Administrator) {
    $sl.Colors.PromptSymbolColor = [ConsoleColor]::Red
}


if ($PSVersionTable.PSVersion.Major -gt 5) {
    $sl.PromptSymbols.FailedCommandSymbol = "💩"
    $sl.PromptSymbols.PromptIndicator = '|>'
}
else {
    $sl.PromptSymbols.FailedCommandSymbol = "X"
}