#!/bin/bash

# Simple Calculator for Git Bash
# Save this file as calculator.sh and run with: bash calculator.sh

echo "================================"
echo "    Simple Bash Calculator"
echo "================================"

# Function to perform calculation
calculate() {
    local num1=$1
    local operator=$2
    local num2=$3
    
    case $operator in
        "+")
            result=$(echo "$num1 + $num2" | bc -l)
            ;;
        "-")
            result=$(echo "$num1 - $num2" | bc -l)
            ;;
        "*")
            result=$(echo "$num1 * $num2" | bc -l)
            ;;
        "/")
            if [ "$num2" == "0" ]; then
                echo "Error: Division by zero!"
                return 1
            fi
            result=$(echo "scale=4; $num1 / $num2" | bc -l)
            ;;
        "^" | "")
            result=$(echo "$num1 ^ $num2" | bc -l)
            ;;
        "%")
            result=$(echo "$num1 % $num2" | bc -l)
            ;;
        *)
            echo "Error: Invalid operator!"
            return 1
            ;;
    esac
    
    echo "Result: $result"
}

# Main calculator loop
while true; do
    echo ""
    echo "Enter calculation (or 'quit' to exit):"
    echo "Format: number operator number"
    echo "Operators: + - * / ^ % "
    echo "Example: 5 + 3"
    echo ""
    
    read -p "> " input
    
    # Check if user wants to quit
    if [[ "$input" == "quit" || "$input" == "exit" || "$input" == "q" ]]; then
        echo "Goodbye!"
        break
    fi
    
    # Parse input into components
    read -a parts <<< "$input"
    
    # Check if we have exactly 3 parts
    if [ ${#parts[@]} -ne 3 ]; then
        echo "Error: Please enter in format: number operator number"
        continue
    fi
    
    num1=${parts[0]}
    operator=${parts[1]}
    num2=${parts[2]}
    
    # Validate that num1 and num2 are numbers
    if ! [[ "$num1" =~ ^-?[0-9]+\.?[0-9]$ ]] || ! [[ "$num2" =~ ^-?[0-9]+\.?[0-9]$ ]]; then
        echo "Error: Please enter valid numbers!"
        continue
    fi
    
    # Perform calculation
    calculate "$num1" "$operator" "$num2"
done
