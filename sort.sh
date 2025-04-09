#!/bin/bash

DIRECTORIES=("maps" "materials" "models" "resource" "sound")
UPLOAD_DIR="./upload"
MAX_SIZE=2093796557 # 1.95 GB
NUM_JOBS=$(nproc)

SORT_START_TIME=$(date +%s.%N)

process_file() {
    local file="$1"
    local MODIFICATION_TIME
    MODIFICATION_TIME=$(git log -1 --format=%ct -- "$file" 2>/dev/null || true)

    # Skip PNG files
    if [[ "$file" == *.png ]]; then
        return
    fi

    if [[ -n "$MODIFICATION_TIME" ]]; then
        local FILE_SIZE
        FILE_SIZE=$(stat -c%s "$file" 2>/dev/null)
        echo "$MODIFICATION_TIME|$FILE_SIZE|$file"
    else
        echo "UNSORTED|$file"
    fi
}

export -f process_file

SORTED_FILES=()
UNSORTED_FILES=()

if ! RESULTS=$(find "${DIRECTORIES[@]}" -type f -print0 | xargs -0 -n1 -P"$NUM_JOBS" -I{} bash -c 'process_file "$@"' _ {} 2>/dev/null); then
    echo "Error processing files" >&2
    exit 1
fi

while IFS= read -r result; do
    if [[ -n "$result" ]]; then
        if [[ "$result" == UNSORTED* ]]; then
            UNSORTED_FILES+=("${result#UNSORTED|}")
        else
            SORTED_FILES+=("$result")
        fi
    fi
done <<< "$RESULTS"

IFS=$'\n' SORTED_FILES=($(printf "%s\n" "${SORTED_FILES[@]}" | sort -t '|' -k1,1n))

TOTAL_PROCESSED=$(( ${#SORTED_FILES[@]} + ${#UNSORTED_FILES[@]} ))
TOTAL_SORTED=${#SORTED_FILES[@]}

if [ $TOTAL_SORTED -eq 0 ]; then
    echo "No valid files found."
    exit 1
fi

echo -e "\n=== Sorting Summary ==="
printf "Total files processed: %d\n" "$TOTAL_PROCESSED"
printf "Total files sorted: %d\n" "$TOTAL_SORTED"
printf "Total unsorted files: %d\n" "${#UNSORTED_FILES[@]}"

if [ ${#UNSORTED_FILES[@]} -gt 0 ]; then
    echo "The following files could not be sorted due to missing modification time:"
    for file in "${UNSORTED_FILES[@]}"; do
        printf "  - %s\n" "$file"
    done
fi
echo "========================"

# Save sorted files to a specified file
# OUTPUT_FILE="sorted_files.txt"
# printf "%s\n" "${SORTED_FILES[@]}" > "$OUTPUT_FILE"
# echo "Sorted files saved to $OUTPUT_FILE."

current_addon_size=0
current_addon_number=1
current_addon_dir="${UPLOAD_DIR}/content${current_addon_number}"
mkdir -p "$current_addon_dir"

if [ -d "lua" ]; then
    mv "lua" "$current_addon_dir/"
fi

MOVE_START_TIME=$(date +%s.%N)

TOTAL_MOVED=0
FAILED_MOVES=()

for entry in "${SORTED_FILES[@]}"; do
    IFS='|' read -r mod_time file_size file_path <<< "$entry"

    # Skip PNG files during the moving process
    if [[ "$file_path" == *.png ]]; then
        continue
    fi

    file_size=${file_size%.*}

    if (( current_addon_size + file_size > MAX_SIZE )); then
        current_addon_number=$((current_addon_number + 1))
        current_addon_dir="${UPLOAD_DIR}/content${current_addon_number}"
        mkdir -p "$current_addon_dir"
        current_addon_size=0
        # printf "Created new directory: %s\n" "$current_addon_dir"
    fi

    relative_path=$(dirname "$file_path")
    target_dir="${current_addon_dir}/${relative_path}"

    mkdir -p "$target_dir"

    if mv "$file_path" "$target_dir/"; then
        ((TOTAL_MOVED++))
        current_addon_size=$((current_addon_size + file_size))
    else
        FAILED_MOVES+=("$file_path")
    fi
done

echo -e "\n=== Move Summary ==="
printf "Total files moved: %d\n" "$TOTAL_MOVED"
if [ ${#FAILED_MOVES[@]} -gt 0 ]; then
    echo "The following files failed to move:"
    for file in "${FAILED_MOVES[@]}"; do
        printf "  - %s\n" "$file"
    done
else
    echo "All files were successfully moved."
fi
echo "========================"

echo -e "\n=== Addon Directory Sizes ==="
for ((i=1; i<=current_addon_number; i++)); do
    addon_dir="${UPLOAD_DIR}/content${i}"
    addon_size=$(du -sh "$addon_dir" 2>/dev/null | awk '{print $1}')
    printf "Size of %s: %s\n" "$addon_dir" "$addon_size"
done
echo "========================"
