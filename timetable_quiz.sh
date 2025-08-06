#!/bin/bash

# --- Times Table Quiz ---

# Set the range for the times tables
MIN_TABLE=2
MAX_TABLE=12

# Set the number of questions
NUM_QUESTIONS=10

score=0

echo "Welcome to the Times Table Quiz!"
echo "You'll be asked $NUM_QUESTIONS multiplication questions."
echo "Let's begin!"
echo "-----------------------------------"

for i in $(seq 1 $NUM_QUESTIONS)
do
    # Generate two random numbers within the specified range
    num1=$((RANDOM % (MAX_TABLE - MIN_TABLE + 1) + MIN_TABLE))
    num2=$((RANDOM % (MAX_TABLE - MIN_TABLE + 1) + MIN_TABLE))
    
    # Calculate the correct answer
    answer=$((num1 * num2))

    # Ask the question and get user input
    read -p "Question $i: What is $num1 x $num2? " user_answer

    # Check if the user's answer is correct
    if [ "$user_answer" == "$answer" ]; then
        echo "Correct!"
        score=$((score + 1))
    else
        echo "Incorrect. The correct answer was $answer."
    fi
    echo
done

echo "-----------------------------------"
echo "Quiz complete!"
echo "You got $score out of $NUM_QUESTIONS questions correct."
echo "Thanks for playing!"
