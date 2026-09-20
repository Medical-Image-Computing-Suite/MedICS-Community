# Extensions

Extensions add UI, menus, and workspace tools without changing the MedICS core. They are discovered automatically and can be loaded or unloaded without restarting (in normal cases).

---

## How extensions are discovered

1. **pip packages** that declare a `medics.extensions` entry point (**preferred**)
2. **Filesystem drop-ins** under `medics/extensions/`

When the same ID exists in both places, **entry points win**.

---

## Install an extension

```bash
pip install medics-ext-example
medics
```

Loaded extensions appear under the **Extensions** menu. Enable, disable, and inspect them from the extension manager dialog. Windowed extensions can open a central tab or window.

---

## Create an extension

```bash
medics --create-ext
# or with a name
medics --create-ext medics-ext-my-tool
```

This copies the bundled scaffold from `medics/extension_template/` and substitutes names.

### Typical layout

```text
medics-ext-my-tool/
├── medics_ext_my_tool/
│   ├── __init__.py          # ExtensionInterface implementation
│   ├── extension.json       # Display metadata
│   └── ui/
│       └── main_widget.py   # Optional PySide6 widget
├── tests/
├── pyproject.toml
└── README.md
```

### `ExtensionInterface`

Every extension implements:

```python
def get_name(self) -> str: ...
def get_version(self) -> str: ...
def get_description(self) -> str: ...
def get_author(self) -> str: ...
def get_category(self) -> str: ...
def initialize(self, app_context) -> bool: ...
def cleanup(self) -> None: ...
def show_extension(self) -> None: ...
```

`initialize(app_context)` receives the running `MedICSMain` instance, so the extension can use the workspace, config, event bus, menus, and docks.

### Entry point (pip)

```toml
# pyproject.toml
[project.entry-points."medics.extensions"]
my_extension = "medics_ext_my_package:MyExtension"
```

### Directory drop-in

```text
medics/extensions/
└── my_extension/
    ├── __init__.py
    └── extension.json
```

---

## `extension.json` (v0)

```json
{
  "name": "My Tool",
  "version": "1.0.0",
  "description": "Does XYZ",
  "author": "Your Name",
  "category": "Image Analysis",
  "enabled": true,
  "windowed": true,
  "icon": "icon.png"
}
```

| Key | Description |
| --- | --- |
| `name` | Display name in menus |
| `version` | SemVer string |
| `description` | Short description |
| `author` | Author name |
| `category` | Groups extensions in the menu |
| `enabled` | Whether to auto-load (config may also gate enablement) |
| `windowed` | Whether to create a menu / toolbar action |
| `icon` | Icon file relative to the extension directory (`null` = none) |

Newer manifests may use schema `medics.extension/1` with `capabilities` / `requires`. Prefer matching sibling extensions in the MedICS ecosystem.

---

## Build and publish

```bash
# from the extension directory
medics --build-ext                 # protected / Cython wheel (when configured)
medics --build-ext --unprotected   # plain-Python wheel
```

Many community extensions publish to PyPI with a `Publish[platforms;pythons]` commit subject (or GitHub release / workflow dispatch). See each extension’s `.github/workflows` README for the exact publish grammar.

---

## Related pages

- [Official Extensions](Official-Extensions) — the MedICS Team extensions, with per-extension docs
- [CLI Reference](CLI-Reference)
- [Architecture](Architecture)
- [Getting Started](Getting-Started)
