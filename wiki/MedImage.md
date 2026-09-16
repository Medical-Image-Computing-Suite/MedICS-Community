# MedImage

`MedImage` (`medics.core.medimage`) is the **canonical medical-image data model and data bus** of MedICS. File I/O, preview, toolboxes, AI models, and scripts converge on this one type.

---

## Why it exists

Before `MedImage`, an image was often a bare `numpy.ndarray`. Axis meaning, spacing, modality, and annotations lived in side variables or conventions. That made round-trips lossy and plugins fragile.

`MedImage` keeps those facts attachable and explicit:

```python
from medics.core.medimage import MedImage, SpatialGeometry, ImageMetadata

image = MedImage.from_numpy(
    volume,                                    # numpy array
    dims=("bscan", "depth", "aline"),          # what each axis means
    geometry=SpatialGeometry(
        spatial_dims=("bscan", "depth", "aline"),
        spacing=(0.0468, 0.0039, 0.0117),      # mm per voxel
        coordinate_system="LPS",
        units=("mm", "mm", "mm"),
    ),
    metadata=ImageMetadata(modality="OCT"),
)
```

Pixels, axis semantics, geometry, modality, annotations, predictions, and processing history travel together.

---

## Design principles

| Principle | In practice |
| --- | --- |
| Canonical interchange | One type flows through I/O → preview → processing → export |
| Unified representation | 2D, 3D, 4D, OCT, and OCTA share the same class |
| Explicit dimensions | Named axes (`z`, `bscan`, `aline`, …) instead of positional convention |
| Physical geometry | Spacing, origin, direction, coordinate system |
| Typed metadata | Structured `ImageMetadata`, PHI-aware context when needed |
| First-class annotations | Masks, contours, layer boundaries, model outputs |
| Provenance | Transforms record what happened |
| Lazy backends | Memmap / Dask / Torch — pixels need not all sit in RAM |
| Framework-neutral | No Qt at import time — NumPy is the hard dependency |

---

## Backward compatibility

Legacy formats keep working. Compatibility lives under `medics.core.medimage.legacy` and activates at the boundaries.

| Legacy representation | Bridge |
| --- | --- |
| Untyped `numpy.ndarray` volumes | `from_legacy_array` / `to_legacy_array` |
| Retinal-layer “curve dicts” | `apply_curve_dict` / `extract_curve_dict` |
| Integer label maps + colormaps | `label_map_to_annotation` / `annotation_to_label_map` |
| `permute` / `flip` orientation specs | `apply_legacy_orientation` |
| `.med` (HDF5) files and workspaces | transparent envelope in `FileIO` |
| `DataDict` workspaces | Unchanged — images are values in the workspace |

```python
from medics.core.medimage import from_legacy_array, to_legacy_array

image = from_legacy_array(volume, modality="OCT", oct=True)
assert (to_legacy_array(image) == volume).all()  # exact round-trip
```

---

## Selecting data

```python
# Index by axis name
subset = image.sel(bscan=slice(0, 10))
```

Prefer named selection over hard-coded axis positions when writing extension or script code.

---

## Related pages

- [Workspace and Data](Workspace-and-Data)
- [Architecture](Architecture)
- Upstream design notes in the MedICS repo: `docs/medimage.md`
