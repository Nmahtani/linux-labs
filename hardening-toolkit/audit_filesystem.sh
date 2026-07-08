#!/usr/bin/env bash
# audit_filesystem.sh - audit permissions on critical system files

PASS=0
FAIL=0

echo "======================================"
echo " Filesystem Permissions Audit"
echo " $(date '+%Y-%m-%d %H:%M:%S')"
echo "======================================"
echo ""

pass() { echo "  [PASS] $1"; ((++PASS)); }
fail() { echo "  [FAIL] $1"; ((++FAIL)); }

# Helper: get octal permissions of a file (cross-platform)
get_perms() {
    stat -c "%a" "$1" 2>/dev/null
}

# Helper: get owner of a file
get_owner() {
    stat -c "%U" "$1" 2>/dev/null
}

# --- Check 1: /etc/passwd ---
echo "[ Checking /etc/passwd ]"
file="/etc/passwd"
perms=$(get_perms "$file")
owner=$(get_owner "$file")
if [[ "$owner" == "root" ]]; then
    pass "$file is owned by root"
else
    fail "$file is owned by $owner — should be root"
fi
if [[ "$perms" == "644" ]]; then
    pass "$file permissions are $perms (correct)"
else
    fail "$file permissions are $perms — should be 644"
fi

# --- Check 2: /etc/shadow ---
echo ""
echo "[ Checking /etc/shadow ]"
file="/etc/shadow"
perms=$(get_perms "$file")
owner=$(get_owner "$file")
if [[ "$owner" == "root" ]]; then
    pass "$file is owned by root"
else
    fail "$file is owned by $owner — should be root"
fi
if [[ "$perms" == "640" || "$perms" == "000" ]]; then
    pass "$file permissions are $perms (correct)"
else
    fail "$file permissions are $perms — should be 640 or 000"
fi

# --- Check 3: /etc/sudoers ---
echo ""
echo "[ Checking /etc/sudoers ]"
file="/etc/sudoers"
if [[ -f "$file" ]]; then
    perms=$(get_perms "$file")
    owner=$(get_owner "$file")
    if [[ "$owner" == "root" ]]; then
        pass "$file is owned by root"
    else
        fail "$file is owned by $owner — should be root"
    fi
    if [[ "$perms" == "440" || "$perms" == "400" ]]; then
        pass "$file permissions are $perms (correct)"
    else
        fail "$file permissions are $perms — should be 440"
    fi
else
    pass "/etc/sudoers not found (sudo may not be installed)"
fi

# --- Check 4: /etc/ssh/sshd_config ---
echo ""
echo "[ Checking /etc/ssh/sshd_config ]"
file="/etc/ssh/sshd_config"
if [[ -f "$file" ]]; then
    perms=$(get_perms "$file")
    owner=$(get_owner "$file")
    if [[ "$owner" == "root" ]]; then
        pass "$file is owned by root"
    else
        fail "$file is owned by $owner — should be root"
    fi
    if [[ "$perms" == "600" || "$perms" == "644" ]]; then
        pass "$file permissions are $perms (correct)"
    else
        fail "$file permissions are $perms — should be 600 or 644"
    fi
else
    fail "/etc/ssh/sshd_config not found"
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
