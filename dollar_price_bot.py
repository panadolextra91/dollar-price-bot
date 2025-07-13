#!/usr/bin/env python3
import requests
import json
from datetime import datetime
import os
import platform
import subprocess

def fetch_usd_vnd_rate():
    """Fetch the USD to VND exchange rate using a free API"""
    try:
        # Using ExchangeRate-API's free tier
        response = requests.get("https://open.er-api.com/v6/latest/USD")
        data = response.json()
        
        if response.status_code == 200 and data["result"] == "success":
            vnd_rate = data["rates"]["VND"]
            return vnd_rate
        else:
            print(f"Error fetching exchange rate: {data.get('error-type', 'Unknown error')}")
            return None
    except Exception as e:
        print(f"Exception occurred: {str(e)}")
        return None

def display_exchange_rate():
    """Display the USD to VND exchange rate in the terminal"""
    now = datetime.now()
    date_str = now.strftime("%Y-%m-%d %H:%M:%S")
    
    print("=" * 50)
    print(f"USD to VND Exchange Rate - {date_str}")
    print("=" * 50)
    
    vnd_rate = fetch_usd_vnd_rate()
    
    if vnd_rate:
        print(f"1 USD = {vnd_rate:,.2f} VND")
        print(f"Current rates: $1 USD ↔ ₫{vnd_rate:,.2f} VND")
        
        # Create system notification
        show_notification(f"USD to VND: ₫{vnd_rate:,.2f}", f"1 USD = {vnd_rate:,.2f} VND as of {date_str}")
    else:
        print("Failed to fetch exchange rate data.")
    
    print("=" * 50)

def show_notification(title, message):
    """Show system notification based on OS"""
    system = platform.system()
    
    try:
        if system == "Darwin":  # macOS
            # Escape double quotes in the message and title
            title = title.replace('"', '\\"')
            message = message.replace('"', '\\"')
            
            # Use AppleScript to display notification
            script = f'''
            on run
                display notification "{message}" with title "{title}"
            end run
            '''
            
            # Write the script to a temporary file
            script_path = "/tmp/notification_script.scpt"
            with open(script_path, "w") as f:
                f.write(script)
            
            # Execute the AppleScript
            subprocess.run(["osascript", script_path], check=True)
            
            # Clean up
            os.remove(script_path)
        elif system == "Linux":
            # Check if notify-send is available
            try:
                subprocess.call(["notify-send", title, message])
            except FileNotFoundError:
                print("Notification system not available. Install 'libnotify-bin' package.")
        elif system == "Windows":
            from win10toast import ToastNotifier
            toaster = ToastNotifier()
            toaster.show_toast(title, message, duration=10)
        else:
            print("Notifications not supported on this platform.")
    except Exception as e:
        print(f"Failed to show notification: {str(e)}")

def save_to_history(vnd_rate):
    """Save exchange rate to history file"""
    now = datetime.now()
    date_str = now.strftime("%Y-%m-%d")
    
    history_dir = os.path.join(os.path.dirname(os.path.abspath(__file__)), "history")
    os.makedirs(history_dir, exist_ok=True)
    
    history_file = os.path.join(history_dir, "exchange_history.csv")
    file_exists = os.path.exists(history_file)
    
    with open(history_file, "a") as f:
        if not file_exists:
            f.write("date,usd_vnd_rate\n")
        f.write(f"{date_str},{vnd_rate}\n")

def create_daily_output(vnd_rate):
    """Create a file with today's exchange rate for easier terminal access"""
    now = datetime.now()
    date_str = now.strftime("%Y-%m-%d")
    time_str = now.strftime("%H:%M:%S")
    
    output_dir = os.path.dirname(os.path.abspath(__file__))
    output_file = os.path.join(output_dir, "todays_rate.txt")
    
    with open(output_file, "w") as f:
        f.write("=" * 50 + "\n")
        f.write(f"USD to VND Exchange Rate - {date_str} {time_str}\n")
        f.write("=" * 50 + "\n")
        f.write(f"1 USD = {vnd_rate:,.2f} VND\n")
        f.write(f"Current rates: $1 USD ↔ ₫{vnd_rate:,.2f} VND\n")
        f.write("=" * 50 + "\n")

if __name__ == "__main__":
    vnd_rate = fetch_usd_vnd_rate()
    if vnd_rate:
        save_to_history(vnd_rate)
        create_daily_output(vnd_rate)
    display_exchange_rate() 