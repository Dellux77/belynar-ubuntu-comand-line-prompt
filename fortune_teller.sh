#!/bin/bash

# Fortune Teller Script - Predict the future with mystical powers!
# Uses arrays and random selection to generate fortunes

# Color codes for mystical atmosphere
PURPLE='\033[0;35m'
CYAN='\033[0;36m'
YELLOW='\033[1;33m'
GREEN='\033[0;32m'
RED='\033[0;31m'
BLUE='\033[0;34m'
BOLD='\033[1m'
NC='\033[0m' # No Color

# Fortune categories with arrays
love_fortunes=(
    "A mysterious stranger will capture your heart within the next moon cycle"
    "Your current relationship will bloom like spring flowers after a gentle rain"
    "Love letters from the past will resurface, bringing closure and new beginnings"
    "A chance encounter at a coffee shop will spark an unexpected romance"
    "Your soulmate is closer than you think - look within your circle of friends"
    "A long-distance connection will prove stronger than physical proximity"
    "Self-love will be your greatest romance this season"
)

career_fortunes=(
    "A golden opportunity will knock thrice - answer on the second knock"
    "Your creative talents will open doors you never knew existed"
    "A mentor will appear disguised as a challenger - embrace their lessons"
    "Financial abundance flows to you like a river after the spring thaw"
    "Your dream job awaits beyond a leap of faith you're hesitating to take"
    "Collaboration with an unlikely partner will yield extraordinary results"
    "Recognition for past efforts will arrive when you least expect it"
)

health_fortunes=(
    "Your body whispers wisdom - listen closely to what it needs"
    "A new form of exercise will bring joy and vitality to your life"
    "Healing energy surrounds you - trust in your natural recovery powers"
    "Balance in all things will be your path to wellness"
    "An old remedy will prove surprisingly effective for a current concern"
    "Your mental clarity will sharpen like a blade in the coming weeks"
    "Rest and reflection will restore what activity cannot fix"
)

travel_fortunes=(
    "A journey to water will wash away old worries and bring new perspectives"
    "Mountains are calling your name - their peaks hold answers you seek"
    "An unexpected detour will lead to the most memorable adventure"
    "Foreign flavors will awaken dormant passions within your soul"
    "A return to childhood places will unlock forgotten dreams"
    "The path less traveled will reveal hidden treasures"
    "Your next destination chooses you, not the other way around"
)

general_fortunes=(
    "The universe conspires in your favor - trust the synchronicities"
    "What seems like an ending is actually a beautiful new beginning"
    "Your intuition grows stronger with each passing day - follow its guidance"
    "A secret will be revealed that changes everything for the better"
    "The number 7 holds special significance in your immediate future"
    "An old friend will bring news that shifts your perspective entirely"
    "Your greatest fear will transform into your greatest strength"
    "The stars align to grant a wish you made long ago"
)

# Function to display mystical header
show_header() {
    clear
    echo -e "${PURPLE}${BOLD}"
    echo "    ✨ ═══════════════════════════════════════════ ✨"
    echo "           🔮 THE MYSTICAL FORTUNE TELLER 🔮"
    echo "    ✨ ═══════════════════════════════════════════ ✨"
    echo -e "${NC}"
    echo -e "${CYAN}    Peer into the cosmic veil and glimpse your destiny...${NC}"
    echo ""
}

# Function to get random element from array
get_random_fortune() {
    local -n arr=$1
    local size=${#arr[@]}
    local index=$((RANDOM % size))
    echo "${arr[$index]}"
}

# Function to display fortune with mystical formatting
display_fortune() {
    local category=$1
    local fortune=$2
    local color=$3
    
    echo -e "${BOLD}${YELLOW}🌟 ${category} FORTUNE 🌟${NC}"
    echo -e "${color}┌─────────────────────────────────────────────────────────────┐${NC}"
    echo -e "${color}│${NC} ${fortune} ${color}│${NC}"
    echo -e "${color}└─────────────────────────────────────────────────────────────┘${NC}"
    echo ""
}

# Function to show loading animation
mystical_loading() {
    local symbols=("⚡" "✨" "🌙" "⭐" "🔮" "🌟")
    echo -ne "${PURPLE}Consulting the cosmic forces"
    for i in {1..8}; do
        echo -ne " ${symbols[$((RANDOM % 6))]}"
        sleep 0.3
    done
    echo -e "${NC}"
    sleep 0.5
}

# Main fortune telling function
tell_fortune() {
    show_header
    
    echo -e "${CYAN}Choose your path to enlightenment:${NC}"
    echo -e "${GREEN}1.${NC} 💖 Love & Relationships"
    echo -e "${GREEN}2.${NC} 💼 Career & Finance"
    echo -e "${GREEN}3.${NC} 🏥 Health & Wellness"
    echo -e "${GREEN}4.${NC} ✈️  Travel & Adventure"
    echo -e "${GREEN}5.${NC} 🌟 General Life Guidance"
    echo -e "${GREEN}6.${NC} 🎲 Surprise Me! (Random Category)"
    echo -e "${GREEN}7.${NC} 🔮 Complete Reading (All Categories)"
    echo -e "${GREEN}8.${NC} 👋 Exit the Mystical Realm"
    echo ""
    
    while true; do
        echo -ne "${YELLOW}Enter your choice (1-8): ${NC}"
        read choice
        
        case $choice in
            1)
                mystical_loading
                fortune=$(get_random_fortune love_fortunes)
                display_fortune "LOVE" "$fortune" "${RED}"
                ;;
            2)
                mystical_loading
                fortune=$(get_random_fortune career_fortunes)
                display_fortune "CAREER" "$fortune" "${GREEN}"
                ;;
            3)
                mystical_loading
                fortune=$(get_random_fortune health_fortunes)
                display_fortune "HEALTH" "$fortune" "${BLUE}"
                ;;
            4)
                mystical_loading
                fortune=$(get_random_fortune travel_fortunes)
                display_fortune "TRAVEL" "$fortune" "${CYAN}"
                ;;
            5)
                mystical_loading
                fortune=$(get_random_fortune general_fortunes)
                display_fortune "GENERAL" "$fortune" "${PURPLE}"
                ;;
            6)
                # Random category selection
                categories=("love_fortunes" "career_fortunes" "health_fortunes" "travel_fortunes" "general_fortunes")
                colors=("${RED}" "${GREEN}" "${BLUE}" "${CYAN}" "${PURPLE}")
                names=("LOVE" "CAREER" "HEALTH" "TRAVEL" "GENERAL")
                
                mystical_loading
                random_cat=$((RANDOM % 5))
                fortune=$(get_random_fortune ${categories[$random_cat]})
                display_fortune "${names[$random_cat]}" "$fortune" "${colors[$random_cat]}"
                ;;
            7)
                # Complete reading
                echo -e "${BOLD}${YELLOW}🌟 COMPLETE MYSTICAL READING 🌟${NC}"
                echo -e "${CYAN}The cosmic energies reveal your full destiny...${NC}"
                echo ""
                
                mystical_loading
                
                fortune=$(get_random_fortune love_fortunes)
                display_fortune "LOVE" "$fortune" "${RED}"
                
                fortune=$(get_random_fortune career_fortunes)
                display_fortune "CAREER" "$fortune" "${GREEN}"
                
                fortune=$(get_random_fortune health_fortunes)
                display_fortune "HEALTH" "$fortune" "${BLUE}"
                
                fortune=$(get_random_fortune travel_fortunes)
                display_fortune "TRAVEL" "$fortune" "${CYAN}"
                
                fortune=$(get_random_fortune general_fortunes)
                display_fortune "GENERAL" "$fortune" "${PURPLE}"
                
                echo -e "${BOLD}${YELLOW}✨ Your reading is complete. May these insights guide your path! ✨${NC}"
                ;;
            8)
                echo -e "${PURPLE}${BOLD}"
                echo "    🌙 Thank you for visiting the Mystical Fortune Teller 🌙"
                echo "       May your future be bright and full of wonder!"
                echo "    ✨ ═════════════════════════════════════════ ✨"
                echo -e "${NC}"
                exit 0
                ;;
            *)
                echo -e "${RED}The spirits don't recognize that choice. Please enter 1-8.${NC}"
                continue
                ;;
        esac
        
        echo -e "${CYAN}Would you like another reading? (y/n): ${NC}"
        read again
        if [[ $again != "y" && $again != "Y" && $again != "yes" && $again != "Yes" ]]; then
            echo -e "${PURPLE}${BOLD}"
            echo "    🌙 Thank you for visiting the Mystical Fortune Teller 🌙"
            echo "       May your future be bright and full of wonder!"
            echo "    ✨ ═════════════════════════════════════════ ✨"
            echo -e "${NC}"
            break
        fi
        
        show_header
        echo -e "${CYAN}Choose your path to enlightenment:${NC}"
        echo -e "${GREEN}1.${NC} 💖 Love & Relationships"
        echo -e "${GREEN}2.${NC} 💼 Career & Finance"
        echo -e "${GREEN}3.${NC} 🏥 Health & Wellness"
        echo -e "${GREEN}4.${NC} ✈️  Travel & Adventure"
        echo -e "${GREEN}5.${NC} 🌟 General Life Guidance"
        echo -e "${GREEN}6.${NC} 🎲 Surprise Me! (Random Category)"
        echo -e "${GREEN}7.${NC} 🔮 Complete Reading (All Categories)"
        echo -e "${GREEN}8.${NC} 👋 Exit the Mystical Realm"
        echo ""
    done
}

# Initialize random seed
RANDOM=$$$(date +%s)

# Start the fortune teller
tell_fortune
