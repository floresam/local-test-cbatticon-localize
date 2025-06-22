#!/bin/bash

ROOT_DIR=".."
SRC_DIR="."
DRY_RUN=false

# Check for dry-run flag
if [[ "$1" == "--dry-run" ]]; then
  DRY_RUN=true
  echo "[Dry Run] No files will be copied."
fi

# Exit if localizations directory doesn't exist
if [ ! -d "$SRC_DIR" ]; then
  echo "Error: Source directory '$SRC_DIR' does not exist."
  exit 1
fi

# Find all .po files inside the localizations directory
find "$SRC_DIR" -type f -name "*.po" | while read -r file; do
  # Get relative path (strip the leading "localizations/")
  relative_path="${file#$SRC_DIR/}"

  # Determine target path
  target_dir=$ROOT_DIR/$(dirname "$relative_path")
  target_file="$ROOT_DIR/$relative_path"

  if $DRY_RUN; then
    echo "[Dry Run] Would create directory: $target_dir"
    echo "[Dry Run] Would copy '$file' to '$target_file'"
  else
    mkdir -p "$target_dir"
    cp "$file" "$target_file"
    echo "Copied '$file' to '$target_file'"
  fi
done

if $DRY_RUN; then
  echo "[Dry Run] Simulation complete. No files were copied."
else
  echo "All .po files have been restored from '$SRC_DIR' to their original structure."
fi

