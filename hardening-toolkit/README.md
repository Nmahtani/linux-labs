# Linux Hardening Toolkit

A set of Bash scripts that audit a Linux server against common security
misconfigurations, based on industry-standard hardening guidelines (CIS
Benchmark). Run one command and get a scored security report across four
critical areas.

Built as a hands-on project to practice Linux security, system administration,
and Bash scripting on a real Ubuntu server.

## The problem it solves

A freshly installed Linux server is not secure by default. SSH allows root
login, unnecessary services may be running, file permissions may be too open.
Checking all of this manually takes time and is error-prone. This toolkit
automates the audit and produces a clear, scored report in seconds.

## Audit areas

- **SSH configuration** — root login, password authentication, X11 forwarding,
  default port, brute force protection.
- **User accounts** — empty passwords, unauthorized UID 0 accounts, password
  expiry policy, unexpected login shells.
- **Filesystem permissions** — ownership and permission modes on `/etc/passwd`,
  `/etc/shadow`, `/etc/sudoers`, and `/etc/ssh/sshd_config`.
- **Running services** — detects unnecessary or risky services (Bluetooth,
  Telnet, FTP, printing, etc.) that increase attack surface.

## Usage

Run the full audit with a single command:

    sudo ./hardening_check.sh

Or run individual audits:

    sudo ./audit_ssh.sh
    sudo ./audit_users.sh
    sudo ./audit_filesystem.sh
    sudo ./audit_services.sh

## Sample output

    Checks passed : 16
    Checks failed : 4
    Total checks  : 20
    Score: 80%
    Status: MOSTLY SECURE — review failed checks

## Score levels

| Score | Status |
|---|---|
| 100% | FULLY HARDENED |
| 80–99% | MOSTLY SECURE — review failed checks |
| 60–79% | NEEDS WORK — several issues found |
| < 60% | HIGH RISK — immediate action required |

## Environment compatibility

Tested on Ubuntu 24.04 LTS (GitHub Codespaces / Azure VM). Automatically
detects whether systemd or a container environment is present and adjusts
accordingly. Portable to any Debian-based Linux system.

Requires `sudo` for checks that read protected system files (`/etc/shadow`,
`/etc/sudoers`).

## Security standards referenced

- CIS Benchmark for Ubuntu Linux
- NIST SP 800-123 (Guide to General Server Security)
- SSH hardening best practices (Mozilla SecOps)

## Concepts practiced

- Reading and parsing system configuration files with `grep` and `awk`
- Octal file permissions and the Linux permission model
- Environment detection (systemd vs container)
- Bash functions, arrays, and exit code handling
- Structured reporting with scored output

## Possible next steps

- Add automatic remediation (not just detection) with a `--fix` flag
- Export report to a dated text file for audit evidence
- Add kernel parameter checks (`/proc/sys` hardening)
- Package as a single installer for deployment across multiple servers

## Tested on

Ubuntu 24.04 LTS — GitHub Codespaces (Azure), using Bash 5.2.

---

**Author:** Nikhil Mahtani
