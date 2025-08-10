#!/bin/bash

# Simple Virtual Pet Game
PET_NAME=""
HUNGER=50
HAPPINESS=50
HEALTH=100

# Colors
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m'

show_pet() {
    if [ $HAPPINESS -gt 60 ]; then
        echo "  ( ^.^ )"
    elif [ $HAPPINESS -gt 30 ]; then
        echo "  ( o.o )"
    else
        echo "  ( T.T )"
    fi
}

show_stats() {
    clear
    echo "=== $PET_NAME ==="
    show_pet
    echo -e "${GREEN}Health: $HEALTH/100${NC}"
    echo -e "${YELLOW}Hunger: $HUNGER/100${NC}"
    echo -e "${RED}Happiness: $HAPPINESS/100${NC}"
    echo
}

feed_pet() {
    HUNGER=$((HUNGER - 30))
    HEALTH=$((HEALTH + 10))
    echo "$PET_NAME enjoyed the food!"
    [ $HUNGER -lt 0 ] && HUNGER=0
    [ $HEALTH -gt 100 ] && HEALTH=100
}

play_with_pet() {
    HAPPINESS=$((HAPPINESS + 25))
    HUNGER=$((HUNGER + 10))
    echo "$PET_NAME had fun playing!"
    [ $HAPPINESS -gt 100 ] && HAPPINESS=100
    [ $HUNGER -gt 100 ] && HUNGER=100
}

pet_sleep() {
    HAPPINESS=$((HAPPINESS + 15))
    HEALTH=$((HEALTH + 15))
    echo "$PET_NAME feels refreshed!"
    [ $HAPPINESS -gt 100 ] && HAPPINESS=100
    [ $HEALTH -gt 100 ] && HEALTH=100
}

time_effects() {
    HUNGER=$((HUNGER + 5))
    HAPPINESS=$((HAPPINESS - 3))
    
    if [ $HUNGER -ge 80 ]; then
        HEALTH=$((HEALTH - 10))
    fi
    
    if [ $HEALTH -le 0 ]; then
        echo -e "${RED}$PET_NAME has died! Game Over!${NC}"
        exit 0
    fi
}

# Initialize game
clear
echo " Virtual Pet Game"
read -p "Name your pet: " PET_NAME
[ -z "$PET_NAME" ] && PET_NAME="Buddy"

# Main game loop
while true; do
    show_stats
    echo "1) Feed  2) Play  3) Sleep  4) Quit"
    read -p "Action: " choice
    
    case $choice in
        1) feed_pet ;;
        2) play_with_pet ;;
        3) pet_sleep ;;
        4) echo "Goodbye!"; exit 0 ;;
        *) echo "Invalid choice!" ;;
    esac
    
    time_effects
    sleep 1
done
