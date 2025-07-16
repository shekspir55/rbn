# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Project Overview

This is a Hugo-based personal blog using the "nostyleplease" theme - a minimalist, nearly no-CSS theme that focuses on content first with excellent readability. The blog is multilingual, supporting both English and Armenian content.

## Architecture

- **Static Site Generator**: Hugo
- **Theme**: nostyleplease (minimalist theme with <1kb CSS)
- **Content**: Markdown files in `/content/posts/`
- **Configuration**: `config.toml` (Hugo configuration)
- **Build Output**: Generated to `/public/` directory
- **Assets**: Static files in `/static/` directory
- **Layouts**: Theme-based layouts in `/themes/nostyleplease/layouts/`

## Development Commands

### Build and Serve
```bash
# Serve locally with drafts (development)
hugo server --buildDrafts

# Serve locally (production preview)
hugo server

# Build for production
hugo
```

### Content Management
```bash
# Create new post (interactive)
make new

# Pull latest changes
make pull

# Commit and push changes
make push
```

### Git Workflow
```bash
# The Makefile automates git operations:
# - `make push` adds all files, commits with changed file list, and pushes
# - `make pull` pulls latest changes
```

## Content Structure

- **Posts**: Markdown files in `/content/posts/` with frontmatter
- **Images**: Stored in `/static/images/` and referenced in posts
- **Multilingual**: Supports both English and Armenian content
- **Drafts**: Set `draft: false` in frontmatter to publish

## Theme Customization

- **Menu**: Edit `/data/menu.toml` for navigation structure
- **Styling**: Theme uses minimal CSS by design (1kb total)
- **Dark Mode**: Automatic dark/light mode support with image inversion options
- **MathJax**: Mathematical notation support available

## Key Files

- `config.toml`: Hugo site configuration
- `Makefile`: Development workflow automation
- `/content/posts/`: Blog post content
- `/static/`: Static assets (images, CSS, JS)
- `/themes/nostyleplease/`: Theme files (don't modify directly)
- `/public/`: Generated site output (ignored in git)

## Development Workflow

1. Use `make new` to create new posts
2. Edit content in `/content/posts/`
3. Test locally with `hugo server --buildDrafts`
4. Use `make push` to commit and deploy changes
5. Site builds automatically to `/public/` for deployment

## Theme Features

- Extremely fast loading (1kb CSS)
- Content-first typography
- Responsive design
- Dark/light mode toggle
- RSS feed generation
- Table of contents support (add `toc: true` to frontmatter)
- MathJax integration for mathematical content