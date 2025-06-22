#!/bin/bash

DEST_DIR="."
DRY_RUN=false

# Check for dry-run flag
if [[ "$1" == "--dry-run" ]]; then
  DRY_RUN=true
  echo "[Dry Run] No files will be copied."
fi

# Get the absolute path to the current directory (assumed to be 'localizations')
LOCALIZATIONS_DIR_ABS="$(pwd)"

# Move to parent directory to search source files
cd .. || exit 1

# Find .po files excluding the 'localizations' directory itself
find . -type d -name "$(basename "$LOCALIZATIONS_DIR_ABS")" -prune -o -type f -name "*.po" -print | while read -r file; do
  # Strip leading './'
  relative_path="${file#./}"

  # Create corresponding target directory path inside localizations
  dest_file_path="$LOCALIZATIONS_DIR_ABS/$relative_path"
  dest_dir_path="$(dirname "$dest_file_path")"

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
  echo "All .po files have been copied into '$(basename "$LOCALIZATIONS_DIR_ABS")' with original structure preserved."
fi

