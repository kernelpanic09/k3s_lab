#!/bin/bash
# Recursively rename all .yml files to .yaml
# Safe for version-controlled projects

echo "🔍 Finding .yml files..."
find . -type f -name "*.yml" | while read -r file; do
  new_file="${file%.yml}.yaml"
  echo "🔄 Renaming: $file → $new_file"
  mv "$file" "$new_file"
done

echo "✅ All .yml files renamed to .yaml"

