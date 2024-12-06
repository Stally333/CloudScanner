#!/bin/bash

# Process all .strings files
find "${SRCROOT}" -name "*.strings" -print0 | while IFS= read -r -d '' file; do
    filename=$(basename "$file")
    directory=$(dirname "$file")
    
    # Generate strings file
    xcrun extractLocStrings -o "${directory}" "${directory}/${filename}"
    
    # Merge duplicates if they exist
    if [ -f "${directory}/Weather.strings" ] && [ -f "${directory}/WeatherLocalizable.strings" ]; then
        cat "${directory}/Weather.strings" >> "${directory}/WeatherLocalizable.strings"
        rm "${directory}/Weather.strings"
    fi
done 