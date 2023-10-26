#!/bin/bash
GREEN="\033[1;32m"
YELLOW="\033[1;33m"
NC="\033[0m"

findPayloadOffset() {
    build=$1
    info=$(zipdetails "$build")
    foundBin=0
    while IFS= read -r line; do
        if [[ $foundBin == 1 ]]; then
            echo "$line" | grep -q "PAYLOAD"
            res=$?
            if [[ $res == 0 ]]; then
                hexNum=$(echo "$line" | cut -d ' ' -f1)
                echo $(( 16#$hexNum ))
                break
            fi
            continue
        fi
        echo "$line" | grep -q "payload.bin"
        res=$?
        [[ $res == 0 ]] && foundBin=1
    done <<< "$info"
}

if [ "$1" ]; then
    echo "Generating .json"
    file_path=$1
    file_dir=$(dirname "$file_path")
    file_name=$(basename "$file_path")

    if [ -f $file_path ]; then
        # only generate for official builds. unless forced with 'export FORCE_JSON=1'
        if [[ $file_name == *"Urshanabi"* ]] || [[ $FORCE_JSON == 1 ]]; then
            if [[ $FORCE_JSON == 1 ]]; then
                echo -e "${GREEN}Forced generation of json${NC}"
            fi
            offset=$(findPayloadOffset "$file_path")
            [ -f payload_properties.txt ] && rm payload_properties.txt
            unzip "$file_path" payload_properties.txt
            keyPairs=$(cat payload_properties.txt | sed "s/=/\": \"/" | sed 's/^/          \"/' | sed 's/$/\"\,/')
            keyPairs=${keyPairs%?}
            datetime=$(date +%s)
            {
                echo "{"
                echo "  \"response\": ["
                echo "    {"
                echo "      \"datetime\": ${datetime},"
                echo "      \"filename\": \"${file_name}\","
                echo "      \"payload\": ["
                echo "        {"
                echo "          \"offset\": ${offset},"
                echo "${keyPairs}"
                echo "        }"
                echo "      ]"
                echo "    }"
                echo "  ]"
                echo "}"
            } > $file_path.json
            device_code=$(echo $file_name | cut -d'-' -f4)
            mv "${file_path}.json" "${file_dir}/${device_code}.json"
            echo -e "${GREEN}Done generating ${YELLOW}${device_code}.json${NC}"
        else
            echo -e "${YELLOW}Skipped generating json for a non-official build${NC}"
        fi
    fi
fi
