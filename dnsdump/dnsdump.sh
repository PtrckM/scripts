#!/bin/bash

# DNSDumpster API Script - Final Working Version
# Usage: ./dnsdump.sh <domain>

# Colors for beautiful output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
PURPLE='\033[0;35m'
CYAN='\033[0;36m'
WHITE='\033[1;37m'
NC='\033[0m' # No Color
BOLD='\033[1m'

# API Configuration
API_KEY="replace with your API"
BASE_URL="https://api.dnsdumpster.com/domain"

# Function to print header
print_header() {
    echo -e "${CYAN}${BOLD}╔══════════════════════════════════════════════════════════════╗${NC}"
    echo -e "${CYAN}${BOLD}║                    DNSDumpster Domain Scanner                ║${NC}"
    echo -e "${CYAN}${BOLD}╚══════════════════════════════════════════════════════════════╝${NC}"
    echo
}

# Function to print section header
print_section() {
    local title="$1"
    echo -e "${PURPLE}${BOLD}┌─ $title ──────────────────────────────────────────${NC}"
    echo -e "${PURPLE}${BOLD}│${NC}"
}

# Function to print section footer
print_section_footer() {
    echo -e "${PURPLE}${BOLD}└────────────────────────────────────────────────────${NC}"
    echo
}

# Function to print record
print_record() {
    local type="$1"
    local value="$2"
    printf "${WHITE}${BOLD}%-12s${NC} %-50s\n" "$type:" "$value"
}

# Function to print table header
print_table_header() {
    local col1="$1"
    local col2="$2"
    local col3="$3"
    printf "${YELLOW}${BOLD}%-20s %-30s %-20s${NC}\n" "$col1" "$col2" "$col3"
    printf "${YELLOW}%-20s %-30s %-20s${NC}\n" "--------------------" "------------------------------" "--------------------"
}

# Function to print table row
print_table_row() {
    local col1="$1"
    local col2="$2"
    local col3="$3"
    printf "${WHITE}%-20s ${GREEN}%-30s ${CYAN}%-20s${NC}\n" "$col1" "$col2" "$col3"
}

# Check if domain is provided
if [ $# -eq 0 ]; then
    echo -e "${RED}Error: No domain provided${NC}"
    echo -e "${YELLOW}Usage: $0 <domain>${NC}"
    echo -e "${YELLOW}Example: $0 example.com${NC}"
    exit 1
fi

domain="$1"

# Validate domain format
if [[ ! $domain =~ ^[a-zA-Z0-9]([a-zA-Z0-9\-]{0,61}[a-zA-Z0-9])?(\.[a-zA-Z0-9]([a-zA-Z0-9\-]{0,61}[a-zA-Z0-9])?)*$ ]]; then
    echo -e "${RED}Error: Invalid domain format${NC}"
    exit 1
fi

echo -e "${BLUE}Fetching DNS data for ${BOLD}$domain${NC}..."
echo

# Fetch DNS data
response=$(curl -s -w "HTTPSTATUS:%{http_code}" -H "X-API-Key: $API_KEY" "$BASE_URL/$domain")
http_code=$(echo $response | tr -d '\n' | sed -e 's/.*HTTPSTATUS://')
json_data=$(echo $response | sed -e 's/HTTPSTATUS:.*//g')

if [ "$http_code" != "200" ]; then
    echo -e "${RED}Error: API request failed with HTTP code $http_code${NC}"
    echo -e "${RED}Response: $json_data${NC}"
    exit 1
fi

print_header

# Domain info
print_section "Domain Information"
print_record "Domain" "$domain"
print_record "Scan Time" "$(date '+%Y-%m-%d %H:%M:%S')"
print_section_footer

# Parse JSON using jq (if available) or fallback to basic parsing
if command -v jq &> /dev/null; then
    
    # A Records
    if echo "$json_data" | jq -e '.a' &> /dev/null; then
        print_section "A Records"
        print_table_header "Host" "IP Address" "Location"
        echo "$json_data" | jq -r '.a[] | "\(.host)\t\(.ips[0].ip // "N/A")\t\(.ips[0].country // "Unknown")"' 2>/dev/null | while IFS=$'\t' read -r host ip country; do
            print_table_row "$host" "$ip" "$country"
        done
        print_section_footer
    fi
    
    # MX Records
    if echo "$json_data" | jq -e '.mx' &> /dev/null; then
        print_section "MX Records"
        print_table_header "Host" "IP Address" "Provider"
        echo "$json_data" | jq -r '.mx[] | "\(.host)\t\(.ips[0].ip // "N/A")\t\(.ips[0].asn_name // "Unknown")"' 2>/dev/null | while IFS=$'\t' read -r host ip provider; do
            print_table_row "$host" "$ip" "$provider"
        done
        print_section_footer
    fi
    
    # NS Records
    if echo "$json_data" | jq -e '.ns' &> /dev/null; then
        print_section "NS Records"
        print_table_header "Host" "IP Address" "Provider"
        echo "$json_data" | jq -r '.ns[] | "\(.host)\t\(.ips[0].ip // "N/A")\t\(.ips[0].asn_name // "Unknown")"' 2>/dev/null | while IFS=$'\t' read -r host ip provider; do
            print_table_row "$host" "$ip" "$provider"
        done
        print_section_footer
    fi
    
    # TXT Records
    if echo "$json_data" | jq -e '.txt' &> /dev/null; then
        print_section "TXT Records"
        echo "$json_data" | jq -r '.txt[] | "\(.host)\t\(.value)"' 2>/dev/null | while IFS=$'\t' read -r host value; do
            print_record "Host" "$host"
            print_record "Value" "$value"
            echo
        done
        print_section_footer
    fi
    
    # CNAME Records
    if echo "$json_data" | jq -e '.cname' &> /dev/null; then
        print_section "CNAME Records"
        echo "$json_data" | jq -r '.cname[] | "\(.host)\t\(.target)"' 2>/dev/null | while IFS=$'\t' read -r host target; do
            print_record "Host" "$host"
            print_record "Target" "$target"
            echo
        done
        print_section_footer
    fi
    
    # Detailed A Records with additional info
    if echo "$json_data" | jq -e '.a' &> /dev/null; then
        print_section "Detailed A Record Information"
        echo "$json_data" | jq -r '.a[] | 
        "Host: \(.host)" as $host |
        .ips[] |
        "\($host)\t\(.ip)\t\(.country // "Unknown")\t\(.asn_name // "Unknown")\t\(.asn // "N/A")\t\(.ptr // "N/A")"' 2>/dev/null | while IFS=$'\t' read -r host ip country asn_name asn ptr; do
            echo -e "${WHITE}${BOLD}Host:${NC} ${GREEN}$host${NC}"
            print_record "IP Address" "$ip"
            print_record "Country" "$country"
            print_record "ASN" "$asn ($asn_name)"
            [[ "$ptr" != "N/A" ]] && print_record "PTR Record" "$ptr"
            echo -e "${CYAN}─────────────────────────────────────────────────${NC}"
            echo
        done
        print_section_footer
    fi
    
    # Banner information if available
    if echo "$json_data" | jq -e '.a[].ips[].banners' &> /dev/null; then
        print_section "HTTP/HTTPS Banner Information"
        echo "$json_data" | jq -r '.a[] | select(.ips[].banners) | 
        "Host: \(.host)" as $host |
        .ips[] | 
        select(.banners) |
        "\($host)\t\(.ip)\t\(.banners.https.title // "No Title")\t\(.banners.https.server // "Unknown Server")\t\(.banners.ssh.banner // "No SSH")"' 2>/dev/null | while IFS=$'\t' read -r host ip title server ssh; do
            echo -e "${WHITE}${BOLD}Host:${NC} ${GREEN}$host${NC}"
            print_record "IP" "$ip"
            print_record "HTTPS Title" "$title"
            print_record "Server" "$server"
            [[ "$ssh" != "No SSH" ]] && print_record "SSH Banner" "$ssh"
            echo -e "${CYAN}─────────────────────────────────────────────────${NC}"
            echo
        done
        print_section_footer
    fi
    
else
    # Fallback: Display raw JSON if jq is not available
    print_section "Raw Response"
    echo -e "${WHITE}$json_data${NC}"
    print_section_footer
fi

