#!/bin/bash

# Math Quiz Game
# Timed math challenge with scoring

# Game configuration
QUESTIONS=5
TIMEOUT=10  # seconds per question
LEVEL=1     # 1:easy, 2:medium, 3:hard
score=0

# Colors
GREEN='\033[0;32m'
RED='\033[0;31m'
NC='\033[0m' # No Color

function generate_question() {
    case $LEVEL in
        1) # Easy: addition/subtraction up to 20
            a=$((RANDOM % 20 + 1))
            b=$((RANDOM % 20 + 1))
            op=$((RANDOM % 2))
            [[ $op -eq 0 ]] && { echo "$a + $b = ?"; echo $((a + b)); } || { echo "$a - $b = ?"; echo $((a - b)); }
            ;;
        2) # Medium: multiplication up to 12×12
            a=$((RANDOM % 12 + 1))
            b=$((RANDOM % 12 + 1))
            echo "$a × $b = ?"
            echo $((a * b))
            ;;
        3) # Hard: mixed operations with larger numbers
            a=$((RANDOM % 50 + 10))
            b=$((RANDOM % 50 + 10))
            case $((RANDOM % 3)) in
                0) echo "$a + $b = ?"; echo $((a + b)) ;;
                1) echo "$a - $b = ?"; echo $((a - b)) ;;
                2) echo "$a × $b = ?"; echo $((a * b)) ;;
            esac
            ;;
    esac
}

function countdown() {
    local seconds=$1
    while [ $seconds -gt 0 ]; do
        echo -ne "Time remaining: $seconds seconds\033[0K\r"
        sleep 1
        ((seconds--))
    done
}

function show_menu() {
    clear
    echo "╔══════════════════════════╗"
    echo "║      MATH QUIZ GAME      ║"
    echo "╠══════════════════════════╣"
    echo "║ 1. Easy                  ║"
    echo "║ 2. Medium                ║"
    echo "║ 3. Hard                  ║"
    echo "║ 4. Exit                  ║"
    echo "╚══════════════════════════╝"
}

# Main game loop
show_menu
read -p "Select difficulty (1-4): " LEVEL

[ $LEVEL -eq 4 ] && exit 0

clear
echo -e "Get ready! ${QUESTIONS} questions coming with ${TIMEOUT} seconds each!\n"

for ((i=1; i<=$QUESTIONS; i++)); do
    # Generate question and answer
    read -r question answer < <(generate_question)
    
    echo "Question $i/$QUESTIONS:"
    echo -e "${GREEN}$question${NC}"
    
    # Start timeout in background
    (countdown $TIMEOUT) &
    countdown_pid=$!
    
    # Get user answer
    read -t $TIMEOUT -p "Your answer: " user_answer
    
    # Stop the countdown
    kill $countdown_pid 2>/dev/null
    
    # Check answer
    if [ $? -ne 0 ]; then
        echo -e "${RED}Time's up!${NC} The answer was: $answer"
    elif [ "$user_answer" = "$answer" ]; then
        echo -e "${GREEN}Correct!${NC}"
        ((score++))
    else
        echo -e "${RED}Wrong!${NC} The answer was: $answer"
    fi
    echo
done

# Show results
percentage=$((score * 100 / QUESTIONS))
echo "Quiz complete! You scored $score out of $QUESTIONS (${percentage}%)"

# Rating based on performance
if [ $percentage -ge 90 ]; then
    echo "⭐⭐⭐ Math Genius! ⭐⭐⭐"
elif [ $percentage -ge 70 ]; then
    echo "⭐⭐ Great job! ⭐⭐"
elif [ $percentage -ge 50 ]; then
    echo "⭐ Good effort! ⭐"
else
    echo "Keep practicing!"
fi
