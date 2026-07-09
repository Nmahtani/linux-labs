#!/usr/bin/env bash
# audit_services.sh - audit running services for unnecessary or risky ones

PASS=0
FAIL=0
WARN=0

echo "======================================"
echo " Running Services Audit"
echo " $(date '+%Y-%m-%d %H:%M:%S')"
echo "======================================"
echo ""

pass() { echo "  [PASS] $1"; ((++PASS)); }
fail() { echo "  [FAIL] $1"; ((++FAIL)); }
warn() { echo "  [WARN] $1"; ((++WARN)); }
info() { echo "  [INFO] $1"; }
# --- Detect environment: systemd or container ---
echo "[ Detecting environment ]"
if [[ "$(ps -p 1 -o comm=)" == "systemd" ]]; then
    ENV_TYPE="systemd"
    info "systemd detected — full service audit available"
else
    ENV_TYPE="container"
    info "Container/minimal environment detected — using 'service' command"
fi
echo ""

# --- Helper: check if a service is running ---
is_running() {
    local svc="$1"
    if [[ "$ENV_TYPE" == "systemd" ]]; then
        systemctl is-active --quiet "$svc" 2>/dev/null
    else
        service "$svc" status &>/dev/null
    fi
}

# --- List of services that should NOT be running on a server ---
# These are common services found on desktop installs or poorly configured
# servers that add unnecessary attack surface.
RISKY_SERVICES=(
    "bluetooth"
    "cups"
    "avahi-daemon"
    "telnet"
    "vsftpd"
    "rsh"
    "rlogin"
    "nis"
    "talk"
    "x11-common"
)

echo "[ Checking for unnecessary or risky services ]"
found_risky=0
for svc in "${RISKY_SERVICES[@]}"; do
    if is_running "$svc"; then
        fail "$svc is running — consider disabling it"
        ((found_risky++))
    fi
done
if [[ $found_risky -eq 0 ]]; then
    pass "No unnecessary or risky services found running"
fi

# --- Check: SSH is running (it should be) ---
echo ""
echo "[ Checking SSH service ]"
if is_running "ssh" || is_running "sshd"; then
    pass "SSH service is running"
else
    warn "SSH service is not running — remote access may be unavailable"
fi

# --- Check: Telnet is NOT running (it should never be) ---
echo ""
echo "[ Checking Telnet ]"
if is_running "telnet" || is_running "inetd"; then
    fail "Telnet or inetd is running — Telnet sends passwords in plain text, disable immediately"
else
    pass "Telnet is not running"
fi

# --- List all currently active services for reference ---
echo ""
echo "[ Currently active services ]"
if [[ "$ENV_TYPE" == "systemd" ]]; then
    systemctl list-units --type=service --state=running --no-legend 2>/dev/null | \
        awk '{print "  - "$1}'
else
service --status-all 2>/dev/null | grep '\[ + \]' | \
        awk '{print "  - "$4}'
fi

# --- Summary ---
echo ""
echo "======================================"
TOTAL=$((PASS + FAIL))
echo " Results: $PASS passed, $FAIL failed out of $TOTAL checks"
[[ $WARN -gt 0 ]] && echo " Warnings: $WARN"
if [[ $FAIL -eq 0 ]]; then
    echo " Status: SECURE"
else
    echo " Status: NEEDS ATTENTION — $FAIL issue(s) found"
fi
echo "======================================"
