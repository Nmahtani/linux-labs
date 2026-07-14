#!/usr/bin/env bash
# audit_users.sh - audit system users for security issues

PASS=0
FAIL=0

echo "======================================"
echo " User Account Audit"
echo " $(date '+%Y-%m-%d %H:%M:%S')"
echo "======================================"
echo ""

pass() { echo "  [PASS] $1"; ((++PASS)); }
fail() { echo "  [FAIL] $1"; ((++FAIL)); }
info() { echo "  [INFO] $1"; }
# --- Require root privileges ---
if [[ $EUID -ne 0 ]]; then
    echo "  [WARN] Some checks require root. Run with: sudo ./audit_users.sh"
    echo ""
fi
# --- Check 1: accounts with no password ---
echo "[ Checking for accounts with no password ]"
no_pass=$(awk -F: '($2 == "" || $2 == "!!" ) && $1 != "root" {print $1}' /etc/shadow 2>/dev/null)
if [[ -z "$no_pass" ]]; then
    pass "No accounts found with empty password"
else
    fail "Accounts with no password: $no_pass"
fi

# --- Check 2: users with UID 0 other than root ---
echo ""
echo "[ Checking for non-root accounts with UID 0 ]"
uid0=$(awk -F: '$3 == 0 && $1 != "root" {print $1}' /etc/passwd)
if [[ -z "$uid0" ]]; then
    pass "No non-root accounts with UID 0 found"
else
    fail "Non-root accounts with UID 0 (full root power): $uid0"
fi

# --- Check 3: password expiry policy ---
echo ""
echo "[ Checking password expiry policy ]"
never_expires=""
# shellcheck disable=SC2034  # lastchange, min, warn are positional fields we skip
while IFS=: read -r user pass lastchange min max warn; do
while IFS=: read -r user pass lastchange min max warn; do
    # skip system accounts (UID < 1000) and locked accounts
    uid=$(awk -F: -v u="$user" '$1==u {print $3}' /etc/passwd 2>/dev/null)
    [[ -z "$uid" || "$uid" -lt 1000 ]] && continue
    [[ "$pass" == "!" || "$pass" == "*" || "$pass" == "!!" ]] && continue
    if [[ "$max" == "99999" || "$max" == "" || "$max" == "-1" ]]; then
        never_expires="$never_expires $user"
    fi
done < /etc/shadow 2>/dev/null
if [[ -z "$never_expires" ]]; then
    pass "All regular user passwords have an expiry policy"
else
    fail "Users with passwords that never expire:$never_expires"
fi

# --- Check 4: users with a login shell that may not need one ---
echo ""
echo "[ Checking for unexpected users with login shell ]"
shell_users=$(awk -F: '$7 ~ /bash|sh/ && $3 >= 1000 && $1 != "codespace" {print $1}' /etc/passwd)
if [[ -z "$shell_users" ]]; then
    pass "No unexpected users with login shell found"
else
    info "Users with login shell (review manually): $shell_users"
fi

# --- List all human users for reference ---
echo ""
echo "[ Human user accounts on this system ]"
awk -F: '$3 >= 1000 && $1 != "nobody" {print "  - "$1" (UID "$3")"}' /etc/passwd

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
