#!/bin/bash
# Script to update specific integrated repositories
# Usage: ./update-repo.sh <repo-name> [repo-name...]
#
# Example: ./update-repo.sh racket typed-racket

set -e

if [ $# -eq 0 ]; then
    echo "Usage: $0 <repo-name> [repo-name...]"
    echo "Example: $0 racket typed-racket"
    exit 1
fi

BASE_URL="https://github.com/racket"

echo "Updating repositories..."
echo "========================"

# Create temp directory once
TEMP_DIR=$(mktemp -d)
trap "rm -rf $TEMP_DIR" EXIT

for REPO_NAME in "$@"; do
    echo ""
    echo "Updating: $REPO_NAME"
    echo "--------------------"
    
    # Check if directory exists
    if [ ! -d "$REPO_NAME" ]; then
        echo "Error: Directory $REPO_NAME does not exist"
        echo "Use integrate-repos.sh to add new repositories"
        continue
    fi
    
    # Clone fresh copy
    echo "Cloning latest version..."
    if git clone --depth 1 "$BASE_URL/$REPO_NAME.git" "$TEMP_DIR/$REPO_NAME" 2>&1; then
        # Remove old directory
        echo "Removing old version..."
        rm -rf "./$REPO_NAME"
        
        # Remove .git from new copy
        echo "Removing .git directory..."
        rm -rf "$TEMP_DIR/$REPO_NAME/.git"
        rm -f "$TEMP_DIR/$REPO_NAME/.gitmodules"
        
        # Move new version
        echo "Installing new version..."
        mv "$TEMP_DIR/$REPO_NAME" "./$REPO_NAME"
        
        echo "✓ Successfully updated $REPO_NAME"
    else
        echo "✗ Failed to update $REPO_NAME"
    fi
done

echo ""
echo "========================"
echo "Update complete!"
echo ""
echo "Review changes and commit:"
echo "  git add ."
echo "  git commit -m 'Update integrated repositories'"
echo "  git push"
