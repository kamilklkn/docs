#!/bin/bash

# Tüm MDX dosyalarından text-align: justify style tag'ini kaldır
find . -name "*.mdx" -type f ! -path "*/node_modules/*" ! -path "*/snippets/*" | while read file; do
  # Eğer dosyada style tag'i varsa kaldır
  if grep -q '<style>' "$file"; then
    # Style tag'ini ve içeriğini kaldır (frontmatter'dan sonra boş satır bırakarak)
    awk '
      BEGIN { skip=0 }
      /^<style>{\`$/ { skip=1; next }
      skip == 1 && /^\`}<\/style>$/ { skip=0; next }
      skip == 1 { next }
      { print }
    ' "$file" | sed '/^---$/{
      N
      /^---\n---$/d
    }' | sed '/^$/N;/^\n$/d' > "$file.tmp" && mv "$file.tmp" "$file"
  fi
done

echo "✅ Tüm MDX dosyalarından style tag'leri kaldırıldı!"

