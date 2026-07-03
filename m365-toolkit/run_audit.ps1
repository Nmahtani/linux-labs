# run_audit.ps1 - run all M365 audits in one go

$date = Get-Date -Format "yyyy-MM-dd HH:mm:ss"

Write-Host "======================================"
Write-Host " M365 Admin Toolkit - Audit Run"
Write-Host " $date"
Write-Host "======================================"

Write-Host ""
Write-Host "--- MFA Audit ---"
& "./check_mfa.ps1"

Write-Host ""
Write-Host "--- License Audit ---"
& "./check_licenses.ps1"

Write-Host ""
Write-Host "--- Device Compliance Audit ---"
& "./check_compliance.ps1"

Write-Host ""
Write-Host "======================================"
Write-Host " Audit complete. Check reports above."
Write-Host "======================================"
