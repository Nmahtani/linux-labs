#!/usr/bin/env bash
# hardening_check.sh - run all security audits and generate a summary report

echo ""
echo "############################################"
echo "#                                          #"
echo "#      Linux Hardening Toolkit v1.0        #"
echo "#      Security Audit Report               #"
echo "#                                          #"
echo "############################################"
echo ""
echo "  Host    : $(hostname)"
echo "  OS      : $(grep PRETTY_NAME /etc/os-release | cut -d= -f2 | tr -d '"')"
echo "  Date    : $(date '+%Y-%m-%d %H:%M:%S')"
echo "  User    : $(whoami)"
echo ""
echo "############################################"
echo ""

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

# --- Run each audit and capture pass/fail counts ---
run_audit() {
    local name="$1"
    local script="$2"
    echo "Running $name..."
    echo ""
    output=$(sudo "$SCRIPT_DIR/$script" 2>/dev/null)
    echo "$output"
    echo ""
    # Extract pass and fail counts from the results line
    passed=$(echo "$output" | grep "Results:" | grep -oP '\d+ passed' | grep -oP '\d+')
    failed=$(echo "$output" | grep "Results:" | grep -oP '\d+ failed' | grep -oP '\d+')
    TOTAL_PASS=$((TOTAL_PASS + passed))
    TOTAL_FAIL=$((TOTAL_FAIL + failed))
}

TOTAL_PASS=0
TOTAL_FAIL=0

run_audit "SSH Configuration Audit"       "audit_ssh.sh"
run_audit "User Account Audit"            "audit_users.sh"
run_audit "Filesystem Permissions Audit"  "audit_filesystem.sh"
run_audit "Running Services Audit"        "audit_services.sh"

# --- Final score ---
TOTAL=$((TOTAL_PASS + TOTAL_FAIL))
echo "############################################"
echo "#          FINAL SECURITY SCORE            #"
echo "############################################"
echo ""
echo "  Checks passed : $TOTAL_PASS"
echo "  Checks failed : $TOTAL_FAIL"
echo "  Total checks  : $TOTAL"
echo ""

if [[ $TOTAL -gt 0 ]]; then
    score=$(( TOTAL_PASS * 100 / TOTAL ))
    echo "  Score: $score%"
    echo ""
    if [[ $score -eq 100 ]]; then
        echo "  Status: FULLY HARDENED"
    elif [[ $score -ge 80 ]]; then
        echo "  Status: MOSTLY SECURE — review failed checks"
    elif [[ $score -ge 60 ]]; then
        echo "  Status: NEEDS WORK — several issues found"
    else
        echo "  Status: HIGH RISK — immediate action required"
    fi
fi
echo ""
echo "############################################"
echo ""
echo "Review the output above for details on each failed check."
echo "Run individual audit scripts for more information."
