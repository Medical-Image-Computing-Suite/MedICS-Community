# Toolboxes

Built-in toolboxes are static plugins loaded by `ToolboxManager`. Each toolbox is a `BaseToolboxPlugin` paired with a Qt widget.

> **How toolboxes open:** They open as **tabs in the central tab widget** — not as dock panels. Checkboxes under the *Toolboxes* menu mainly control whether the toolbox icon appears on the activity bar.

---

## Built-in toolboxes

| Toolbox | Role |
| --- | --- |
| **PyEditor** | Python IDE: syntax highlighting, completions, AST outline, integrated terminal, run against the Jupyter kernel |
| **ImportData** | Unified importer for DICOM, NIfTI, TIFF/PNG/JPEG, video, HDF5, MAT, NumPy, CSV, and related formats; background workers with progress |
| **FilePreview** | Read-only preview of text, code, markdown, spreadsheets, 2-D images, and volumetric data |

Custom tools should be packaged as **[extensions](Extensions)** rather than patched into `medics/toolboxes/`.

---

## PyEditor

- Jedi-based completions
- Indent / unindent with Tab / Shift-Tab
- Line numbers and code outline helpers
- Run code against the shared in-process Jupyter kernel
- Integrated terminal for shell commands

Workspace variables created or updated while running are reflected in the Variables dock.

---

## ImportData

Typical flow:

1. Drop files / folders, or browse a DICOM series.
2. Background worker loads data (with progress).
3. Preview in an image view when applicable.
4. Import into the workspace under a chosen name.

Supported families include DICOM series, image stacks, NIfTI, video frame stacks, HDF5 / `.med`, MAT, and common 2-D formats.

---

## FilePreview

Double-click in Explorer or open the toolbox to inspect:

- Text / code / markdown
- Tables
- 2-D images
- Volumes (slice, window/level, basic transforms)

Preview is read-only — use ImportData or scripts when you need workspace variables.

---

## Plugin contract (for authors)

Built-in toolboxes implement `BaseToolboxPlugin` with:

| Method | Purpose |
| --- | --- |
| `get_name()` / `get_version()` / `get_description()` / `get_author()` | Metadata |
| `get_toolbox_class()` | Widget class to instantiate |
| `initialize(app_context)` | Receive the running app |
| `create_instance(...)` | Build the widget |
| `cleanup()` | Release resources |

For third-party tools, prefer the **extension** system (`ExtensionInterface` + `extension.json`) instead of adding a core toolbox.

---

## Related pages

- [User Interface](User-Interface)
- [Workspace and Data](Workspace-and-Data)
- [Extensions](Extensions)
