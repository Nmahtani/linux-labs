# check_compliance.ps1 - find devices that are not compliant with company policy

# Import the CSV file with the list of devices.
$devices = Import-Csv -Path "devices.csv"

# Filter: keep only the devices where CompliantStatus is "False".
$nonCompliant = $devices | Where-Object { $_.CompliantStatus -eq "False" }

# Report.
Write-Host "Total devices checked: $($devices.Count)"
Write-Host "Non-compliant devices: $($nonCompliant.Count)"
Write-Host ""

if ($nonCompliant.Count -gt 0) {
    Write-Host "--- Devices not meeting company policy ---"
    $nonCompliant | Select-Object DeviceName, Owner, Type, OS | Format-Table -AutoSize
$date = Get-Date -Format "yyyy-MM-dd"
    $outputFile = "report_compliance_$date.csv"
    $nonCompliant | Export-Csv -Path $outputFile -NoTypeInformation
    Write-Host "Report saved to: $outputFile"
} else {
    Write-Host "All devices are compliant."
}
