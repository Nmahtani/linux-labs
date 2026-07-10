# linux-labs

A collection of hands-on IT and systems administration projects built to
practice real-world skills across Linux, Bash, PowerShell and Microsoft 365.
Each project solves a problem that comes up regularly in production environments.

## Projects

### [sentinel](./sentinel/)
A lightweight service and system monitoring tool written in Bash. Checks
whether websites respond, monitors disk usage and tracks state changes over
time, only reporting when something actually changes.

**Stack:** Bash · curl · macOS/Linux  
**Skills:** HTTP health checking, disk monitoring, stateful alerting, shell
scripting

---

### [m365-toolkit](./m365-toolkit/)
A set of PowerShell scripts that automate common Microsoft 365 security audits:
detecting users without MFA, accounts missing licenses and devices not meeting
Intune compliance policy. Exports dated CSV reports ready to archive as audit
evidence.

**Stack:** PowerShell 7 · Entra ID (simulated) · Intune (simulated)  
**Skills:** M365 administration, security auditing, CSV automation, PowerShell
scripting

---

### [hardening-toolkit](./hardening-toolkit/)
A Linux server security auditing toolkit based on CIS Benchmark controls.
Audits SSH configuration, user accounts, filesystem permissions and running
services, producing a scored report out of 20 checks.

**Stack:** Bash · Ubuntu 24.04 LTS · GitHub Codespaces  
**Skills:** Linux hardening, SSH security, filesystem permissions, systemd vs
container environment detection

---

## Structure
