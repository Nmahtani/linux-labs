#!/usr/bin/env bash
# check.sh - check if the URL responds correctly.

# The URL to check: If passed, we use it. If not, use default.
URL="${1:-https://google.com}"

# We request curl only the code of state of the HTTP of the URL.
codigo=$(curl -s -L -o /dev/null -w "%{http_code}" -m 10 "$URL")

# Check the result:
if [ "$codigo" = "200" ]; then
    echo "OK   - $URL responds 200"
else
    echo "FALLO - $URL returns $codigo"
fi
