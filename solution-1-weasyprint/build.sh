#!/bin/bash
# 方案一：Pandoc + WeasyPrint
# 依赖：pandoc, weasyprint (pip install weasyprint)
set -e

SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
ROOT_DIR="$(dirname "$SCRIPT_DIR")"
CONTENT="$ROOT_DIR/shared/content/motor-spec.md"
OUTPUT="$ROOT_DIR/output/motor-spec-weasyprint.pdf"

echo "=== 方案一：Pandoc + WeasyPrint ==="
echo "Converting: $CONTENT -> $OUTPUT"

# 在 content 目录下执行，让 WeasyPrint 正确解析图片相对路径
cd "$ROOT_DIR/shared/content"
pandoc motor-spec.md \
  --from markdown \
  --to html5 \
  --template "$SCRIPT_DIR/templates/template.html" \
  --css "$SCRIPT_DIR/styles/spec-style.css" \
  --pdf-engine=weasyprint \
  -o "$OUTPUT"

echo "✅ Done: $OUTPUT"
echo "   File size: $(du -h "$OUTPUT" | cut -f1)"
