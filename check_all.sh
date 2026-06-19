#!/usr/bin/env bash
# check_all.sh - check several URLs read from a file

# File with one URL per line.
ARCHIVO="services.txt"

# Read the file line by line; each line is one URL to check.
while IFS= read -r url; do

    # Ask curl for just the HTTP status code (follow redirects with -L).
    codigo=$(curl -s -L -o /dev/null -w "%{http_code}" -m 10 "$url")

    # Report the result for this URL.
    if [ "$codigo" = "200" ]; then
        echo "OK - $url ($codigo)"
    else
        echo "FAIL - $url ($codigo)"
    fi

done < "$ARCHIVO"
