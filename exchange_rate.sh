#!/bin/bash

# docs https://www.currencyconverterapi.com/docs register to get apiKey and replace it.
# list of available currency https://free.currconv.com/api/v7/currencies?apiKey=xxxxxxxxxxxxxxxx

# Function to get exchange rate for a given currency pair
get_exchange_rate() {
    local currency_pair=$1
    local response=$(curl -s -w "%{http_code}" "https://free.currconv.com/api/v7/convert?q=$currency_pair&compact=ultra&apiKey=xxxxxxxxxxxxxxxx" -o temp.json)
    local http_code=${response: -3}

    # Check for HTTP errors
    if [[ $http_code -ne 200 ]]; then
        echo "Error: HTTP $http_code - Unable to fetch exchange rate for $currency_pair"
        return 1
    fi

    # Check if the response is empty
    if [ ! -s temp.json ]; then
        echo "Error: Empty response - Unable to fetch exchange rate for $currency_pair"
        return 1
    fi

    # Parse the JSON response and extract the exchange rate
    local exchange_rate=$(jq -r ".$currency_pair" temp.json)

    # Check if exchange rate is empty
    if [ -z "$exchange_rate" ]; then
        echo "Error: Exchange rate not found for $currency_pair"
        return 1
    fi

    echo "$exchange_rate"
}

# Fetch exchange rates for different currency pairs
exchange1=$(get_exchange_rate "USD_PHP") || exchange1="Unavailable"
exchange4=$(get_exchange_rate "EUR_PHP") || exchange4="Unavailable"
exchange5=$(get_exchange_rate "AED_PHP") || exchange5="Unavailable"
exchange6=$(get_exchange_rate "SAR_PHP") || exchange6="Unavailable"
exchange7=$(get_exchange_rate "GBP_PHP") || exchange7="Unavailable"
exchange8=$(get_exchange_rate "CAD_PHP") || exchange8="Unavailable"
exchange2=$(get_exchange_rate "BTC_USD") || exchange2="Unavailable"

# Remove temporary JSON file
rm temp.json

# Display the results
echo -e "===== Exchange Rates ====="
echo -e "Local Currencies:\n- USD to PHP: $exchange1\n- EUR to PHP: $exchange4\n- AED to PHP: $exchange5\n- SAR to PHP: $exchange6\n- GBP to PHP: $exchange7\n- CAD to PHP: $exchange8\n"
echo -e "Cryptocurrencies:\n- BTC to USD: $exchange2"
