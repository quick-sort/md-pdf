#!/bin/bash
# 方案四：Pandoc + LaTeX (XeLaTeX)
# 依赖：pandoc, texlive-xetex, texlive-lang-chinese, librsvg2-bin
set -e

SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
ROOT_DIR="$(dirname "$SCRIPT_DIR")"
CONTENT="$ROOT_DIR/shared/content/motor-spec.md"
OUTPUT="$ROOT_DIR/output/motor-spec-latex.pdf"

echo "=== 方案四：Pandoc + LaTeX (XeLaTeX) ==="
echo "Converting: $CONTENT -> $OUTPUT"

# 使用 pandoc 通过 XeLaTeX 引擎生成 PDF
# --resource-path 让图片路径相对于 shared/content 目录解析
# --svg 图片由 librsvg2 (rsvg-convert) 自动转换
pandoc "$CONTENT" \
  --from markdown \
  --template "$SCRIPT_DIR/spec-template.tex" \
  --pdf-engine=xelatex \
  --resource-path="$ROOT_DIR/shared/content" \
  -V geometry:a4paper \
  -o "$OUTPUT"

echo "✅ Done: $OUTPUT"
echo "   File size: $(du -h "$OUTPUT" | cut -f1)"
