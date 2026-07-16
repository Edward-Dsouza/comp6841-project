Write-Host "`nYou've been hacked! Your devices are now gone`n"

$code = @"
    [DllImport("user32.dll")]
    public static extern bool BlockInput(bool fBlockIt);
"@

$userInput = Add-Type -MemberDefinition $code -Name UserInput -Namespace UserInput -PassThru

function Disable-UserInput($seconds) {
    try {
        $userInput::BlockInput($true)
        Get-PnpDevice | Where-Object {$_.FriendlyName -like '*touch screen*'} | Disable-PnpDevice -Confirm:$false
        Start-Sleep $seconds
    }
    finally {
        $userInput::BlockInput($false)
        Get-PnpDevice | Where-Object {$_.FriendlyName -like '*touch screen*'} | Enable-PnpDevice -Confirm:$false
    }
}

Disable-UserInput -seconds 20 | Out-Null
