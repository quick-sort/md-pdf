#!/bin/bash
# 方案五：Quarto
# 依赖：quarto, texlive-xetex, librsvg2-bin
set -e

SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
ROOT_DIR="$(dirname "$SCRIPT_DIR")"
CONTENT="$ROOT_DIR/shared/content/motor-spec.md"
OUTPUT="$ROOT_DIR/output/motor-spec-quarto.pdf"

echo "=== 方案五：Quarto ==="
echo "Converting: $CONTENT -> $OUTPUT"

# Copy markdown into project dir so quarto can resolve relative asset paths
cp "$CONTENT" "$SCRIPT_DIR/motor-spec.md"

# Render from the quarto project directory
cd "$SCRIPT_DIR"
quarto render motor-spec.md --to pdf --no-cache 2>&1

# Move output
mv "$SCRIPT_DIR/motor-spec.pdf" "$OUTPUT"

# Cleanup
rm -f "$SCRIPT_DIR/motor-spec.md"

echo "✅ Done: $OUTPUT"
echo "   File size: $(du -h "$OUTPUT" | cut -f1)"
