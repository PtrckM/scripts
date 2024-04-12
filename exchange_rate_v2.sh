#!/bin/bash

# docs https://docs.coinapi.io/ register and get API_KEY and replace it.
# Define the API key and base URL
API_KEY="XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX"
BASE_URL="https://rest.coinapi.io/v1/exchangerate"

# Function to get exchange rate for a given pair
get_exchange_rate() {
    local from_currency="$1"
    local to_currency="$2"
    curl_cmd="curl -s ${BASE_URL}/${from_currency}/${to_currency}?apikey=${API_KEY}"
    sleep 1
    rate=$(eval "${curl_cmd}" | jq -r .rate)
    echo "${rate}"
}

# Get exchange rates
exchange1=$(get_exchange_rate "USD" "PHP")
exchange4=$(get_exchange_rate "EUR" "PHP")
exchange7=$(get_exchange_rate "GBP" "PHP")
exchange9=$(get_exchange_rate "CAD" "PHP")
exchange2=$(get_exchange_rate "BTC" "USD")
exchange3=$(get_exchange_rate "ETH" "USD")
exchange8=$(get_exchange_rate "AVAX" "USD")
exchange9=$(get_exchange_rate "SOL" "USD")

# Display exchange rates
echo -e "Local Currency:"
echo -e "USD to PHP: ${exchange1}"
echo -e "EUR to PHP: ${exchange4}"
echo -e "GBP to PHP: ${exchange7}"
echo -e "CAD to PHP: ${exchange9}\n"

echo -e "Crypto:"
echo -e "BTC in USD: ${exchange2}"
echo -e "ETH in USD: ${exchange3}"
echo -e "Avalanche in USD: ${exchange8}"
echo -e "Solana in USD: ${exchange9}\n"
