#!/bin/bash

# Files containing the HTML content
HTML1_FILE="login.html"
HTML2_FILE="all319platforms.html"
HTML3_FILE="debiandownload.html"
# Define the base URL
BASE_URL="https://www.winccoa.com"

echo "Login to ${BASE_URL}"
curl -o "$HTML1_FILE" -c cookie.txt -d "user=${ETM_USERNAME}&pass=${ETM_PASSWORD}&logintype=login" -X POST "${BASE_URL}/index.html?tx_felogin_login%5Baction%5D=login&amp;tx_felogin_login%5Bcontroller%5D=Login"

echo "Open main Downloadpage"
curl -o "$HTML2_FILE" -b cookie.txt "${BASE_URL}/downloads/category/wincc-oa-319.html"

echo "Search for download link"
LINK=$(awk -v RS="</a>" '
    /WinCC OA 3.19/ && /Debian 11 \(Bullseye\)/ && !/arm64/ {
        match($0, /href="([^"]+)"/, arr)
        if (arr[1] != "") {
            print arr[1]
            exit
        }
    }
' $HTML2_FILE | sed 's/\&amp;/\&/g')

echo "Opening link: ${BASE_URL}/${LINK}"

curl -o "$HTML3_FILE" -b cookie.txt "${BASE_URL}/${LINK}"

# Extract the relative URL
RELATIVE_URL=$(grep "Download ZIP File" $HTML3_FILE | grep -v "arm64" | sed -n 's/.*href="\([^"]*\).*/\1/p' | sed 's/\&amp;/\&/g')

# Create the full URL
FULL_URL="${BASE_URL}${RELATIVE_URL}"

echo "Downloading $FULL_URL"
# Specify the output filename

# Download the file with verbose output
# OUTPUT_FILE="WinCC_OA.zip"
# curl -o "$OUTPUT_FILE" -b cookie.txt "$FULL_URL"

# Download using original filename
curl -O -J -b cookie.txt "$FULL_URL" -w "%{filename_effective}"
