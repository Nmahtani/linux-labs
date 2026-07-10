#!/usr/bin/env bash
# audit_ssh.sh - audit SSH configuration for security issues

SSHD_CONFIG="/etc/ssh/sshd_config"
PASS=0
FAIL=0

echo "======================================"
echo " SSH Configuration Audit"
echo " $(date '+%Y-%m-%d %H:%M:%S')"
echo "======================================"
echo ""

# Helper functions to report results
pass() { echo "  [PASS] $1"; ((++PASS)); }
fail() { echo "  [FAIL] $1"; ((++FAIL)); }

# --- Check 1: PermitRootLogin ---
echo "[ Checking root login ]"
root_login=$(grep -i "^PermitRootLogin" "$SSHD_CONFIG" | awk '{print $2}')
if [[ "$root_login" == "no" || "$root_login" == "prohibit-password" ]]; then
    pass "PermitRootLogin is set to '$root_login'"
else
    fail "PermitRootLogin is '$root_login' — should be 'no' or 'prohibit-password'"
fi

# --- Check 2: PasswordAuthentication ---
echo ""
echo "[ Checking password authentication ]"
pass_auth=$(grep -i "^PasswordAuthentication" "$SSHD_CONFIG" | awk '{print $2}')
if [[ "$pass_auth" == "no" ]]; then
    pass "PasswordAuthentication is disabled"
else
    fail "PasswordAuthentication is '$pass_auth' — should be 'no' (use SSH keys instead)"
fi

# --- Check 3: X11Forwarding ---
echo ""
echo "[ Checking X11 forwarding ]"
x11=$(grep -i "^X11Forwarding" "$SSHD_CONFIG" | awk '{print $2}')
if [[ "$x11" == "no" || -z "$x11" ]]; then
    pass "X11Forwarding is disabled"
else
    fail "X11Forwarding is '$x11' — should be 'no' on a server"
fi

# --- Check 4: SSH Port ---
echo ""
echo "[ Checking SSH port ]"
ssh_port=$(grep -i "^Port" "$SSHD_CONFIG" | awk '{print $2}')
if [[ "$ssh_port" != "22" && -n "$ssh_port" ]]; then
    pass "SSH is running on non-default port $ssh_port"
else
    fail "SSH is on default port 22 — consider changing it"
fi

# --- Check 5: MaxAuthTries ---
echo ""
echo "[ Checking MaxAuthTries ]"
max_auth=$(grep -i "^MaxAuthTries" "$SSHD_CONFIG" | awk '{print $2}')
if [[ -n "$max_auth" && "$max_auth" -le 3 ]]; then
    pass "MaxAuthTries is set to $max_auth"
else
    fail "MaxAuthTries not set or too high — should be 3 or less to limit brute force"
fi

# --- Summary ---
echo ""
echo "======================================"
TOTAL=$((PASS + FAIL))
echo " Results: $PASS passed, $FAIL failed out of $TOTAL checks"
if [[ $FAIL -eq 0 ]]; then
    echo " Status: SECURE"
else
    echo " Status: NEEDS ATTENTION — $FAIL issue(s) found"
fi
echo "======================================"
