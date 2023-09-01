#!/bin/bash

# function for displaying help
usage() {
    echo "Usage: $0 [-h] [-f file] [-t translate]"
    echo "  -h, --help        Show this help and exit"
    echo "  -f, --file        HTML file for translation"
    echo "  -t, --translate   JSON file with translations"
}

# parsing command line arguments
while [[ $# -gt 0 ]]; do
    key="$1"
    case $key in
        -h|--help)
        usage
        exit 0
        ;;
        -f|--file)
        HTML_FILE="$2"
        shift # past argument
        shift # past value
        ;;
        -t|--translate)
        TRANSLATE_FILE="$2"
        shift # past argument
        shift # past value
        ;;
        *)
        echo "Unknown argument: $1"
        usage
        exit 1
        ;;
    esac
done

# checking required arguments
if [[ -z "$HTML_FILE" || -z "$TRANSLATE_FILE" ]]; then
    echo "Error: required arguments not specified"
    usage
    exit 1
fi

# reading json translation file into an associative array
declare -A TRANSLATIONS
while IFS="=" read -r key value; do
    TRANSLATIONS["$key"]="$value"
done < <(jq -r 'to_entries[] | "\(.key)=\(.value)"' "$TRANSLATE_FILE")

# creating a folder with the name of the translation file (without the .json extension)
TRANSLATE_DIR="${TRANSLATE_FILE%.json}"
mkdir -p "$TRANSLATE_DIR"

# replacing strings in the html file using the associative array of translations and saving the result in a new folder
OUTPUT_FILE="$TRANSLATE_DIR/$(basename "$HTML_FILE")"
while IFS= read -r line; do
    for key in "${!TRANSLATIONS[@]}"; do
        line="${line//$key/${TRANSLATIONS[$key]}}"
    done
    echo "$line"
done < "$HTML_FILE" > "$OUTPUT_FILE"

echo "Translation completed. Result saved in file $OUTPUT_FILE."
