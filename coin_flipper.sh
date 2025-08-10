#!/bin/bash

# Optimized Coin Flipper - While loops and counters

# Colors and globals
G='\033[0;32m' R='\033[0;31m' Y='\033[1;33m' C='\033[0;36m' B='\033[1m' NC='\033[0m'
h=0 t=0 n=0

# Core functions
flip() { echo $((RANDOM % 2)); }
show() { [[ $1 -eq 0 ]] && echo -e "${Y}H${NC}" || echo -e "${C}T${NC}"; }
count() { ((n++)); [[ $1 -eq 0 ]] && ((h++)) || ((t++)); }

# Statistics
stats() {
    [[ $n -eq 0 ]] && return
    echo -e "\n${B}Stats: $n flips${NC}"
    echo "H:$h($(( h*100/n ))%) T:$t($(( t*100/n ))%)"
    local b=$(( (h-t)*100/n ))
    case ${b#-} in
        [0-5]) echo -e "${G}Balanced${NC}" ;;
        *) echo -e "${Y}Bias: ${b}%${NC}" ;;
    esac
}

# Single flip mode
single() {
    while read -p "Press Enter (q=quit): " x && [[ $x != q ]]; do
        local r=$(flip)
        count $r
        echo "Flip $n: $(show $r)"
    done
    stats
}

# Multiple flips
multi() {
    local i=0
    echo "Flipping $1 coins..."
    
    while ((i++ < $1)); do
        local r=$(flip)
        count $r
        [[ $1 -le 20 ]] && echo "Flip $i: $(show $r)"
        [[ $1 -gt 20 && $((i % 100)) -eq 0 ]] && echo -ne "\r$i/$1"
    done
    
    [[ $1 -gt 20 ]] && echo -e "\rDone: $1 flips"
    stats
}

# Streak finder
streaks() {
    local target=$1 streak=0 last=-1 max=0 i=0
    echo "Finding $target+ streaks in 1000 flips..."
    
    while ((i++ < 1000)); do
        local r=$(flip)
        count $r
        
        if [[ $r -eq $last ]]; then
            ((streak++))
        else
            [[ $streak -ge $target ]] && echo "Streak: $streak $(show $last) at flip $((i-streak))"
            [[ $streak -gt $max ]] && max=$streak
            streak=1
            last=$r
        fi
        
        [[ $((i % 200)) -eq 0 ]] && echo -ne "\r$i/1000"
    done
    
    echo -e "\rMax streak: $max"
    stats
}

# Competition mode
race() {
    local target=$1 hc=0 tc=0 i=0
    echo -e "Race to $target: ${Y}H${NC} vs ${C}T${NC}"
    
    while [[ $hc -lt $target && $tc -lt $target ]]; do
        local r=$(flip)
        count $r
        ((i++))
        
        if [[ $r -eq 0 ]]; then
            ((hc++))
            echo "Flip $i: H ($hc/$target)"
        else
            ((tc++))
            echo "Flip $i: T ($tc/$target)"
        fi
    done
    
    [[ $hc -eq $target ]] && echo -e "\n${Y}${B}HEADS WINS!${NC}" || echo -e "\n${C}${B}TAILS WINS!${NC}"
    stats
}

# Main menu
menu() {
    while true; do
        echo -e "\n${C}COIN FLIPPER${NC}"
        echo "1=Single 2=Multi 3=Streaks 4=Race 5=Reset 6=Exit"
        read -p "Choice: " c
        
        case $c in
            1) single ;;
            2) read -p "Count: " x; [[ $x =~ ^[0-9]+$ ]] && multi $x || echo "Invalid" ;;
            3) read -p "Min streak: " x; [[ $x =~ ^[0-9]+$ ]] && streaks $x || echo "Invalid" ;;
            4) read -p "Target: " x; [[ $x =~ ^[0-9]+$ ]] && race $x || echo "Invalid" ;;
            5) h=0 t=0 n=0; echo "Reset" ;;
            6|q) stats; exit ;;
            *) echo "Invalid" ;;
        esac
    done
}

# Command line processing
case ${1:-""} in
    -h) echo "Usage: $0 [count] | -s | -h" ;;
    -s) single ;;
    "") menu ;;
    *) [[ $1 =~ ^[0-9]+$ ]] && multi $1 || { echo "Invalid number" >&2; exit 1; } ;;
esac
