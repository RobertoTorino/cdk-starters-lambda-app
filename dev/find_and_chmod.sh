#!/bin/bash

# Desired permissions
desired_perms="755"

# Find all .sh files recursively from the current directory
files=$(find . -type f -name "*.sh")

# Check if any files were found
if [ -z "$files" ]; then
  echo "No .sh files found."
  exit 0
fi

# Prompt the user to change permissions for all files or individually
read -p "Do you want to change permissions for all files? (y/n): " change_all

# Function to change permissions
change_permissions() {
  local file=$1
  echo "Found: $file"

  # Get current permissions of the file
  current_perms=$(stat -f "%A" "$file")

  # Convert the current permissions to octal
  current_perms_octal=$(printf "%o" "$((8#$current_perms))")

  # Check if the file already has the desired permissions
  if [ "$current_perms_octal" == "$desired_perms" ]; then
    echo "File $file already has permissions $desired_perms. Skipping."
    return
  fi

  # Change permissions if change_all is set to 'y'
  if [ "$change_all" == "y" ] || [ "$change_all" == "Y" ]; then
    chmod "$desired_perms" "$file"
    echo "Permissions for $file changed to $desired_perms."
  else
    # Prompt the user to change permissions individually
    read -p "Do you want to change permissions to $desired_perms for this file? (y/n): " choice
    case "$choice" in
      y|Y )
        chmod "$desired_perms" "$file"
        echo "Permissions for $file changed to $desired_perms."
        ;;
      * )
        echo "Skipping $file."
        ;;
    esac
  fi
}

# Loop through each found file and change permissions
for file in $files; do
  change_permissions "$file"
done
