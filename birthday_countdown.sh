#!/bin/bash

# Optimized Birthday Countdown - Date math and conditionals
# Calculates days until birthday with advanced date operations

# Colors
G='\033[0;32m' R='\033[0;31m' Y='\033[1;33m' C='\033[0;36m' B='\033[1m' M='\033[0;35m' NC='\033[0m'

# Date validation
validate_date() {
    local input=$1
    case $input in
        [0-9][0-9][0-9][0-9]-[0-1][0-9]-[0-3][0-9])
            date -d "$input" &>/dev/null
            ;;
        [0-1][0-9]/[0-3][0-9]/[0-9][0-9][0-9][0-9])
            date -d "${input:6:4}-${input:0:2}-${input:3:2}" &>/dev/null
            ;;
        [0-1][0-9]-[0-3][0-9])
            local year=$(date +%Y)
            date -d "$year-$input" &>/dev/null
            ;;
        *)
            return 1
            ;;
    esac
}

# Normalize date input
normalize_date() {
    local input=$1
    case $input in
        [0-9][0-9][0-9][0-9]-[0-1][0-9]-[0-3][0-9])
            echo "$input"
            ;;
        [0-1][0-9]/[0-3][0-9]/[0-9][0-9][0-9][0-9])
            echo "${input:6:4}-${input:0:2}-${input:3:2}"
            ;;
        [0-1][0-9]-[0-3][0-9])
            echo "$(date +%Y)-$input"
            ;;
        *)
            return 1
            ;;
    esac
}

# Calculate age
calculate_age() {
    local birth_date=$1
    local current_date=${2:-$(date +%Y-%m-%d)}
    
    local birth_year=${birth_date:0:4}
    local birth_month=${birth_date:5:2}
    local birth_day=${birth_date:8:2}
    
    local current_year=${current_date:0:4}
    local current_month=${current_date:5:2}
    local current_day=${current_date:8:2}
    
    local age=$((current_year - birth_year))
    
    # Check if birthday has passed this year
    if [[ $current_month -lt $birth_month ]] || 
       [[ $current_month -eq $birth_month && $current_day -lt $birth_day ]]; then
        ((age--))
    fi
    
    echo $age
}

# Calculate days until birthday
days_until_birthday() {
    local birth_date=$1
    local current_date=$(date +%Y-%m-%d)
    local current_epoch=$(date -d "$current_date" +%s)
    
    local birth_month=${birth_date:5:2}
    local birth_day=${birth_date:8:2}
    local current_year=${current_date:0:4}
    
    # This year's birthday
    local this_year_birthday="$current_year-$birth_month-$birth_day"
    local birthday_epoch=$(date -d "$this_year_birthday" +%s)
    
    # If birthday already passed this year, use next year
    if [[ $birthday_epoch -lt $current_epoch ]]; then
        this_year_birthday="$((current_year + 1))-$birth_month-$birth_day"
        birthday_epoch=$(date -d "$this_year_birthday" +%s)
    fi
    
    local days_diff=$(( (birthday_epoch - current_epoch) / 86400 ))
    echo "$days_diff:$this_year_birthday"
}

# Zodiac sign calculation
get_zodiac() {
    local date=$1
    local month=${date:5:2}
    local day=${date:8:2}
    
    case $month in
        01) [[ $day -le 19 ]] && echo "Capricorn" || echo "Aquarius" ;;
        02) [[ $day -le 18 ]] && echo "Aquarius" || echo "Pisces" ;;
        03) [[ $day -le 20 ]] && echo "Pisces" || echo "Aries" ;;
        04) [[ $day -le 19 ]] && echo "Aries" || echo "Taurus" ;;
        05) [[ $day -le 20 ]] && echo "Taurus" || echo "Gemini" ;;
        06) [[ $day -le 20 ]] && echo "Gemini" || echo "Cancer" ;;
        07) [[ $day -le 22 ]] && echo "Cancer" || echo "Leo" ;;
        08) [[ $day -le 22 ]] && echo "Leo" || echo "Virgo" ;;
        09) [[ $day -le 22 ]] && echo "Virgo" || echo "Libra" ;;
        10) [[ $day -le 22 ]] && echo "Libra" || echo "Scorpio" ;;
        11) [[ $day -le 21 ]] && echo "Scorpio" || echo "Sagittarius" ;;
        12) [[ $day -le 21 ]] && echo "Sagittarius" || echo "Capricorn" ;;
    esac
}

# Day of week for birthday
get_day_of_week() {
    local date=$1
    date -d "$date" +%A
}

# Format time remaining
format_countdown() {
    local days=$1
    
    case $days in
        0)
            echo -e "${G}${B}TODAY IS YOUR BIRTHDAY!${NC}"
            return
            ;;
        1)
            echo -e "${Y}${B}Tomorrow is your birthday!${NC}"
            ;;
        [2-7])
            echo -e "${Y}${days} days until your birthday${NC}"
            ;;
        [8-30])
            local weeks=$((days / 7))
            local remaining_days=$((days % 7))
            if [[ $remaining_days -eq 0 ]]; then
                echo -e "${C}${weeks} week(s) until your birthday${NC}"
            else
                echo -e "${C}${weeks} week(s) and ${remaining_days} day(s) until your birthday${NC}"
            fi
            ;;
        *)
            local months=$((days / 30))
            local remaining_days=$((days % 30))
            if [[ $remaining_days -eq 0 ]]; then
                echo -e "${M}${months} month(s) until your birthday${NC}"
            else
                echo -e "${M}${months} month(s) and ${remaining_days} day(s) until your birthday${NC}"
            fi
            ;;
    esac
}

# Birthday analysis
analyze_birthday() {
    local birth_date=$1
    local result=$(days_until_birthday "$birth_date")
    local days=${result%:*}
    local next_birthday=${result#*:}
    
    local age=$(calculate_age "$birth_date")
    local next_age=$((age + 1))
    local zodiac=$(get_zodiac "$birth_date")
    local day_of_week=$(get_day_of_week "$next_birthday")
    
    echo -e "${B}${C}BIRTHDAY ANALYSIS${NC}"
    echo "================================"
    echo -e "Birth Date: ${B}$(date -d "$birth_date" '+%B %d, %Y')${NC}"
    echo -e "Current Age: ${G}${age} years old${NC}"
    echo -e "Next Birthday: ${B}$(date -d "$next_birthday" '+%B %d, %Y') (${day_of_week})${NC}"
    echo -e "Turning: ${G}${next_age} years old${NC}"
    echo -e "Zodiac Sign: ${Y}${zodiac}${NC}"
    echo
    
    format_countdown $days
    
    # Additional insights
    case $days in
        0)
            echo -e "\n${G}Happy Birthday! Time to celebrate!${NC}"
            ;;
        1)
            echo -e "\n${Y}Get ready to party! Almost there!${NC}"
            ;;
        [2-7])
            echo -e "\n${Y}Your birthday is this week!${NC}"
            ;;
        [8-30])
            echo -e "\n${C}Your birthday is coming up this month!${NC}"
            ;;
        [100-200])
            echo -e "\n${M}Still have some time to plan something special!${NC}"
            ;;
        [300-365])
            echo -e "\n${M}Your birthday is later this year${NC}"
            ;;
    esac
}

# Multiple birthday tracking
track_multiple() {
    local -A birthdays
    local count=0
    
    echo -e "${B}${C}Multiple Birthday Tracker${NC}"
    echo "Enter birthdays (empty line to finish):"
    
    while true; do
        read -p "Name: " name
        [[ -z $name ]] && break
        
        read -p "Birthday (YYYY-MM-DD or MM-DD): " birthday
        
        if validate_date "$birthday"; then
            local normalized=$(normalize_date "$birthday")
            birthdays["$name"]="$normalized"
            ((count++))
            echo -e "${G}Added $name${NC}"
        else
            echo -e "${R}Invalid date format${NC}"
        fi
    done
    
    if [[ $count -eq 0 ]]; then
        echo "No valid birthdays entered"
        return
    fi
    
    echo -e "\n${B}UPCOMING BIRTHDAYS${NC}"
    echo "=========================="
    
    # Create sorted list by days until birthday
    local -a sorted_list
    for name in "${!birthdays[@]}"; do
        local result=$(days_until_birthday "${birthdays[$name]}")
        local days=${result%:*}
        sorted_list+=("$days:$name:${birthdays[$name]}")
    done
    
    # Sort by days (simple bubble sort for small datasets)
    for ((i=0; i<${#sorted_list[@]}-1; i++)); do
        for ((j=0; j<${#sorted_list[@]}-i-1; j++)); do
            local days1=${sorted_list[j]%%:*}
            local days2=${sorted_list[j+1]%%:*}
            if [[ $days1 -gt $days2 ]]; then
                local temp=${sorted_list[j]}
                sorted_list[j]=${sorted_list[j+1]}
                sorted_list[j+1]=$temp
            fi
        done
    done
    
    # Display sorted results
    for entry in "${sorted_list[@]}"; do
        IFS=':' read -r days name birth_date <<< "$entry"
        local age=$(calculate_age "$birth_date")
        local next_age=$((age + 1))
        
        printf "%-15s " "$name"
        case $days in
            0) echo -e "${G}${B}TODAY!${NC} (turning $next_age)" ;;
            1) echo -e "${Y}${B}Tomorrow${NC} (turning $next_age)" ;;
            *) echo -e "${C}$days days${NC} (turning $next_age)" ;;
        esac
    done
}

# Command line interface
process_args() {
    case $# in
        0)
            echo -e "${C}Birthday Countdown Calculator${NC}"
            echo "Modes:"
            echo "1. Single birthday"
            echo "2. Multiple birthdays"
            read -p "Choice (1-2): " mode
            
            case $mode in
                1)
                    read -p "Enter your birthday (YYYY-MM-DD or MM-DD): " birthday
                    if validate_date "$birthday"; then
                        local normalized=$(normalize_date "$birthday")
                        echo
                        analyze_birthday "$normalized"
                    else
                        echo -e "${R}Invalid date format${NC}"
                        exit 1
                    fi
                    ;;
                2)
                    track_multiple
                    ;;
                *)
                    echo -e "${R}Invalid choice${NC}"
                    exit 1
                    ;;
            esac
            ;;
        1)
            if validate_date "$1"; then
                local normalized=$(normalize_date "$1")
                analyze_birthday "$normalized"
            else
                echo -e "${R}Invalid date format${NC}" >&2
                exit 1
            fi
            ;;
        *)
            echo "Usage: $0 [BIRTHDAY]"
            echo "Formats: YYYY-MM-DD, MM/DD/YYYY, MM-DD"
            echo "Example: $0 1990-05-15"
            exit 1
            ;;
    esac
}

# Days since birth calculator
days_lived() {
    local birth_date=$1
    local current_date=$(date +%Y-%m-%d)
    local birth_epoch=$(date -d "$birth_date" +%s)
    local current_epoch=$(date -d "$current_date" +%s)
    
    local days_lived=$(( (current_epoch - birth_epoch) / 86400 ))
    
    echo -e "\n${B}LIFE STATISTICS${NC}"
    echo "====================="
    echo -e "Days lived: ${G}${days_lived}${NC}"
    echo -e "Weeks lived: ${G}$((days_lived / 7))${NC}"
    echo -e "Months lived: ${G}$((days_lived / 30))${NC}"
    echo -e "Years lived: ${G}$(calculate_age "$birth_date")${NC}"
}

# Enhanced analysis with life stats
enhanced_analysis() {
    local birth_date=$1
    analyze_birthday "$birth_date"
    days_lived "$birth_date"
}

# Main function
main() {
    case $1 in
        -h|--help)
            echo "Birthday Countdown Calculator"
            echo "Usage: $0 [OPTIONS] [BIRTHDAY]"
            echo
            echo "OPTIONS:"
            echo "  -m, --multiple    Track multiple birthdays"
            echo "  -e, --enhanced    Enhanced analysis with life stats"
            echo "  -h, --help        Show help"
            echo
            echo "Date formats: YYYY-MM-DD, MM/DD/YYYY, MM-DD"
            ;;
        -m|--multiple)
            track_multiple
            ;;
        -e|--enhanced)
            if [[ -n $2 ]] && validate_date "$2"; then
                local normalized=$(normalize_date "$2")
                enhanced_analysis "$normalized"
            else
                echo -e "${R}Please provide a valid birth date${NC}"
                exit 1
            fi
            ;;
        *)
            process_args "$@"
            ;;
    esac
}

main "$@"
