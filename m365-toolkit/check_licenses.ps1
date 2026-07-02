# check_licenses.ps1 - find users without a license assigned

# Import the CSV file into a list PowerShell can work with.
$users = Import-Csv -Path "users.csv"

# Filter: keep only the users where LicenseAssigned is "False".
$noLicense = $users | Where-Object { $_.LicenseAssigned -eq "False" }

# Report.
Write-Host "Total users checked: $($users.Count)"
Write-Host "Users without a license: $($noLicense.Count)"
Write-Host ""

if ($noLicense.Count -gt 0) {
    Write-Host "--- Users missing a license ---"
    $noLicense | Select-Object Name, Email, Department | Format-Table -AutoSize
    $date = Get-Date -Format "yyyy-MM-dd"
    $outputFile = "report_licenses_$date.csv"
    $noLicense | Export-Csv -Path $outputFile -NoTypeInformation
    Write-Host "Report saved to: $outputFile"
} else {
    Write-Host "All users have a license assigned."
}
