#!/bin/bash

# Get the absolute path of the script directory
SCRIPT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )"

# Check if today's rate file exists
RATE_FILE="$SCRIPT_DIR/todays_rate.txt"

if [ -f "$RATE_FILE" ]; then
    # Display the contents of the file
    cat "$RATE_FILE"
else
    # If file doesn't exist, run the script to generate it
    echo "No exchange rate data for today yet. Fetching now..."
    "$SCRIPT_DIR/venv/bin/python" "$SCRIPT_DIR/dollar_price_bot.py"
fi 