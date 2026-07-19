Write-Host "`nYou've been hacked! Your devices are now gone`n"

$code = @"
    [DllImport("user32.dll")]
    public static extern bool BlockInput(bool fBlockIt);
"@

$userInput = Add-Type -MemberDefinition $code -Name UserInput -Namespace UserInput -PassThru

function Disable-UserInput($seconds) {
    try {
        # $userInput::BlockInput($true)
        # Get-PnpDevice | Where-Object {$_.Class -eq 'HIDClass' -and $_.InstanceId -like 'ACPI*'} | Disable-PnpDevice -Confirm:$false
        # Get-PnpDevice | Where-Object {$_.FriendlyName -like '*touch screen*'} | Disable-PnpDevice -Confirm:$false

        powercfg /setacvalueindex scheme_current sub_buttons pbuttonaction 0
        powercfg /setdcvalueindex scheme_current sub_buttons pbuttonaction 0
        powercfg /setacvalueindex scheme_current sub_buttons lidaction 0
        powercfg /setdcvalueindex scheme_current sub_buttons lidaction 0

        Start-Sleep $seconds
    }
    finally {
        # $userInput::BlockInput($false)
        # Get-PnpDevice | Where-Object {$_.Class -eq 'HIDClass' -and $_.InstanceId -like 'ACPI*'} | Enable-PnpDevice -Confirm:$false
        # Get-PnpDevice | Where-Object {$_.FriendlyName -like '*touch screen*'} | Enable-PnpDevice -Confirm:$false

        powercfg /setacvalueindex scheme_current sub_buttons pbuttonaction 1
        powercfg /setdcvalueindex scheme_current sub_buttons pbuttonaction 1
        powercfg /setacvalueindex scheme_current sub_buttons lidaction 1
        powercfg /setdcvalueindex scheme_current sub_buttons lidaction 1
        
    }
}

Disable-UserInput -seconds 20 | Out-Null
