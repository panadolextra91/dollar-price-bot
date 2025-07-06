# Dollar Price Bot

A simple tool to track the USD to VND exchange rate daily. The bot fetches the latest exchange rate data from a free API and displays it in your terminal.

## Features

- Fetches the latest USD to VND exchange rate
- Runs automatically every day at 7:00 AM
- Shows a system notification with the current rate
- Creates a daily rate file for quick terminal access
- Provides the `usd-vnd` command for instant terminal access
- Saves historical data in CSV format

## Setup

1. Clone this repository:

```bash
git clone https://github.com/panadolextra91/dollar-price-bot
cd dollar-price-bot
```

2. Run the setup script to create a virtual environment, install dependencies and schedule the daily task:

```bash
chmod +x setup_scheduler.sh
./setup_scheduler.sh
```

The script will:
- Create a Python virtual environment
- Install required dependencies
- Schedule the bot to run daily at 7:00 AM using cron
- Install the `usd-vnd` command for easy access

## Viewing the Exchange Rate

There are multiple ways to view the exchange rate:

1. **System Notifications**: When the script runs at 7:00 AM, it will show a system notification with the current rate.

2. **Using the `usd-vnd` command**:
   ```bash
   usd-vnd
   ```
   Simply type `usd-vnd` in your terminal to instantly view the latest exchange rate.

3. **Using the show_rate.sh script**:
   ```bash
   ./show_rate.sh
   ```
   This will display the latest exchange rate data in your terminal.

4. **Running the script manually**:
   ```bash
   # If setup script was already run
   ./venv/bin/python dollar_price_bot.py
   
   # Or activate the virtual environment first
   source venv/bin/activate
   python dollar_price_bot.py
   ```

## Data Storage

- Current day's rate: `todays_rate.txt` in the project root
- Historical data: `history/exchange_history.csv`

## Requirements

- Python 3.6+
- Requests library
- Cron (for scheduling)
- For Windows: win10toast package (installed automatically)

## License

MIT 