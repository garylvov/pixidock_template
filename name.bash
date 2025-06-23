#!/usr/bin/env bash

# Check if project name is provided
if [ $# -ne 1 ]; then
    echo "Usage: $0 <new-project-name>"
    echo "Example: $0 my-awesome-project"
    exit 1
fi

NEW_NAME="$1"
OLD_NAME="TEMPLATE"

# Validate project name (lowercase, alphanumeric, hyphens, underscores)
if [[ ! "$NEW_NAME" =~ ^[a-z0-9_-]+$ ]]; then
    echo "Error: Project name must be lowercase and contain only letters, numbers, hyphens, and underscores"
    exit 1
fi

echo "Renaming project from '$OLD_NAME' to '$NEW_NAME'..."

# Replace all occurrences in files
find . -type f -not -path "./.git/*" -exec sed -i "s/$OLD_NAME/$NEW_NAME/g" {} +

# Robustly rename directories and files named TEMPLATE (case-sensitive), including nested
find . -depth -name "$OLD_NAME" | while read path; do
    dir=$(dirname "$path")
    newpath="$dir/$NEW_NAME"
    echo "Renaming $path to $newpath"
    mv "$path" "$newpath"
done

echo "Project renamed successfully from '$OLD_NAME' to '$NEW_NAME'!"
echo ""
echo "Next steps:"
echo "1. Update the repository URL in your git remote"
echo "2. Review the changes with: git diff"
echo "3. Commit the changes: git add . && git commit -m 'Rename project to $NEW_NAME'"
