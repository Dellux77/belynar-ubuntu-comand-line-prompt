#!/bin/bash

# Optimized Text Adventure Game: "The Mysterious Mansion"

# Game Configuration
declare -A descriptions=(
    ["entrance"]="You stand in the grand entrance hall. Dusty portraits line the walls. Doors lead ${YELLOW}north${NC} to the library and ${YELLOW}east${NC} to the dining room."
    ["library"]="Floor-to-ceiling bookshelves fill this room. A ${YELLOW}red book${NC} stands out. Exits are ${YELLOW}south${NC} to entrance and ${YELLOW}west${NC} to study."
    ["dining"]="A long table set for a banquet, covered in cobwebs. You see a ${YELLOW}silver key${NC}. Exits: ${YELLOW}west${NC} to entrance, ${YELLOW}north${NC} to kitchen."
    ["kitchen"]="Pots and pans hang from the ceiling. A ${YELLOW}knife${NC} lies on the counter. Exits: ${YELLOW}south${NC} to dining room."
    ["study"]="A desk with a ${YELLOW}locked drawer${NC}. A note reads 'The combination is where knowledge is kept'. Exits: ${YELLOW}east${NC} to library."
    ["garden"]="Overgrown plants everywhere. A ${YELLOW}shovel${NC} leans against a tree. Exits: ${YELLOW}east${NC} back to entrance."
)

declare -A room_connections=(
    ["entrance:north"]="library"
    ["entrance:east"]="dining"
    ["entrance:west"]="garden"
    ["library:south"]="entrance"
    ["library:west"]="study"
    ["dining:west"]="entrance"
    ["dining:north"]="kitchen"
    ["kitchen:south"]="dining"
    ["study:east"]="library"
    ["garden:east"]="entrance"
)

declare -A room_items=(
    ["library"]="red book"
    ["dining"]="silver key"
    ["kitchen"]="knife"
    ["garden"]="shovel"
)

# Game State
current_room="entrance"
declare -a inventory=()
game_over=0
score=0
declare -a visited_rooms=("entrance")

# Color Codes
declare -A colors=(
    ["RED"]='\033[0;31m'
    ["GREEN"]='\033[0;32m'
    ["YELLOW"]='\033[1;33m'
    ["BLUE"]='\033[0;34m'
    ["NC"]='\033[0m'
)

# Initialize game
function init_game() {
    clear
    show_title
    describe_room
}

# Display ASCII title
function show_title() {
    echo -e "${colors[YELLOW]}"
    cat << "EOF"
 ███╗   ███╗██╗   ██╗███████╗████████╗███████╗██████╗ ██╗   ██╗███████╗
 ████╗ ████║╚██╗ ██╔╝██╔════╝╚══██╔══╝██╔════╝██╔══██╗██║   ██║██╔════╝
 ██╔████╔██║ ╚████╔╝ ███████╗   ██║   █████╗  ██████╔╝██║   ██║███████╗
 ██║╚██╔╝██║  ╚██╔╝  ╚════██║   ██║   ██╔══╝  ██╔══██╗██║   ██║╚════██║
 ██║ ╚═╝ ██║   ██║   ███████║   ██║   ███████╗██║  ██║╚██████╔╝███████║
 ╚═╝     ╚═╝   ╚═╝   ╚══════╝   ╚═╝   ╚══════╝╚═╝  ╚═╝ ╚═════╝ ╚══════╝
EOF
    echo -e "${colors[NC]}"
    echo -e "${colors[BLUE]}You wake up in front of a mysterious mansion. The door creaks open...${colors[NC]}"
}

# Describe current room
function describe_room() {
    local room_desc="${descriptions[$current_room]}"
    local item="${room_items[$current_room]}"
    
    echo -e "\n${colors[BLUE]}${room_desc}${colors[NC]}"
    
    # Show available items if not taken
    if [[ -n "$item" ]] && ! [[ " ${inventory[@]} " =~ " ${item} " ]]; then
        echo -e "${colors[YELLOW]}There's a $item here.${colors[NC]}"
    fi
}

# Process player commands
function process_command() {
    local cmd="$1"
    local arg1="$2"
    local arg2="$3"
    
    case "$cmd" in
        go|move|walk)    move_player "$arg1" ;;
        take|grab|get)   take_item "$arg1" "$arg2" ;;
        use)             use_item "$arg1" "$arg2" ;;
        look|examine)    look_at "$arg1" ;;
        inventory|i)     show_inventory ;;
        help|h)          show_help ;;
        quit|exit)       game_over=1 ;;
        *)               echo "I don't understand '$cmd'. Type 'help' for commands." ;;
    esac
}

# Handle player movement
function move_player() {
    local direction="$1"
    local connection_key="$current_room:$direction"
    local new_room="${room_connections[$connection_key]}"
    
    if [[ -n "$new_room" ]]; then
        current_room="$new_room"
        # Track visited rooms for score
        if ! [[ " ${visited_rooms[@]} " =~ " ${current_room} " ]]; then
            visited_rooms+=("$current_room")
            ((score += 5))
        fi
        describe_room
    else
        echo "You can't go that way!"
    fi
}

# Handle item collection
function take_item() {
    local item_name="$1 $2"
    item_name="${item_name# }" # Trim leading space if no second word
    
    # Check if item exists in current room and not in inventory
    if [[ "${room_items[$current_room]}" == "$item_name" ]] && \
       ! [[ " ${inventory[@]} " =~ " ${item_name} " ]]; then
        inventory+=("$item_name")
        echo "Taken!"
        
        # Special case for key
        [[ "$item_name" == "silver key" ]] && has_key=1
    else
        echo "I don't see that here."
    fi
}

# Handle item usage
function use_item() {
    local item_name="$1 $2"
    item_name="${item_name# }"
    
    if ! [[ " ${inventory[@]} " =~ " ${item_name} " ]]; then
        echo "You don't have that item."
        return
    fi

    case "$item_name" in
        "silver key")
            if [[ "$current_room" == "study" ]]; then
                echo -e "${colors[GREEN]}The drawer opens! You find a treasure map!${colors[NC]}"
                ((score += 50))
                game_over=1
            else
                echo "Nothing happens."
            fi
            ;;
        "red book")
            if [[ "$current_room" == "study" ]]; then
                echo -e "You flip through the book and find a note: 'The combination is 3-1-4'"
            else
                echo "Hmm, doesn't seem useful here."
            fi
            ;;
        *)
            echo "You can't use that here."
            ;;
    esac
}

# Display inventory
function show_inventory() {
    if (( ${#inventory[@]} == 0 )); then
        echo "You're not carrying anything."
    else
        echo -e "${colors[YELLOW]}Inventory:${colors[NC]}"
        printf -- '- %s\n' "${inventory[@]}"
    fi
}

# Show help
function show_help() {
    echo -e "${colors[YELLOW]}Available commands:${colors[NC]}"
    cat << EOF
go/move/walk [direction] - Move in specified direction
take/grab/get [item]     - Pick up an item
use [item]               - Use an item from inventory
look/examine [item]      - Closer look at something
inventory/i              - View your items
help/h                   - Show this help
quit/exit                - End the game
EOF
}

# End game screen
function end_game() {
    clear
    echo -e "${colors[YELLOW]}Game Over!${colors[NC]}"
    echo -e "Your score: ${colors[GREEN]}$score${colors[NC]}"
    echo -e "Rooms visited: ${#visited_rooms[@]}"
    echo -e "Items collected: ${#inventory[@]}"
    exit 0
}

# Main game loop
init_game

while (( game_over == 0 )); do
    echo
    read -p "What will you do? > " -r cmd arg1 arg2
    process_command "$cmd" "$arg1" "$arg2"
done

end_game
