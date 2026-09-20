# Measurement

**Measurement** (`medics-ext-measurement`) is the official MedICS extension for measuring images and volumes: draw a ROI, measure it, read the numbers with their units, export them — and let the agent do the same thing on the same session.

It is built on `medics.core.measurement`, so all **53 registered measurement types** work, including the calibration-aware ones. The extension is a **view and interaction layer**: it owns drawing, selection, presentation, and session state, and re-implements no measurement maths.

| | |
| --- | --- |
| **Package** | `medics-ext-measurement` |
| **Extension name** | Measurement |
| **Version** | 1.0.0 |
| **Category** | Analysis |
| **Capabilities** | `ui`, `agent`, `workspace`, `measurement`, `results` |
| **Input / output** | `MedImage` → `ResultsDataset` |
| **Requires** | MedICS `>=2026rc0`, SDK `>=2026.7.7` |
| **Source** | [medics-ext-measurement](https://github.com/Medical-Image-Computing-Suite/medics-ext-measurement) |

---

## Install and open

```bash
pip install medics-ext-measurement
medics
```

MedICS must be installed in the same environment — the extension declares it as a dependency and imports `medics.core`.

Then open **Measurement** from the **Extensions** menu (category **Analysis**). See [Official Extensions](Official-Extensions) for install / update details.

---

## Interface

The window is a `QSplitter` on both axes, so the palette and the right-hand panels can be collapsed; the canvas keeps the majority of the space because that is where the work happens.

```text
+--------------------------------------------------------------------------+
| Calibration bar:  8-bit 2-D  |  px, px  (state: unknown - pixel units)   |
|                   [ Set scale... ]   [ Output unit: (px) v ]             |
+---------------+--------------------------------------+-------------------+
| Tool palette  |            Measurement canvas        | Measurement panel |
|               |                                      |                   |
| Geometry      |   pyqtgraph GraphicsLayoutWidget     | [ ] area      px  |
|  o Point      |   + ImageItem (displayed slice)      | [ ] perimeter px  |
|  / Line       |   + ROI handles for each ROI         | [ ] mean      -   |
|  \ Polyline   |   + measurement overlay labels       | [ ] volume    mm3 |
|  [] Rect      |   + crosshair / cursor read-out      | ... 53 rows       |
|  O Ellipse    |                                      | search / filter   |
|  # Polygon    |                                      |-------------------|
|  B Box3D      |                                      | Results           |
|  @ Sphere     |                                      | name | value | unit|
|               |                                      |------+-------+----|
| Slice         |                                      | area | 12.4  | mm2|
|  [axial v]    |                                      | mean | 88.1  | -  |
|  z ====o===   |                                      |                   |
|  [ play ]     |                                      |[Send to Batch Results][Export...]|
+---------------+--------------------------------------+-------------------+
```

| Area | What it is |
| --- | --- |
| **Calibration bar** | Data summary, calibration state, **Set scale…**, and the **Output unit** selector |
| **Tool palette** | ROI tools (2-D and 3-D), **Finish** / **Cancel**, **Box depth**, processing steps, slice / plane controls |
| **Canvas** | pyqtgraph canvas with the displayed slice, ROI handles, and measurement overlay labels |
| **Measurement panel** | Engine-driven checklist of measurement types with search / filter, enablement reasons, and units |
| **Results** | Table of the current results with **Send to Batch Results** and **Export…** |

### Volume workspace

3-D subjects open a four-panel workspace — **Axial**, **Sagittal**, **Coronal**, and a **VTK 3-D** view — instead of the single 2-D canvas, so ROIs can be authored and inspected on all three planes. Loaded 2-D images use the single-plane canvas.

---

## Loading data

Four routes, all ending in the same subject:

- **Load file…** — pick a 2-D image or 3-D volume from disk
- **Drag and drop a file** onto the window
- **Drag and drop a workspace variable** (`ws.name`)
- **Load WS** — load the variable selected in the **Subject** combo

Images loaded while the tab is open also appear in the subject list, because the extension subscribes to both `variable_changed` and `workspace_updated`. Loaded files are registered in the workspace when possible.

The subject combo shows the workspace image / volume variables; the hint line under it tracks the loaded subject and the latest action.

---

## ROI tools

Tools come from the extension's `SHAPE_SPECS`, matching the vocabulary the measurement engine accepts.

| Tool | Geometry | Gesture |
| --- | --- | --- |
| **Point** | `Point` | Click to place a point |
| **Points** | `MultiPoint` | Click each point; `Enter` or double-click finishes (angle needs 3 points) |
| **Line** | `Line` | Drag from start to end — measures distance |
| **Polyline** | `Polyline` | Click a path; `Enter` or double-click finishes — measures path length |
| **Rect** | `Rectangle` | Drag a rectangle |
| **RRect** | `RotatedRectangle` | Drag a rectangle, then drag the rotation handle |
| **Ellipse** | `Ellipse` | Drag from the centre outwards |
| **Polygon** | `Polygon` | Click each vertex; `Enter` or double-click finishes |
| **Box3D** | `Box` | Drag in-plane, then set the **Box depth** (slices) — needed for volume |
| **Sphere** | `Sphere` | Drag centre then radius — needed for volume |

- Shapes with a natural gesture are drawn with one press–drag–release; open-ended chains are clicked and finished with **Finish**.
- **Box3D / Sphere** unlock on volumes, so volume-level analysis (`volume`, voxel counts, 3-D medical types) can run against a Box or Sphere ROI. They are greyed out on 2-D data rather than offered and then refused.
- **Right-click** undoes the last vertex; **middle-click** or `Esc` leaves add mode.

### Editing ROIs

Drag a ROI to move it, drag a handle to resize, rotate a rotated rectangle, or drag a polygon vertex. Each edit goes to the session immediately and re-measures — and it invalidates any measurement still running, so a slow batch cannot publish numbers for a shape that no longer exists. Hover a ROI and press `Delete` (`Backspace`) to remove it, or use the right-click delete.

Mask and label-map ROIs are shown **read-only**, because an editable rectangle around a mask would falsely imply it can be resized.

---

## Measurements

The checklist is generated from the engine rather than hard-coded, so any type registered by another extension appears automatically. The engine catalogues **53 types across 9 categories**: geometry, spatial, intensity, morphology, mask, medical, AMD, ETDRS, OCTA.

The interactive panel shows the basic groups — **geometry**, **spatial**, **intensity**, **morphology**, **texture**, **relational**. Specialty ophthalmology and mask groups stay registered for agents and medical workflows but are hidden from the interactive basics checklist.

Two behaviours worth knowing:

- **Every row says why it cannot run.** Rows are enabled or disabled against the current ROI geometry, the data dimensionality, the calibration, and mandatory parameters, with the reason attached (shown as the row tooltip).
- **Relational measurements need a second ROI.** Types such as `intersection`, `union`, `overlap`, `iou`, `dice`, `containment`, and `centroid_distance` are greyed out until a partner ROI exists; the session injects one automatically once two or more shapes are drawn.

### Calibration and units

- **Set scale…** opens the host's calibration dialog (the same "use this drawn line as the known distance" flow as ImageJ), or accept FOV ÷ pixels.
- A **physical unit** is offered only when the calibration justifies it; the output-unit selector reflects that.
- Mixed selections are **split by quantity dimension** (length / area / volume) so the numbers stay correct.

### Running measurements

Press **Measure**, or tick **Auto-measure** to re-run the ticked measurements whenever a ROI is drawn / edited or the image processing changes.

A batch over a 3-D mask can take seconds, so it runs on a **worker thread** and the window stays usable. Each run carries a token: if the state changes while it is running — you draw a ROI, load a subject, move the slice — the result is **discarded** rather than rendered, because a number describing a state you are no longer looking at is worse than no number.

---

## Image processing

An optional per-subject pipeline pre-processes the displayed data before measuring. Toolbar and menu operations:

| Operation | Parameters |
| --- | --- |
| **Gaussian** | σ (px) |
| **Median** | size (px) |
| **Mean** | size (px) |
| **Sharpen** | σ, amount |
| **Edges** | method (e.g. `sobel`), σ |
| **Invert** | — |
| **Normalize** | method (`minmax`, …) |
| **Threshold** | method (`otsu`, `manual`, …), value for manual |
| **Custom** | a user `process(image, **params)` function |

Steps are listed with their live label (for example `Gaussian σ=1 px`), can be toggled, re-parameterised, reset, or deleted. **Preview** shows the Python code for the current pipeline and **Export** saves it as a standalone script, so what you did interactively can be reproduced in code.

---

## Results

- The **Results** table shows name / value / unit for the latest run; the header counts the results.
- **Send to Batch Results** copies the table into the host's shared bottom **Results** tab (`View → Results`), which also carries the calibration-staleness columns and the recompute hint.
- **Export…** writes the results in any host-supported format: **CSV**, **JSON**, **JSONL**, **Parquet**, **Excel**.

Nothing is aggregated or reformatted privately: the extension reuses the host's results engine and export formats.

---

## Agent interface

The extension exposes its own tools, and — because it shares the host's ROI scope — the host's existing `create_roi` / `measure_image` / `roi_*` skills operate on the same session. So "have the agent draw a ROI" needs no new tool at all: the ROI appears in this panel as soon as it is created.

**Module-level tools** (work with no window open):

`measurement_session_state`, `measurement_list_subjects`, `measurement_open_subject`, `measurement_calibration`, `measurement_set_calibration`, `measurement_add_roi`, `measurement_select_roi`, `measurement_available`, `measurement_run`, `measurement_last_results`, `measurement_aggregate`, `measurement_derived`, `measurement_export`.

**Window-driving tools:**

`measurement_open_window`, `measurement_set_tool`, `measurement_goto`, `measurement_run_selected`.

Notes:

- **`measurement_aggregate`** reduces the current collection with an engine-provided statistic (`mean`, …), optionally grouped.
- **`measurement_derived`** evaluates an expression over the last results, e.g. `area / perimeter`.
- **`measurement_export`** requires a path and uses the host's export formats.
- Every tool returns **JSON text** with an `ok` field. That is a correctness requirement rather than a style choice: `SkillRegistry.invoke` stringifies the result and parses it as JSON to decide whether the call failed, so a tool returning a `dict` would be recorded as a success even when it failed.

---

## Keyboard and mouse

| Input | Action |
| --- | --- |
| `←` / `→` | Step one slice |
| `↑` / `↓` | Step five slices |
| `Enter` | Finish an open-ended shape |
| `Esc` | Cancel the current add, or exit add mode |
| `Delete` / `Backspace` | Delete the hovered ROI |
| Right-click | Undo the last vertex; also opens the ROI delete menu |
| Middle-click | Exit add mode |

---

## What it deliberately does not do

- Re-implement measurement maths, ROI geometry, calibration, or results aggregation.
- Expose a second copy of the host's `list_measurements` / `create_roi` / `measure_image` skills — it adds session, subject, calibration, and GUI semantics instead.
- Build its own results table — it pushes into the host's shared Results tab.
- Invent a scale dialog — it opens the host's.

---

## Notes from the design review

Irregularities found in the host while building this extension, recorded rather than worked around (the extension does not modify them):

| Topic | Detail |
| --- | --- |
| `area` vs `pixel_count` | `area` uses closed-form geometry; `pixel_count` rasterises on the *inclusive* integer lattice, so a 10×10 rectangle reports `area` 100.0 px² but `pixel_count` 121, and a 1×1 reports 1.0 vs 4. The panel shows both and does not present them as interchangeable. |
| Layer measurements | `retinal_thickness`, `layer_thickness`, and `layer_area` declare `requires_roi=False` but raise `UnsupportedROI` unless given a mask / label-map ROI or explicit `upper` / `lower` boundaries. Enablement here treats them as ROI-or-boundaries required. |
| Per-measurement unit overrides | `overrides={"area": {"output_unit": "mm2"}}` has no effect because no built-in measurement reads `parameters["output_unit"]`, while a blanket `output_unit` on a mixed selection raises `IncompatibleUnit`. Hence the quantity-dimension grouping in the UI. |
| 3-D ROI authoring | `SpatialReference.from_image` defaults to the `pixel` system whose `default_dimension` is 2, so a `Box` or `Sphere` ROI is refused with "3-D geometry is incompatible with a 2-D spatial reference". The extension supplies unit spacing explicitly for 3-D geometry. |

---

## Development

Run the widget with no MedICS installed — a mock host, synthetic subjects, a real window:

```bash
python scripts/simulate_host.py
python scripts/simulate_host.py --smoke            # build, measure, verify, exit
python scripts/simulate_host.py --subject volume_3d

pytest tests -q
```

Most of the test suite is Qt-free: `session.py`, `catalogue.py`, and `geometry.py` hold the majority of the logic and import no Qt at all, and `tests/test_import_without_qt.py` proves it in a subprocess with every Qt binding blocked.

Release builds are **Cython-protected** wheels (compiled modules, no `.py` source) for Linux (manylinux, `auditwheel`-repaired), macOS, and Windows, driven by the shared `Publish[platforms;pythons]` workflow grammar.

---

## Requirements

- Python ≥ 3.11
- MedICS `>=2026rc0`, SDK `>=2026.7.7`
- License: MIT

---

## Related pages

- [Official Extensions](Official-Extensions)
- [Extensions](Extensions)
- [MedImage](MedImage)
- [Workspace and Data](Workspace-and-Data)
- [Events and Data Flow](Events-and-Data-Flow)
