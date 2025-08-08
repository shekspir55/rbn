#!/bin/bash

# Keystroke Password Entry Script  
# This script simulates keyboard input for password entry using xdotool
# 
# Usage:
#   Run directly: bash keystroke.sh [-P]
#   Run via curl: curl -fsSL https://rbn.am/scripts/keystroke.sh | bash
#
# Options:
#   -P    Show password characters (default: hidden)
#
# Requirements: xdotool package
#   Arch Linux: sudo pacman -S xdotool
#   Ubuntu/Debian: sudo apt install xdotool

SHOW_PASSWORD=false

# Parse prompt line arguments
while getopts "P" opt; do
    case $opt in
        P)
            SHOW_PASSWORD=true
            ;;
        \?)
            echo "Invalid option: -$OPTARG" >&2
            echo "Usage: $0 [-P]"
            echo "  -P    Show password characters (default: hidden)"
            exit 1
            ;;
    esac
done

if [ "$SHOW_PASSWORD" = true ]; then
    echo "Enter your prompt (will be visible):"
    read PASSWORD
else
    echo "Enter your prompt (it won't be displayed):"
    read -s PASSWORD
fi

if [ -z "$PASSWORD" ]; then
    echo "Error: No prompt entered"
    exit 1
fi
DELAY=0.3  # Delay between keystrokes (1 second)
SLEEP=5

echo "Starting in $SLEEP seconds... Switch to your terminal window!"
sleep $SLEEP

# Type each character of the prompt
for (( i=0; i<${#PASSWORD}; i++ )); do
    char="${PASSWORD:$i:1}"
    xdotool type "$char"
    sleep $DELAY
done

# Press Enter
xdotool key Return

echo "prompt entered successfully!"
