#!/bin/bash

# Simple calculator script to add two numbers

echo "Simple Calculator - Addition"
echo "============================"

# Method 1: Get numbers from user input
echo "Enter the first number:"
read num1

echo "Enter the second number:"
read num2

# Perform addition
sum=$((num1 + num2))

# Display result
echo "Result: $num1 + $num2 = $sum"

# Alternative method: Accept numbers as command line arguments
# Uncomment the section below if you prefer command line arguments

# if [ $# -eq 2 ]; then
#     num1=$1
#     num2=$2
#     sum=$((num1 + num2))
#     echo "Command line result: $num1 + $num2 = $sum"
# elif [ $# -ne 0 ]; then
#     echo "Usage: $0 <number1> <number2>"
#     echo "Or run without arguments for interactive mode"
# fi
