# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Repository purpose

Comparative research of three open-source Markdown → PDF toolchains for producing styled product specification documents (cover page, headers/footers, embedded SVG, Chinese text). The same source Markdown is rendered three different ways so the outputs can be compared side-by-side.

## Build commands

Each solution has a self-contained `build.sh`. They must be run from inside the solution directory (the scripts derive `ROOT_DIR` from `$(dirname "$SCRIPT_DIR")`):

```bash
cd solution-1-weasyprint && ./build.sh   # → output/motor-spec-weasyprint.pdf
cd solution-4-latex      && ./build.sh   # → output/motor-spec-latex.pdf
cd solution-5-quarto     && ./build.sh   # → output/motor-spec-quarto.pdf
```

There is no top-level build, lint, or test runner. The "test" is visual inspection of the three PDFs in `output/`.

Per-solution dependencies are listed in `README.md` § 依赖安装. On Ubuntu the union is roughly: `pandoc`, `texlive-xetex`, `texlive-lang-chinese`, `librsvg2-bin`, `quarto`, plus `pip install weasyprint`.

## Architecture

**Single source, multiple styles.** All three solutions consume the same input — `shared/content/motor-spec.md` plus SVGs under `shared/content/assets/` (which is a directory; `shared/assets/` also exists with the same files for symmetry). Each solution directory holds only the styling/template layer for one toolchain and writes its PDF to the shared `output/`.

**Path-resolution quirks are the main source of bugs.** Each toolchain handles relative asset paths differently, and the build scripts work around this in different ways:

- **solution-1-weasyprint**: `cd`s into `shared/content/` *before* invoking pandoc so WeasyPrint resolves `assets/*.svg` correctly. Uses a custom `templates/template.html` and `styles/spec-style.css` (CSS Paged Media `@page` rules drive the cover, headers, footers).
- **solution-4-latex**: stays in place, passes `--resource-path=$ROOT_DIR/shared/content` so pandoc/xelatex finds the SVGs. SVGs are converted on the fly by `librsvg2-bin` (`rsvg-convert`). Uses a single LaTeX template `spec-template.tex`.
- **solution-5-quarto**: Quarto resolves paths relative to the project (`_quarto.yml`) directory, so the script *copies* `motor-spec.md` into the solution dir, renders, moves the PDF to `output/`, then deletes the copy. Styling is split between `_quarto.yml` (page geometry, fonts, CJK config) and `header.tex` (fancyhdr-based headers/footers, color definitions).

When changing the shared markdown, verify all three solutions still render — each toolchain has different tolerance for raw HTML, YAML front matter, and pandoc-specific syntax. The markdown currently uses raw `<div class="cover-page">` blocks that only the WeasyPrint solution styles meaningfully; the LaTeX/Quarto solutions ignore them and rely on their own template-driven cover/header logic.

`output/` is gitignored. LaTeX intermediate files (`*.aux`, `*.log`, …) and Quarto's `.quarto/` and `*_files/` directories are also gitignored — do not commit them.
