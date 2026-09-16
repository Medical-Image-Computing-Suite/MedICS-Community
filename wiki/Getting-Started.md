# Getting Started

Install MedICS, launch the desktop app, and complete a basic workflow.

---

## Requirements

- **Python 3.11** or later
- A supported OS: **Windows**, **macOS**, or **Linux**
- Scientific stack (NumPy, SciPy, scikit-image, pydicom, h5py, PySide6, …) — installed automatically with the package

---

## Install

### From PyPI

```bash
pip install medics
```

### Verify

```bash
python -c "import medics; print(medics.__version__)"
medics --help
```

---

## Launch

```bash
medics
# or
python -m medics
```

Useful commands:

```text
medics                              Start the application
medics --create-ext [NAME] [DIR]    Scaffold a new extension
medics --build-ext [OPTIONS]        Build an extension wheel
medics --version, -V                Print the installed version
medics --help                       Show CLI help
```

Full CLI details: [CLI Reference](CLI-Reference).

---

## Basic workflow

1. **Open a folder** — `File → Open Folder`, or use the folder button in the Explorer dock.
2. **Preview files** — Double-click a file in Explorer, or use **FilePreview**. Images, DICOM/NIfTI volumes, tables, markdown, and code open in tabs.
3. **Import data** — Open the **ImportData** toolbox (`Toolboxes` menu). Drag files or folders, or browse a DICOM series. Imported arrays appear in the Variables dock and in Jupyter.
4. **Analyze** — Write scripts in **PyEditor**, or run code in the **Jupyter** tab. Both share the workspace namespace.
5. **Save** — `File → Save Workspace` writes variables to a `.med` (HDF5) file. Auto-save can be enabled in settings.

---

## First look at the window

| Region | Purpose |
| --- | --- |
| Left docks | File Explorer, activity bar for toolboxes |
| Center | Tabbed toolboxes and previews |
| Right docks | Variables / workspace inspector |
| Bottom | Jupyter console, terminal, logs |

See [User Interface](User-Interface) for a full layout guide.

---

## Next steps

- Learn the [workspace model](Workspace-and-Data)
- Understand [`MedImage`](MedImage)
- Install an [extension](Extensions)
- Tune [configuration](Configuration)
