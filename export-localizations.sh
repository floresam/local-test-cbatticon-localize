#!/bin/bash

DEST_DIR="localizations"
DRY_RUN=false

# Check for dry-run flag
if [[ "$1" == "--dry-run" ]]; then
  DRY_RUN=true
  echo "[Dry Run] No files will be copied."
fi

# Ensure the destination directory exists
mkdir -p "$DEST_DIR"

# Find and process .po files outside the localizations directory
find . -type d -name "$DEST_DIR" -prune -o -type f -name "*.po" -print | while read -r file; do
  # Get relative path without leading ./
  relative_path="${file#./}"

  # Extract the directory part
  dir_path=$(dirname "$relative_path")

  # Create the destination directory structure
  dest_dir_path="$DEST_DIR/$dir_path"
  dest_file_path="$DEST_DIR/$relative_path"

  if $DRY_RUN; then
    echo "[Dry Run] Would create directory: $dest_dir_path"
    echo "[Dry Run] Would copy '$file' to '$dest_file_path'"
  else
    mkdir -p "$dest_dir_path"
    cp "$file" "$dest_file_path"
    echo "Copied '$file' to '$dest_file_path'"
  fi
done

if $DRY_RUN; then
  echo "[Dry Run] Simulation complete. No files were copied."
else
  echo "All .po files have been copied into '$DEST_DIR' with original structure preserved."
fi

