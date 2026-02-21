# Pandoc HTML Defaults (with Diagrams)

A minimal, per-project setup for converting **Markdown → HTML** using Pandoc, with first-class support for **Mermaid and other diagrams** via `pandoc-ext-diagram`.

This project intentionally keeps things simple:

* You call `pandoc` yourself
* Input/output files are explicit
* All common flags live in a Pandoc **defaults file**

No wrapper scripts, no CSS, no templates.

---

## Project Structure

```
.
├─ pandoc/
│  ├─ filters/
│  │  └─ diagram.lua
│  └─ html.yaml
│
└─ README.md
```

* `pandoc/filters/diagram.lua` — vendored `pandoc-ext-diagram` Lua filter
* `pandoc/html.yaml` — project defaults (acts like an rc file)
* `README.md` — setup and usage instructions

---

## Requirements

* Pandoc **3.0+**

The `pandoc-ext-diagram` Lua filter is **bundled** in this repo at `pandoc/filters/diagram.lua` — no separate installation needed.

---

## Install Pandoc

### Ubuntu / Debian

```bash
sudo apt update
sudo apt install pandoc
```

### macOS (Homebrew)

```bash
brew install pandoc
```

### Verify

```bash
pandoc --version
```

---

## Usage

Call Pandoc explicitly and reference the defaults file:

```bash
pandoc \
  --defaults pandoc/html.yaml \
  input.md \
  -o output.html
```

You can override any default at runtime:

```bash
pandoc \
  --defaults pandoc/html.yaml \
  --toc-depth=2 \
  input.md \
  -o output.html
```
---

## Adding New Defaults

To add another output configuration (for example, slides or PDFs):

1. Create a new defaults file:

   ```bash
   pandoc/slides.yaml
   ```

2. Adjust options as needed

3. Call Pandoc with the new defaults:

   ```bash
   pandoc --defaults pandoc/slides.yaml input.md -o output.html
   ```

Each defaults file is independent and can evolve without affecting others.
