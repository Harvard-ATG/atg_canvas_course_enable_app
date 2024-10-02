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
# port echos into output.log file
exec 3>> output.log

# Skip the headers if the headers variable is set to 1
echo "starting process..."
if [[ $headers -eq 1 ]]; then
# use awk to skip the header line, NR stands for "Number of Records
    awk 'NR > 1' "$CSV_FILE" | while IFS=, read -r id course_code enrollment_term_id
    do
        timestamp=$(date "+%Y-%m-%d:%H:%M:%S")
        full_url="https://$URL/api/v1/courses/$id/tabs/context_external_tool_$TOOL_ID?hidden=false"
        # Process each column
        response=$(curl -s -X PUT "$full_url" \
            -H "Authorization: Bearer $API_KEY")
        # send output to output log
        echo "[$timestamp] Put URL: $full_url { id: $id, course_code: $course_code, enrollment_term_id: $enrollment_term_id, response: $response}" >&3
    done
    echo "process completed..."
else
    while IFS=, read -r id course_code enrollment_term_id
    do
        timestamp=$(date "+%Y-%m-%d:%H:%M:%S")
        full_url="https://$URL/api/v1/courses/$id/tabs/context_external_tool_$TOOL_ID?hidden=false"
        # Process each column
        response=$(curl -s -X PUT "$full_url" \
            -H "Authorization: Bearer $API_KEY")
        # send output to output log
        echo "[$timestamp] Put URL: $full_url { id: $id, course_code: $course_code, enrollment_term_id: $enrollment_term_id, response: $response}" >&3
    done < "$CSV_FILE"
    echo "process completed..."
fi