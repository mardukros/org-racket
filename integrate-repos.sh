#!/bin/bash
# Script to integrate racket organization repositories into this monorepo
# Usage: ./integrate-repos.sh [repos.txt]

set -e

# Config file with list of repos (default: repos.txt)
CONFIG_FILE="${1:-repos.txt}"

# Check if config file exists
if [ ! -f "$CONFIG_FILE" ]; then
    echo "Error: Config file '$CONFIG_FILE' not found"
    echo "Usage: $0 [config_file]"
    exit 1
fi

echo "Starting monorepo integration..."
echo "================================"
echo "Reading repositories from: $CONFIG_FILE"
echo ""

# Create a temporary directory for cloning
TEMP_DIR=$(mktemp -d)
trap 'rm -rf "$TEMP_DIR"' EXIT

# Read repos from config file (skip comments and empty lines)
while IFS= read -r line || [ -n "$line" ]; do
    # Skip comments and empty lines
    [[ "$line" =~ ^[[:space:]]*# ]] && continue
    [[ -z "${line// }" ]] && continue
    
    # Parse owner/repo format
    FULL_REPO=$(echo "$line" | tr -d '[:space:]')
    REPO_NAME=$(basename "$FULL_REPO")
    REPO_URL="https://github.com/${FULL_REPO}.git"
    
    echo ""
    echo "Processing: $FULL_REPO"
    echo "----------------------------"
    
    # Skip if directory already exists
    if [ -d "$REPO_NAME" ]; then
        echo "Directory $REPO_NAME already exists, skipping..."
        continue
    fi
    
    # Clone the repository
    echo "Cloning $REPO_URL..."
    if git clone --depth 1 "$REPO_URL" "$TEMP_DIR/$REPO_NAME" 2>&1; then
        # Remove .git directory and related files
        echo "Removing .git directory..."
        rm -rf "$TEMP_DIR/$REPO_NAME/.git"
        rm -f "$TEMP_DIR/$REPO_NAME/.gitmodules"
        
        # Move to final location
        echo "Moving to final location..."
        mv "$TEMP_DIR/$REPO_NAME" "./$REPO_NAME"
        
        echo "✓ Successfully integrated $REPO_NAME"
    else
        echo "✗ Failed to clone $FULL_REPO (repository may not exist or is private)"
    fi
done < "$CONFIG_FILE"

echo ""
echo "================================"
echo "Monorepo integration complete!"
echo ""
echo "Next steps:"
echo "1. Review the integrated repositories"
echo "2. Add and commit the changes: git add . && git commit -m 'Integrate racket org repositories'"
echo "3. Push to your repository"
