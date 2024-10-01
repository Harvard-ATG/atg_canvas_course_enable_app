#!/bin/bash

# Parse command line arguments
while getopts "f:h:k:t:" opt; do
    case $opt in
        f)
            CSV_FILE="$OPTARG"
            ;;
        h)
            URL="$OPTARG"
            ;;
        k)
            API_KEY="$OPTARG"
            ;;
        t)
            TOOL_ID="$OPTARG"
            ;;
        \?)
            echo "Invalid option: -$OPTARG" >&2
            exit 1
            ;;
    esac
done

# Check if CSV_FILE, URL, API_KEY, and TOOL_ID are set
if [ -z "$CSV_FILE" ] || [ -z "$URL" ] || [ -z "$API_KEY" ] || [ -z "$TOOL_ID" ]; then
    echo "Usage: $0 -f <csv_file> -h <url> -k <api_key> -t <tool_id>"
    exit 1
fi

headers=1


# Skip the headers if the headers variable is set to 1
if [[ $headers -eq 1 ]]; then
    tail -n +2 "$CSV_FILE" | while IFS=, read -r id course_code enrollment_term_id
    do
        full_url="https://$URL/api/v1/courses/$id/tabs/context_external_tool_$TOOL_ID?hidden=false"
        # Process each column
        response=$(curl -s -X PUT "$full_url" \
            -H "Authorization: Bearer $API_KEY")

        echo "Put URL:" $full_url
        echo "id: $id"
        echo "course_code: $course_code"
        echo "enrollment_term_id: $enrollment_term_id"
        echo "Response: $response"
        echo "-------------------"
    done
else
    while IFS=, read -r id course_code enrollment_term_id
    do
        full_url="https://$URL/api/v1/courses/$id/tabs/context_external_tool_$TOOL_ID?hidden=false"
        # Process each column
        response=$(curl -s -X PUT "$full_url" \
            -H "Authorization: Bearer $API_KEY")
        echo "Put URL:" $full_url
        echo "id: $id"
        echo "course_code: $course_code"
        echo "enrollment_term_id: $enrollment_term_id"
        echo "Response: $response"
        echo "-------------------"
    done < "$CSV_FILE"
fi