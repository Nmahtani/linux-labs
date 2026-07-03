# M365 Admin Toolkit

A set of PowerShell scripts that automate common Microsoft 365 administration
and security audit tasks. Built to simulate the kind of checks an IT admin
would run regularly on a real tenant.

Built as a hands-on learning project to practice PowerShell scripting and
Microsoft 365 administration concepts.

## What it does

Manually checking which users are missing MFA, which have no license assigned,
or which devices are out of compliance is repetitive and error-prone. These
scripts automate those checks and export the results to dated CSV files, ready
to share or archive as audit evidence.

## Components

- **`check_mfa.ps1`** — finds users without MFA enabled. Exports results to
  a dated CSV file.
- **`check_licenses.ps1`** — finds users without a Microsoft 365 license
  assigned. Exports results to a dated CSV file.
- **`check_compliance.ps1`** — finds devices not meeting company compliance
  policy in Intune. Exports results to a dated CSV file.
- **`run_audit.ps1`** — orchestrator that runs all three audits in one command
  with a timestamped header.

## Data files

- **`users.csv`** — simulated Entra ID user export (name, email, department,
  MFA status, license status).
- **`devices.csv`** — simulated Intune device export (device name, owner,
  type, OS, compliance status).

In a real environment, these CSV files would be replaced by live data pulled
directly from Microsoft Graph API or exported from the Entra ID / Intune
portals.

## Usage

Run all audits at once:

    pwsh run_audit.ps1

Or run individual checks:

    pwsh check_mfa.ps1
    pwsh check_licenses.ps1
    pwsh check_compliance.ps1

Reports are saved automatically as `report_<type>_<date>.csv` in the same
folder.

## Concepts practiced

- Reading and filtering CSV data with `Import-Csv` and `Where-Object`
-
