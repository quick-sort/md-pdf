# Markdown 转 PDF 说明书方案研究

## 项目目标

研究开源方案，实现：**Markdown 编写内容 → 自定义样式（页眉页脚、封面、SVG背景等）→ 输出 PDF**，支持一套内容多套样式。

## 三个备选方案对比

| 特性 | 方案一：Pandoc + WeasyPrint | 方案四：Pandoc + LaTeX | 方案五：Quarto |
|------|---------------------------|---------------------|--------------|
| **技术栈** | Python | TeX Live + Pandoc | Quarto + TeX Live |
| **渲染引擎** | WeasyPrint (CSS Paged Media) | XeLaTeX | XeLaTeX (内置) |
| **样式语言** | CSS (@page 规则) | LaTeX 模板 | YAML 配置 + LaTeX 片段 |
| **页眉页脚** | CSS @page margin boxes | fancyhdr 宏包 | fancyhdr (通过 header include) |
| **SVG 支持** | ✅ 原生支持 | ✅ 需 librsvg2 | ✅ 需 librsvg2 |
| **封面页** | CSS @page :first | titlepage 环境 | 自动生成 (YAML front matter) |
| **中文支持** | ✅ 需配置字体 | ✅ ctex 宏包 | ✅ CJKmainfont 配置 |
| **安装复杂度** | 中等 (pip) | 较高 (texlive) | 中等 (quarto + texlive) |
| **编译速度** | 中等 | 较慢 | 较慢 |
| **模板复杂度** | 中等 (CSS + HTML 模板) | 高 (完整 .tex 模板) | 低 (YAML 配置为主) |
| **内容样式分离** | ✅ 外部 CSS | ✅ 外部 .tex 模板 | ✅ _quarto.yml + header.tex |
| **适合场景** | 专业文档排版 | 学术/精细排版控制 | 快速上手/配置驱动 |

## 目录结构

```
md-to-pdf-research/
├── README.md                          # 本文件
├── .gitignore
├── shared/
│   ├── content/
│   │   └── motor-spec.md              # 共享 Markdown 内容
│   └── assets/
│       ├── motor-diagram.svg          # 电机外观图
│       ├── performance-curve.svg      # 性能曲线图
│       └── dimensions.svg             # 安装尺寸图
├── solution-1-weasyprint/
│   ├── styles/
│   │   └── spec-style.css             # CSS 样式
│   ├── templates/
│   │   └── template.html              # Pandoc HTML 模板
│   └── build.sh                       # 构建脚本
├── solution-4-latex/
│   ├── spec-template.tex              # LaTeX 模板
│   └── build.sh                       # 构建脚本
├── solution-5-quarto/
│   ├── _quarto.yml                    # Quarto 项目配置
│   ├── header.tex                     # LaTeX 页眉页脚片段
│   └── build.sh                       # 构建脚本
└── output/                            # PDF 输出目录
```

## 快速开始

```bash
# 单独构建某个方案
cd solution-1-weasyprint && ./build.sh
cd solution-4-latex && ./build.sh
cd solution-5-quarto && ./build.sh
```

## 依赖安装

### 方案一：Pandoc + WeasyPrint
```bash
# macOS
brew install pandoc
pip install weasyprint

# Ubuntu/Debian
sudo apt install pandoc
pip install weasyprint
```

### 方案四：Pandoc + LaTeX (XeLaTeX)
```bash
# macOS
brew install pandoc
brew install --cask mactex

# Ubuntu/Debian
sudo apt install pandoc texlive-xetex texlive-lang-chinese librsvg2-bin
```

### 方案五：Quarto
```bash
# macOS
brew install --cask quarto

# Ubuntu/Debian
# 从 https://quarto.org/docs/get-started/ 下载 .deb 安装
# Quarto 内置 Pandoc，还需要 texlive：
sudo apt install texlive-xetex texlive-lang-chinese librsvg2-bin
```
