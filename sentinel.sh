#!/usr/bin/env bash
# sentinel.sh - run all monitoring checks in one go

echo "=============================="
echo " Sentinel monitoring run"
echo " $(date)"
echo "=============================="

echo ""
echo "--- Website checks ---"
./check_all.sh

echo ""
echo "--- Disk check ---"
./check_disk.sh

echo ""
echo "=============================="
echo " Run complete"
echo "=============================="
