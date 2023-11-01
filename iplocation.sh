#!/bin/bash

# Function to get the IP location
get_ip_location() {
    local ip="$1"
    local api_url="https://ipinfo.io/${ip}/json"
    local location_info

    # Use curl to fetch the IP location information
    location_info=$(curl "$api_url" -s | jq -r)

    # Print the location information
    echo "Location information for IP address: $ip"
    echo "$location_info"
}

# Check if an IP address was provided as an argument, or use localhost
if [ $# -eq 0 ]; then
  ip=$(curl https://icanhazip.com -s)  # Default to localhost
else
    ip="$1"
fi

# Call the function to get and display the location information
get_ip_location "$ip"
