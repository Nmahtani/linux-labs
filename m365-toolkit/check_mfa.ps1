# check_mfa.ps1 - find users without MFA enabled

# Import the CSV file into a list of objects PowerShell can work with.
$users = Import-Csv -Path "users.csv"

# Filter: keep only the users where MFAEnabled is the text "False".
$noMfa = $users | Where-Object { $_.MFAEnabled -eq "False" }

# Report.
Write-Host "Total users checked: $($users.Count)"
Write-Host "Users without MFA: $($noMfa.Count)"
Write-Host ""

if ($noMfa.Count -gt 0) {
    Write-Host "--- Users missing MFA ---"
    $noMfa | Select-Object Name, Email, Department | Format-Table -AutoSize
} else {
    Write-Host "All users have MFA enabled."
}
