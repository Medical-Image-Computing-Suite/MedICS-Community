# Workspace and Data

MedICS keeps in-memory data in a shared **workspace**. Python editors, Jupyter, toolboxes, and extensions all see the same variables.

---

## Workspace model

- The workspace is a nested dictionary-like structure (`DataDict`).
- Each top-level key is a **variable name** (for example `oct_volume`, `labels`).
- Values are typically NumPy arrays, nested dicts, or **`MedImage`** objects.
- Updates emit a `workspace_updated` event so docks and views refresh.

### Save / load

| Action | Result |
| --- | --- |
| **Save Workspace** | Writes variables to a `.med` file (HDF5) |
| **Load Workspace** | Restores variables from `.med` |
| **Auto-save** | Optional periodic save (see `[Application] auto_save_workspace`) |

---

## Opening folders

`File → Open Folder` sets the current project folder used by:

- File Explorer
- Relative paths in scripts
- Some extension workflows

---

## Supported image / data formats

Via `FileIO` and built-in toolboxes:

| Family | Examples |
| --- | --- |
| DICOM | Including JPEG 2000 / OCT series |
| Volumes | TIFF stacks, NIfTI (`.nii` / `.nii.gz`) |
| MedICS | `.med` (HDF5 workspace / data), `.medimage` bundles |
| Scientific | MATLAB `.mat`, NumPy, HDF5 |
| Images | PNG, JPEG |
| Video | `.mp4`, `.avi`, `.mkv`, `.mov`, `.webm`, … |

---

## Importing data

Use the **ImportData** toolbox:

1. Open **Toolboxes → ImportData** (or the activity-bar icon).
2. Drag files/folders, or browse a DICOM series.
3. Preview loads in the background with progress.
4. Confirm import — arrays appear under **Variables** and in Jupyter.

See [Toolboxes](Toolboxes).

---

## Previewing files

Double-click in Explorer or use **FilePreview**:

- Text, markdown, code
- Tables / spreadsheets
- 2-D images
- Volumes (slice navigation, window/level)

---

## Working from Python

In **PyEditor** or **Jupyter**, workspace variables are available in the shared namespace. Prefer wrapping volumes as [`MedImage`](MedImage) when you need geometry, annotations, or provenance:

```python
from medics.core.medimage import MedImage, SpatialGeometry, ImageMetadata

image = MedImage.from_numpy(
    volume,
    dims=("bscan", "depth", "aline"),
    geometry=SpatialGeometry(
        spatial_dims=("bscan", "depth", "aline"),
        spacing=(0.0468, 0.0039, 0.0117),
        coordinate_system="LPS",
        units=("mm", "mm", "mm"),
    ),
    metadata=ImageMetadata(modality="OCT"),
)
```

Legacy bare arrays still work through compatibility helpers (`from_legacy_array` / `to_legacy_array`).

---

## Related pages

- [MedImage](MedImage)
- [Events and Data Flow](Events-and-Data-Flow)
- [Configuration](Configuration)
