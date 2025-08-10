#!/bin/bash

# Optimized Animal Sound Quiz - Case statements and pattern matching

# Colors
G='\033[0;32m' R='\033[0;31m' Y='\033[1;33m' C='\033[0;36m' B='\033[1m' NC='\033[0m'

# Data structures
declare -A animal_sounds=(
    [cow]="moo" [dog]="bark" [cat]="meow" [pig]="oink" [sheep]="baa"
    [duck]="quack" [horse]="neigh" [rooster]="cock-a-doodle-doo" [owl]="hoot"
    [frog]="ribbit" [bee]="buzz" [snake]="hiss" [lion]="roar" [elephant]="trumpet" [monkey]="chatter"
)

declare -A hints=(
    [cow]="milk production" [dog]="man's best friend" [cat]="feline purr"
    [pig]="rhymes with boink" [sheep]="3 letters, woolly" [duck]="waterfowl, avoid"
    [horse]="communication neigh" [rooster]="farm wake-up call" [owl]="wise question"
    [frog]="pond amphibian" [bee]="busy wings" [snake]="warning sss"
    [lion]="king's roar" [elephant]="musical instrument" [monkey]="primate chatter"
)

# Game state
score=0 total=0 correct=0
animals=(${!animal_sounds[@]})

# Input normalization
normalize() {
    local input=$(echo "$1" | tr '[:upper:]' '[:lower:]' | tr -d '[:space:]')
    case $input in
        woof|arf|bowwow) echo "bark" ;;
        miau|miaow) echo "meow" ;;
        oinkoink) echo "oink" ;;
        bah|bleat) echo "baa" ;;
        cockadoodledoo|cock*doo*) echo "cock-a-doodle-doo" ;;
        ribbet) echo "ribbit" ;;
        buzzing|bzz) echo "buzz" ;;
        ssss) echo "hiss" ;;
        *ing) echo "${input%ing}" ;;
        *) echo "$input" ;;
    esac
}

# Validation
validate() {
    case $1 in
        moo|bark|meow|oink|baa|quack|neigh|cock-a-doodle-doo|hoot|ribbit|buzz|hiss|roar|trumpet|chatter) return 0 ;;
        *) return 1 ;;
    esac
}

# Quiz question
ask() {
    local animal=$1 correct_sound=${animal_sounds[$animal]} hint_used=false points=10
    
    echo -e "\n${Y}Q$((total+1)):${NC} What sound does a ${B}$animal${NC} make?"
    
    while true; do
        read -p "Answer: " input
        
        case $input in
            q|quit|exit) echo -e "\n${Y}Final Score: $score/$((total*10))${NC}"; exit ;;
            s|skip) echo -e "${Y}Skipped: $correct_sound${NC}"; return 1 ;;
            h|hint)
                if ! $hint_used; then
                    echo "Hint: ${hints[$animal]}"
                    hint_used=true points=5
                else
                    echo "Hint already used!"
                fi
                continue ;;
            "") echo "Enter a sound"; continue ;;
        esac
        
        local normalized=$(normalize "$input")
        
        if validate "$normalized"; then
            if [[ $normalized == $correct_sound ]]; then
                echo -e "${G}Correct! (+$points)${NC}"
                ((score+=points)) ((correct++))
                return 0
            else
                echo -e "${R}Wrong! Try again${NC}"
            fi
        else
            echo -e "${R}Invalid sound${NC}"
        fi
    done
}

# Shuffle array
shuffle() {
    local i tmp size=${#animals[@]}
    for ((i=size-1; i>0; i--)); do
        local j=$((RANDOM % (i+1)))
        tmp=${animals[i]}; animals[i]=${animals[j]}; animals[j]=$tmp
    done
}

# Performance rating
rate() {
    local pct=$((correct * 100 / total))
    case $pct in
        [9][0-9]|100) echo "${G}Outstanding!${NC}" ;;
        [8][0-9]) echo "${G}Excellent!${NC}" ;;
        [7][0-9]) echo "${Y}Good!${NC}" ;;
        [6][0-9]) echo "${Y}Fair${NC}" ;;
        *) echo "${R}Keep practicing${NC}" ;;
    esac
}

# Main
main() {
    clear
    echo -e "${B}${C}ANIMAL SOUND QUIZ${NC}"
    echo "Type sound, 'hint', 'skip', or 'quit'"
    
    read -p "Questions (1-15) [10]: " n
    case $n in [1-9]|1[0-5]) ;; *) n=10 ;; esac
    
    shuffle
    
    for ((i=0; i<n; i++)); do
        ((total++))
        ask "${animals[i]}"
    done
    
    echo -e "\n${B}RESULTS${NC}"
    echo "Score: $score/$((total*10)) | Correct: $correct/$total ($(rate))"
}

RANDOM=$$
main
