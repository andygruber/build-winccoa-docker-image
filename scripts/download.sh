#!/bin/bash

# File containing the HTML content
HTML_FILE="Downloads.html"

# Define the base URL
BASE_URL="https://www.winccoa.com"

OUTPUT_FILE="WinCC_OA.zip"

PATCH_NUM="p007"

curl -o "$HTML_FILE" -c cookie.txt -d "user=${USERNAME}&pass=${PASSWORD}&logintype=login" -X POST "${BASE_URL}/index.html?tx_felogin_login%5Baction%5D=login&amp;tx_felogin_login%5Bcontroller%5D=Login"

curl -o "$HTML_FILE" -b cookie.txt "${BASE_URL}/downloads/detail/wincc-oa-319-${PATCH_NUM}-debian-11-bullseye.html"

# Extract the relative URL
RELATIVE_URL=$(grep "Download ZIP File" $HTML_FILE | grep -v "arm64" | sed -n 's/.*href="\([^"]*\).*/\1/p' | sed 's/\&amp;/\&/g')

# Create the full URL
FULL_URL="${BASE_URL}${RELATIVE_URL}"

echo "Downloading $FULL_URL to $OUTPUT_FILE"
# Specify the output filename

# Download the file with verbose output
curl -o "$OUTPUT_FILE" -b cookie.txt "$FULL_URL"

echo "Downloaded to $OUTPUT_FILE"
