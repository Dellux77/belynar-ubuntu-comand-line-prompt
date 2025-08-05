#!/bin/bash

# Weather Reporter for Git Bash
# Uses wttr.in service (no API key required)
# Save as weather.sh and run with: bash weather.sh

echo "================================"
echo "      Weather Reporter"
echo "================================"

# Function to display weather for a location
get_weather() {
    local location=$1
    local format=$2
    
    echo "Fetching weather for: $location"
    echo "--------------------------------"
    
    # Use curl to fetch weather data from wttr.in
    if command -v curl &> /dev/null; then
        curl -s "wttr.in/$location?$format"
    else
        echo "Error: curl is not installed. Please install curl to use this weather reporter."
        return 1
    fi
}

# Function to get detailed weather report
get_detailed_weather() {
    local location=$1
    get_weather "$location" "0"
}

# Function to get compact weather report
get_compact_weather() {
    local location=$1
    get_weather "$location" "format=3"
}

# Function to get one-line weather report
get_oneline_weather() {
    local location=$1
    get_weather "$location" "format=%l:+%c+%t+%h+%w"
}

# Function to get weather with moon phase
get_weather_with_moon() {
    local location=$1
    get_weather "$location" "M"
}

# Function to display help
show_help() {
    echo ""
    echo "Weather Reporter Help:"
    echo "======================"
    echo ""
    echo "Usage options:"
    echo "1. Just run the script for interactive mode"
    echo "2. Pass city name as argument: bash weather.sh London"
    echo "3. Use coordinates: bash weather.sh '40.7128,-74.0060'"
    echo "4. Use airport code: bash weather.sh JFK"
    echo ""
    echo "Interactive commands:"
    echo "- Enter city name for detailed weather"
    echo "- 'compact [city]' for compact view"
    echo "- 'oneline [city]' for one-line summary"
    echo "- 'moon [city]' for weather with moon phase"
    echo "- 'help' for this help message"
    echo "- 'quit' to exit"
    echo ""
    echo "Examples:"
    echo "- London"
    echo "- New York"
    echo "- compact Paris"
    echo "- oneline Tokyo"
    echo "- moon Moscow"
    echo "- 40.7128,-74.0060 (coordinates)"
    echo "- JFK (airport code)"
}

# Check if location is provided as command line argument
if [ $# -gt 0 ]; then
    location="$*"
    get_detailed_weather "$location"
    exit 0
fi

# Interactive mode
echo ""
echo "Welcome to Weather Reporter!"
echo "Enter a city name, coordinates, or airport code."
echo "Type 'help' for more options or 'quit' to exit."

while true; do
    echo ""
    read -p "Weather> " input
    
    # Check if user wants to quit
    if [[ "$input" == "quit" || "$input" == "exit" || "$input" == "q" ]]; then
        echo "Thanks for using Weather Reporter!"
        break
    fi
    
    # Check for help command
    if [[ "$input" == "help" || "$input" == "h" ]]; then
        show_help
        continue
    fi
    
    # Check if input is empty
    if [[ -z "$input" ]]; then
        echo "Please enter a location or command."
        continue
    fi
    
    # Parse command and location
    read -a parts <<< "$input"
    command=${parts[0]}
    location="${parts[@]:1}"
    
    case $command in
        "compact")
            if [[ -z "$location" ]]; then
                echo "Please specify a location. Example: compact London"
            else
                echo ""
                get_compact_weather "$location"
            fi
            ;;
        "oneline")
            if [[ -z "$location" ]]; then
                echo "Please specify a location. Example: oneline Paris"
            else
                echo ""
                get_oneline_weather "$location"
            fi
            ;;
        "moon")
            if [[ -z "$location" ]]; then
                echo "Please specify a location. Example: moon Tokyo"
            else
                echo ""
                get_weather_with_moon "$location"
            fi
            ;;
        *)
            # Treat entire input as location for detailed weather
            echo ""
            get_detailed_weather "$input"
            ;;
    esac
done
