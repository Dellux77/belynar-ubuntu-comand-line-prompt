#!/bin/bash

# Optimized Multiplication Table Generator
# Demonstrates loops and arithmetic operations

# Colors
G='\033[0;32m' R='\033[0;31m' Y='\033[1;33m' C='\033[0;36m' B='\033[1m' NC='\033[0m'

# Input validation
validate_number() {
    case $1 in
        ''|*[!0-9]*) return 1 ;;
        *) [ $1 -gt 0 ] && [ $1 -le 999 ] ;;
    esac
}

validate_range() {
    case $1 in
        ''|*[!0-9]*) return 1 ;;
        *) [ $1 -gt 0 ] && [ $1 -le 50 ] ;;
    esac
}

# Single table generation
single_table() {
    local num=$1 range=${2:-12}
    
    echo -e "${B}${C}Multiplication Table for $num${NC}"
    echo "$(printf '=%.0s' $(seq 1 $((${#num} + 25))))"
    
    for ((i=1; i<=range; i++)); do
        local result=$((num * i))
        printf "${Y}%2d${NC} x ${G}%2d${NC} = ${B}%3d${NC}\n" $num $i $result
    done
}

# Multiple tables generation
multiple_tables() {
    local start=$1 end=$2 range=${3:-12}
    
    for ((num=start; num<=end; num++)); do
        single_table $num $range
        [ $num -lt $end ] && echo
    done
}

# Grid table generation
grid_table() {
    local size=$1
    
    echo -e "${B}${C}${size}x${size} Multiplication Grid${NC}"
    
    # Header row
    printf "     "
    for ((j=1; j<=size; j++)); do
        printf "${Y}%4d${NC}" $j
    done
    echo
    
    # Separator
    printf "     "
    for ((j=1; j<=size; j++)); do
        printf "----"
    done
    echo
    
    # Data rows
    for ((i=1; i<=size; i++)); do
        printf "${Y}%2d${NC} | " $i
        for ((j=1; j<=size; j++)); do
            local result=$((i * j))
            case $result in
                [1-9]) printf "   ${G}%d${NC}" $result ;;
                [1-9][0-9]) printf "  ${G}%d${NC}" $result ;;
                *) printf " ${G}%3d${NC}" $result ;;
            esac
        done
        echo
    done
}

# Compact horizontal table
horizontal_table() {
    local num=$1 range=${2:-12}
    
    echo -e "${B}${C}Table for $num:${NC}"
    
    # Numbers row
    printf "n:  "
    for ((i=1; i<=range; i++)); do
        printf "${Y}%4d${NC}" $i
    done
    echo
    
    # Results row
    printf "${num}n: "
    for ((i=1; i<=range; i++)); do
        printf "${G}%4d${NC}" $((num * i))
    done
    echo
}

# Interactive mode
interactive_mode() {
    while true; do
        echo -e "\n${C}Multiplication Table Generator${NC}"
        echo "1. Single table"
        echo "2. Multiple tables"  
        echo "3. Grid table"
        echo "4. Horizontal table"
        echo "5. Exit"
        
        read -p "Choice (1-5): " choice
        
        case $choice in
            1)
                read -p "Enter number (1-999): " num
                if validate_number "$num"; then
                    read -p "Range (1-50) [12]: " range
                    validate_range "$range" || range=12
                    echo; single_table $num $range
                else
                    echo -e "${R}Invalid number${NC}"
                fi
                ;;
            2)
                read -p "Start number: " start
                read -p "End number: " end
                if validate_number "$start" && validate_number "$end" && [ $start -le $end ]; then
                    read -p "Range [12]: " range
                    validate_range "$range" || range=12
                    echo; multiple_tables $start $end $range
                else
                    echo -e "${R}Invalid range${NC}"
                fi
                ;;
            3)
                read -p "Grid size (1-20): " size
                if validate_range "$size" && [ $size -le 20 ]; then
                    echo; grid_table $size
                else
                    echo -e "${R}Invalid size${NC}"
                fi
                ;;
            4)
                read -p "Enter number: " num
                if validate_number "$num"; then
                    read -p "Range [12]: " range
                    validate_range "$range" || range=12
                    echo; horizontal_table $num $range
                else
                    echo -e "${R}Invalid number${NC}"
                fi
                ;;
            5|q|quit|exit)
                echo "Goodbye!"
                exit 0
                ;;
            *)
                echo -e "${R}Invalid choice${NC}"
                ;;
        esac
        
        read -p "Press Enter to continue..."
    done
}

# Command line processing
process_args() {
    case $# in
        0) interactive_mode ;;
        1)
            if validate_number "$1"; then
                single_table $1
            else
                echo -e "${R}Error: Invalid number '$1'${NC}" >&2
                exit 1
            fi
            ;;
        2)
            if validate_number "$1" && validate_range "$2"; then
                single_table $1 $2
            else
                echo -e "${R}Error: Invalid arguments${NC}" >&2
                exit 1
            fi
            ;;
        3)
            case $1 in
                -g|--grid)
                    if validate_range "$2"; then
                        grid_table $2
                    else
                        echo -e "${R}Error: Invalid grid size${NC}" >&2
                        exit 1
                    fi
                    ;;
                -r|--range)
                    if validate_number "$2" && validate_number "$3"; then
                        multiple_tables $2 $3
                    else
                        echo -e "${R}Error: Invalid range${NC}" >&2
                        exit 1
                    fi
                    ;;
                *)
                    echo -e "${R}Error: Unknown option '$1'${NC}" >&2
                    show_usage
                    exit 1
                    ;;
            esac
            ;;
        4)
            if [[ $1 == "-r" || $1 == "--range" ]] && validate_number "$2" && validate_number "$3" && validate_range "$4"; then
                multiple_tables $2 $3 $4
            else
                echo -e "${R}Error: Invalid arguments${NC}" >&2
                exit 1
            fi
            ;;
        *)
            show_usage
            exit 1
            ;;
    esac
}

# Usage help
show_usage() {
    echo "Usage: $0 [OPTIONS] [NUMBER] [RANGE]"
    echo
    echo "OPTIONS:"
    echo "  -g, --grid SIZE        Generate SIZE x SIZE grid table"
    echo "  -r, --range START END  Generate tables from START to END"
    echo "  -h, --help             Show this help"
    echo
    echo "EXAMPLES:"
    echo "  $0                     Interactive mode"
    echo "  $0 5                   Table for 5 (1-12)"
    echo "  $0 7 15                Table for 7 (1-15)"
    echo "  $0 -g 10               10x10 grid table"
    echo "  $0 -r 5 8              Tables for 5,6,7,8"
    echo "  $0 -r 5 8 15           Tables for 5,6,7,8 (1-15)"
}

# Performance test mode
performance_test() {
    echo "Generating large multiplication tables..."
    
    # Time single large table
    start_time=$(date +%s.%N)
    single_table 999 50 > /dev/null
    end_time=$(date +%s.%N)
    single_time=$(echo "$end_time - $start_time" | bc 2>/dev/null || echo "0.001")
    
    # Time grid table
    start_time=$(date +%s.%N)
    grid_table 50 > /dev/null
    end_time=$(date +%s.%N)
    grid_time=$(echo "$end_time - $start_time" | bc 2>/dev/null || echo "0.001")
    
    echo "Performance Results:"
    echo "Single table (999x50): ${single_time}s"
    echo "Grid table (50x50): ${grid_time}s"
}

# Main function
main() {
    case $1 in
        -h|--help)
            show_usage
            ;;
        --test)
            performance_test
            ;;
        *)
            process_args "$@"
            ;;
    esac
}

main "$@"
