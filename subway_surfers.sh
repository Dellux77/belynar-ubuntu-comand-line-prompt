#!/bin/bash

# Game settings
WIDTH=60
HEIGHT=20
PLAYER_WIDTH=3
MAX_OBSTACLES=5
TRAIN_LENGTH=8
GRAVITY=0.2
JUMP_FORCE=-2
MIN_SPEED=1
MAX_SPEED=5

# Game state
player_x=10
player_y=$((HEIGHT-3))
player_dy=0
obstacles=()
trains=()
coins=()
score=0
game_over=0
game_speed=1
last_obstacle_time=0
last_coin_time=0

# Terminal setup
trap 'cleanup' EXIT
cleanup() {
    stty echo
    tput cnorm
    clear
    echo "Game over! Final score: $score"
    exit 0
}

init_game() {
    clear
    stty -echo
    tput civis
}

draw_player() {
    local py=$1
    tput cup $py $player_x
    printf "\e[43m%.0s \e[0m" {1..3}
    tput cup $((py+1)) $player_x
    printf "\e[43m%.0s \e[0m" {1..3}
}

draw_entities() {
    # Draw obstacles and trains (red)
    for entity in "${obstacles[@]}" "${trains[@]}"; do
        IFS=',' read -r x y w h <<< "$entity"
        for ((i=y; i<y+h; i++)); do
            tput cup $i $x
            printf "\e[41m%.0s \e[0m" $(seq 1 $w)
        done
    done

    # Draw coins (yellow ¢)
    for coin in "${coins[@]}"; do
        IFS=',' read -r x y w h <<< "$coin"
        tput cup $y $x
        echo -en "\e[33m¢\e[0m"
    done
}

generate_entities() {
    local current_time=$((SECONDS * 1000))
    
    # Generate obstacles
    if (( ${#obstacles[@]} < MAX_OBSTACLES && 
         current_time - last_obstacle_time > 500 )); then
        if (( RANDOM % 3 == 0 )); then
            obstacles+=("$((WIDTH-1)),$((HEIGHT-2)),2,2")
            last_obstacle_time=$current_time
        fi
    fi

    # Generate trains
    if (( current_time - last_obstacle_time > 2000 && RANDOM % 50 == 0 )); then
        local train_y=$(( (RANDOM % 2) ? HEIGHT-4 : HEIGHT-2 ))
        for ((i=0; i<TRAIN_LENGTH; i++)); do
            trains+=("$((WIDTH + (i * 3))),${train_y},3,2")
        done
        last_obstacle_time=$current_time
    fi

    # Generate coins
    if (( current_time - last_coin_time > 300 && RANDOM % 5 == 0 )); then
        coins+=("$((WIDTH-1)),$(( (RANDOM % (HEIGHT-5)) + 2 )),1,1")
        last_coin_time=$current_time
    fi
}

check_collisions() {
    # Player bounding box
    local px1=$player_x
    local px2=$((player_x+PLAYER_WIDTH))
    local py1=$player_y
    local py2=$((player_y+2))

    # Check obstacles and trains
    for entity in "${obstacles[@]}" "${trains[@]}"; do
        IFS=',' read -r x y w h <<< "$entity"
        if (( px2 > x && px1 < x+w && py2 > y && py1 < y+h )); then
            game_over=1
            return
        fi
    done

    # Check coins
    for i in "${!coins[@]}"; do
        IFS=',' read -r x y w h <<< "${coins[i]}"
        if (( px2 > x && px1 < x+w && py2 > y && py1 < y+h )); then
            unset "coins[i]"
            ((score+=10))
        fi
    done
    coins=("${coins[@]}") # Reindex array
}

update_game() {
    # Apply physics
    player_dy=$(awk "BEGIN {print $player_dy + $GRAVITY}")
    player_y=$(awk "BEGIN {print int($player_y + $player_dy + 0.5)}")

    # Keep player in bounds
    (( player_y < 1 )) && player_y=1
    if (( player_y > HEIGHT-3 )); then
        player_y=$((HEIGHT-3))
        player_dy=0
    fi

    # Move entities left
    move_entities() {
        local -n arr=$1
        for i in "${!arr[@]}"; do
            IFS=',' read -r x y w h <<< "${arr[i]}"
            x=$((x - game_speed))
            if (( x < -w )); then
                unset "arr[i]"
                ((score++))
            else
                arr[i]="${x},${y},${w},${h}"
            fi
        done
        arr=("${arr[@]}") # Reindex
    }

    move_entities obstacles
    move_entities trains
    move_entities coins

    generate_entities
    check_collisions

    # Adjust difficulty
    if (( score > 0 && score % 100 == 0 )); then
        game_speed=$(awk -v s="$game_speed" -v m="$MAX_SPEED" \
                     'BEGIN {printf "%.1f", (s < m) ? s + 0.1 : s}')
    fi
}

draw_game() {
    clear
    printf "Score: %-5d Speed: %.1fx\n" "$score" "$game_speed"
    echo "Controls: Space to jump, Q to quit"
    
    # Draw ground
    tput cup $((HEIGHT-1)) 0
    printf '═%.0s' $(seq 1 $WIDTH)
    
    draw_player "$player_y"
    draw_entities
}

handle_input() {
    local key
    while read -rsn1 -t 0.001 key; do
        case "$key" in
            " ") (( player_y >= HEIGHT-3 )) && player_dy=$JUMP_FORCE ;;
            q) game_over=1 ;;
        esac
    done
}

# Main game loop
init_game
while (( game_over == 0 )); do
    handle_input
    update_game
    draw_game
    sleep 0.05
done

cleanup
