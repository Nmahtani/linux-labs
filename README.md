# linux-labs

[![Code Quality](https://github.com/Nmahtani/linux-labs/actions/workflows/quality.yml/badge.svg)](https://github.com/Nmahtani/linux-labs/actions/workflows/quality.yml)

> A collection of hands-on IT and systems administration projects built to practice real-world skills across Linux, Bash, PowerShell, and Microsoft 365.
> Each project solves a problem that comes up regularly in production environments.

---

## Projects

### 🔍 [Sentinel](./sentinel/) — Service Monitoring Tool

A lightweight service and system monitoring tool written in Bash. Checks whether websites respond, monitors local disk usage, and tracks state changes over time — only reporting when something actually changes.

| | |
|---|---|
| **Stack** | Bash · curl · macOS / Linux |
| **Skills** | HTTP health checking · disk monitoring · stateful alerting · shell scripting |

---

### 🔐 [M365 Admin Toolkit](./m365-toolkit/) — Microsoft 365 Security Audits

A set of PowerShell scripts that automate common Microsoft 365 security audits: detecting users without MFA, accounts missing licenses, and devices not meeting Intune compliance policy. Exports dated CSV reports ready to archive as audit evidence.

| | |
|---|---|
| **Stack** | PowerShell 7 · Entra ID (simulated) · Intune (simulated) |
| **Skills** | M365 administration · security auditing · CSV export · PowerShell scripting |

---

### 🛡️ [Hardening Toolkit](./hardening-toolkit/) — Linux Server Security Audit

A Linux server security auditing toolkit based on CIS Benchmark controls. Audits SSH configuration, user accounts, filesystem permissions, and running services — producing a scored security report out of 20 checks.

| | |
|---|---|
| **Stack** | Bash · Ubuntu 24.04 LTS · GitHub Codespaces (Azure) |
| **Skills** | Linux hardening · SSH security · filesystem permissions · environment detection |

---

## Repository structure

```
linux-labs/
├── sentinel/               # Bash service monitoring tool
├── m365-toolkit/           # PowerShell M365 security audit scripts
└── hardening-toolkit/      # Linux server hardening and audit toolkit
```

## About

Built incrementally as part of an active learning path covering Linux
administration, cloud infrastructure (AZ-104, AWS SAA), and IT security.
Each project is documented, tested on real systems, and built from scratch.

---

**Author:** Nikhil Mahtani &nbsp;·&nbsp; [GitHub](https://github.com/Nmahtani)
