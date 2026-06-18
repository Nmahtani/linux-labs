#!/usr/bin/env bash
# check_state.sh. Check a URL and only report when its state CHANGES

# The URL to check.
URL="${1:-https://github.com}"

# File where we remember the last known state.
ARCHIVO_ESTADO="last_state.txt"

# --- Check the URL right now ---
codigo=$(curl -s -L -o /dev/null -w "%{http_code}" -m 10 "$URL")

if [ "$codigo" = "200" ]; then
    estado_actual="UP"
else
    estado_actual="DOWN"
fi

# --- Read the previous state, if we have one ---
if [ -f "$ARCHIVO_ESTADO" ]; then
    estado_anterior=$(cat "$ARCHIVO_ESTADO")
else
    estado_anterior="NONE"
fi

# --- Compare and report only on change ---
if [ "$estado_actual" != "$estado_anterior" ]; then
    echo "CHANGE - $URL went from $estado_anterior to $estado_actual"
else
    echo "(no change - still $estado_actual)"
fi

# --- Save the current state for next time ---
echo "$estado_actual" > "$ARCHIVO_ESTADO"
