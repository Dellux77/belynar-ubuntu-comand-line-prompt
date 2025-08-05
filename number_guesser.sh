#!/bin/bash

# Number Guesser Game
# Goal: Script that picks a random number (1-10) for guessing
# Save as number_guesser.sh and run with: bash number_guesser.sh

echo "================================"
echo "    NUMBER GUESSER GAME"
echo "================================"
echo "I'm thinking of a number between 1 and 10!"
echo ""

# Generate random number between 1-10 using $RANDOM
secret_number=$(( ($RANDOM % 10) + 1 ))

# Initialize variables
attempts=0
max_attempts=3
guessed_correctly=false

echo "You have $max_attempts attempts to guess my number."
echo ""

# Main game loop
while [ $attempts -lt $max_attempts ] && [ "$guessed_correctly" = false ]; do
    attempts=$(( attempts + 1 ))
    
    echo "Attempt $attempts of $max_attempts:"
    read -p "Enter your guess (1-10): " user_guess
    
    # Validate input - check if it's a number
    if ! [[ "$user_guess" =~ ^[0-9]+$ ]]; then
        echo "❌ Please enter a valid number!"
        attempts=$(( attempts - 1 ))  # Don't count invalid input as attempt
        echo ""
        continue
    fi
    
    # Check if number is in valid range
    if [ "$user_guess" -lt 1 ] || [ "$user_guess" -gt 10 ]; then
        echo "❌ Please enter a number between 1 and 10!"
        attempts=$(( attempts - 1 ))  # Don't count invalid input as attempt
        echo ""
        continue
    fi
    
    # Compare guess with secret number using if/else
    if [ "$user_guess" -eq "$secret_number" ]; then
        echo "🎉 CONGRATULATIONS! You guessed it!"
        echo "✅ The number was indeed $secret_number!"
        echo "🏆 You won in $attempts attempt(s)!"
        guessed_correctly=true
    else
        if [ "$user_guess" -lt "$secret_number" ]; then
            echo "📈 Too low! Try higher."
        else
            echo "📉 Too high! Try lower."
        fi
        
        # Show remaining attempts
        remaining=$(( max_attempts - attempts ))
        if [ $remaining -gt 0 ]; then
            echo "💡 You have $remaining attempt(s) left."
        fi
    fi
    
    echo ""
done

# Check if player lost
if [ "$guessed_correctly" = false ]; then
    echo "💔 Game Over! You've used all your attempts."
    echo "🔢 The secret number was: $secret_number"
    echo "🔄 Better luck next time!"
fi

echo ""
echo "Thanks for playing Number Guesser!"
echo "================================"

# Ask if player wants to play again
echo ""
read -p "Would you like to play again? (y/n): " play_again

if [ "$play_again" = "y" ] || [ "$play_again" = "Y" ] || [ "$play_again" = "yes" ]; then
    echo ""
    exec bash "$0"  # Restart the script
else
    echo "Goodbye! 👋"
fi
