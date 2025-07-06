#!/bin/bash

# Get the absolute path of the script directory
SCRIPT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )"

# Create a virtual environment if it doesn't exist
if [ ! -d "$SCRIPT_DIR/venv" ]; then
    echo "Creating virtual environment..."
    python3 -m venv "$SCRIPT_DIR/venv"
fi

# Activate virtual environment and install dependencies
echo "Installing required Python packages..."
source "$SCRIPT_DIR/venv/bin/activate"
pip install -r "$SCRIPT_DIR/requirements.txt"

# Create a temporary crontab file
TEMP_CRON_FILE=$(mktemp)

# Export current crontab to the temporary file
crontab -l > "$TEMP_CRON_FILE" 2>/dev/null || echo "# Dollar Price Bot Cron Jobs" > "$TEMP_CRON_FILE"

# Check if cron job already exists
if ! grep -q "dollar_price_bot.py" "$TEMP_CRON_FILE"; then
    # Add new cron job for running the script at 7:00 AM every day
    echo "0 7 * * * cd $SCRIPT_DIR && $SCRIPT_DIR/venv/bin/python $SCRIPT_DIR/dollar_price_bot.py" >> "$TEMP_CRON_FILE"
    
    # Install the new crontab
    crontab "$TEMP_CRON_FILE"
    echo "Scheduled dollar price bot to run daily at 7:00 AM"
else
    echo "Dollar price bot is already scheduled"
fi

# Remove the temporary file
rm "$TEMP_CRON_FILE"

# Make the main script executable
chmod +x "$SCRIPT_DIR/dollar_price_bot.py"
chmod +x "$SCRIPT_DIR/show_rate.sh"

# Install the usd-vnd command
echo "Setting up the 'usd-vnd' command..."
chmod +x "$SCRIPT_DIR/install_command.sh"
"$SCRIPT_DIR/install_command.sh"

echo "Dollar Price Bot setup complete!"
echo "To test the script now, run: $SCRIPT_DIR/venv/bin/python $SCRIPT_DIR/dollar_price_bot.py"
echo "To display today's exchange rate, run: usd-vnd" 