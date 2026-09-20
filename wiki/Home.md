# MedICS Community Wiki

Welcome to the **Medical Image Computing Suite (MedICS)** documentation wiki.

MedICS is a cross-platform desktop environment for medical image visualization and analysis. It combines a scientific Python workspace, built-in toolboxes, and a pip-installable extension system in one application.

**Python 3.11+** · **Windows / macOS / Linux** · **Qt 6**

---

## Start here

| Page | What you will learn |
| --- | --- |
| [Getting Started](Getting-Started) | Install, launch, and run a basic workflow |
| [User Interface](User-Interface) | Main window layout, docks, tabs, and menus |
| [Workspace and Data](Workspace-and-Data) | Variables, `.med` workspaces, and file I/O |
| [MedImage](MedImage) | The canonical medical-image data model |
| [Toolboxes](Toolboxes) | PyEditor, ImportData, FilePreview |
| [Extensions](Extensions) | Install, create, and publish extensions |
| [Official Extensions](Official-Extensions) | Index of MedICS Team extensions |
| [Volume Labeler](Extensions-Volume-Labeler) | 3D volume annotation: paint labels, slabs, 3D view, export |
| [Measurement](Extensions-Measurement) | Draw ROIs, 53 measurement types, calibration-aware units, export |
| [Configuration](Configuration) | `config.ini` reference (theme, window, chat, …) |
| [Architecture](Architecture) | High-level design and startup lifecycle |
| [CLI Reference](CLI-Reference) | `medics` command-line options |
| [Events and Data Flow](Events-and-Data-Flow) | EventBus catalog and common data paths |

---

## What MedICS is for

Typical work happens in a single window:

- **File Explorer** for the current folder
- **Central tabs** for toolboxes (editor, importer, preview, extensions)
- **Variables** dock for the in-memory workspace
- **Bottom panel** for Jupyter, terminal, and logs

Data lives in a shared workspace (`DataDict`) and can be saved as a `.med` file (HDF5). Scripts in **PyEditor** and the embedded **Jupyter** console see the same variables.

Images in that workspace are represented by **[`MedImage`](MedImage)** — pixels, geometry, metadata, annotations, and provenance travel together as one object.

---

## Quick install

```bash
pip install medics
medics
```

See [Getting Started](Getting-Started) for requirements, verification, and a first workflow.

---

## Scope of this wiki

This wiki documents the **MedICS main application** for end users and extension authors.

> **Note:** License / authorization / payment features are **not** covered in the current wiki version.

---

## Related links

- Source (main app): [Medical-Image-Computing-Suite/MedICS](https://github.com/Medical-Image-Computing-Suite/MedICS)
- Community home: [Medical-Image-Computing-Suite/MedICS-Community](https://github.com/Medical-Image-Computing-Suite/MedICS-Community)
- Website: [medical-image-computing-suite.github.io](https://medical-image-computing-suite.github.io/)
