#!/bin/bash

# Simple Secret Message Encoder/Decoder
# Uses a Caesar cipher (shift by 3 by default)

function encode() {
    local message="$1"
    echo "$message" | tr 'A-Za-z' 'D-ZA-Cd-za-c'
}

function decode() {
    local message="$1"
    echo "$message" | tr 'D-ZA-Cd-za-c' 'A-Za-z'
}

echo "Secret Message Tool"
echo "1. Encode a message"
echo "2. Decode a message"
echo "3. Exit"

read -p "Choose an option (1-3): " choice

case $choice in
    1)
        read -p "Enter message to encode: " message
        encoded=$(encode "$message")
        echo "Encoded message: $encoded"
        ;;
    2)
        read -p "Enter message to decode: " message
        decoded=$(decode "$message")
        echo "Decoded message: $decoded"
        ;;
    3)
        echo "Goodbye!"
        exit 0
        ;;
    *)
        echo "Invalid option"
        exit 1
        ;;
esac
