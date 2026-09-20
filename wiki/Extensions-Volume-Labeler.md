# Volume Labeler

**Volume Labeler** (`medics-ext-volume-labeler`) is the official MedICS extension for annotating **3D volumetric data** — OCT volumes and similar stacks. Paint labels on B-frames or the enface projection, constrain work to a retinal slab with boundary curves, inspect the result in a 3D view, and export label maps for training, measurement, or later editing.

![Volume Labeler icon](https://raw.githubusercontent.com/Medical-Image-Computing-Suite/medics-ext-volume-labeler/main/medics_ext_volume_labeler/icon.png)

| | |
| --- | --- |
| **Package** | `medics-ext-volume-labeler` |
| **Extension name** | Volume Labeler |
| **Version** | 1.0.0 |
| **Category** | Medical Imaging |
| **Capabilities** | `ui`, `workspace` |
| **Requires** | MedICS `>=2026rc0`, SDK `>=2026.7.7` |
| **Source** | [medics-ext-volume-labeler](https://github.com/Medical-Image-Computing-Suite/medics-ext-volume-labeler) |

---

## Install and open

```bash
pip install medics-ext-volume-labeler
medics
```

1. Launch MedICS.
2. Open **Volume Labeler** from the **Extensions** menu.
3. The tab opens immediately; the panels fill in on the next event-loop ticks.

See [Official Extensions](Official-Extensions) for install, update, and requirement details.

---

## Interface

```text
┌──────────────┬─────────────────────────────────────────────────────────┐
│ Left panel   │ Toolbox (brush, thresholds, Propagation, Value, Note)   │
│ Load / maps  ├──────────────────┬──────────────────┬───────────────────┤
│ / labels     │ B-frame A        │ B-frame B        │ Boundaries        │
│              │                  │                  │ Upper / Lower /   │
│              │                  │                  │ Frame             │
│              ├──────────────────┴──────────────────┴───────────────────┤
│              │ Enface projection                                       │
│              │ 3D Viewer (label volume)                                │
└──────────────┴─────────────────────────────────────────────────────────┘
 Status bar: volume shape, dtype, counts, second volume info, mouse / pixel values
```

| Area | What it is |
| --- | --- |
| **Left panel** | Load volume / boundaries / labels; manage label maps and label classes |
| **Toolbox** | Painting tools, tool size and shape, propagation step, measurements, notes |
| **B-frame A** | Left cross-section: first volume underlay, optional second volume overlay, labels |
| **B-frame B** | Right cross-section: primary first volume and labels |
| **Boundaries** | Upper / Lower slab layers, offsets, and the current frame index |
| **Enface** | Top-down projection through the slab; painting here labels whole columns |
| **3D Viewer** | Discrete 3D rendering of the active label map |
| **Status bar** | Loaded volume info, mouse position, and short status messages |

Typical width balance: B-frame A ≈ B-frame B ≈ enface / 3D column.

---

## Quick start

1. Click **Load Data…** and choose a volume (or drag a file onto the window).
2. Optionally load **boundaries** and / or a **label map** — sidecars next to the volume are auto-detected.
3. In the left panel, select a **label map** and a **label** class (colour).
4. Choose **Brush** (or another tool) and paint on B-frame B, B-frame A, or the enface.
5. Step through frames with the frame spinbox or the arrow keys.
6. Check **Value** (measurements) and the **3D Viewer**.
7. Click **Save…** or **Save to WS** to store your maps.

---

## Loading data

### Volume

**Load Data…** opens a file dialog. Supported families include:

- `.med`, `.tif` / `.tiff`, `.mat`
- OCT-oriented: `.oct`, `.ooct`, `.ioct`, `.dcm`, `.img`

You can also **drag and drop** files or folders onto the window, or drop a **workspace** variable when MedICS provides that MIME type.

If a volume is already open, you are asked what to do:

| Choice | Effect |
| --- | --- |
| **Replace** | Clears the current labels for that session and loads the new volume |
| **Overlay** | Keeps the current volume data and uses the new file as an overlay on top of it |
| **Cancel** | Does nothing |

**Settings…** opens the loader settings dialog, used with custom MedICS volume / label loader modules. Loader functions are discovered from the shared user folder `~/.medics/customDataLoader/`, so the same loaders work across extensions.

### Automatic companions

When a volume loads, the extension looks next to it for:

| Sidecar | Purpose |
| --- | --- |
| `<base>_lmp.tiff` / `<base>_lmp.med` | Label map (newest wins when both exist) |
| `seg.mat`, `_seg.mat`, `segmentation.mat`, and `.med` variants | Layer curves for Upper / Lower boundaries |
| `<base>.ssada`, `<base>.second volume`, `<base>_second volume.*` | Second volume overlay (e.g. angiography) |

### Boundaries

Use **Load Boundaries…** (`*.json`, `*.mat`, `*.med`, `*.dcm`), then pick the **Upper** / **Lower** layer names and set **+** offsets in pixels.

The slab between Upper and Lower drives the enface projection and the slab visualisation on the B-frames. Changing a layer or an offset refreshes the enface after a short delay.

### Label maps

**Load Label Map…** accepts `*.tiff` / `*.tif`, `*.med`, `*.mat`, `*.png`.

MAT / MED files written by this extension store data under a top-level **`label`** tag. Older `volumelabeler` layouts are still recognised. Files written by the extension carry `app_name = "medics-ext-volume-labeler"`, so a later load recognises them and skips the field picker.

---

## Label maps and label classes

### Maps

- Default map name: **Default**
- **Add…** creates another named map
- Selecting a map in the tree makes it the map you paint into
- **Delete** removes a map — at least one map must remain

Each map is a full 3D label volume aligned with the first volume shape `(frames × depth × A-scans)`.

### Label classes

The **Label** tree lists paint classes (name, colour, edit):

- Click a row to set the **active paint label**
- Use the colour button or **Edit** to change name / colour / description

Painting writes that class index into the active map.

---

## Painting tools

Configure tools in the top **toolbox**, then paint on B-frame A, B-frame B, or the enface.

| Tool | Hotkey | Use |
| --- | --- | --- |
| **Brush** | `Q` | Paint the active label |
| **ChangeLabel** | `W` | Change existing labels under the cursor |
| **T-Min** | `E` | Label voxels darker than the clicked value (+ offset) |
| **T-Max** | `R` | Label voxels brighter than the clicked value (+ offset) |
| **T-Range** | `T` | Label voxels within a value window around the click |

### Shared options

| Control | Meaning |
| --- | --- |
| **Tool size** | Brush diameter in pixels |
| **Shape** | `disk`, `square`, or `rod` |
| **Angle** | Orientation for rod and related shapes |
| **Fill holes** | Fill holes smaller than N pixels |
| **Region filter** | Remove connected regions smaller than N pixels |
| **Propagation** | Step size for the `←` / `→` frame shortcuts |

### Per-viewer controls

On each viewer you can **Show / Hide** the label overlay, adjust **transparency**, tune contrast with the low / high spinboxes, and use the colorbar. The **B-frame A** colorbar controls the second volume overlay colormap; the **B-frame B** colorbar controls first volume display contrast.

### Enface painting

The enface shows a projection of the first volume (and labels) through the current slab.

- Projection modes: **Mean**, **Maximum**, **Minimum**, **Thickness**
- Painting here updates the 3D label volume along depth (synced in the background)
- The yellow line marks the current B-frame — drag it to change frame

---

## Frame navigation

| Control | Action |
| --- | --- |
| **Frame** spinbox | Jump to a 1-based frame index |
| `↑` | Previous frame (−1) |
| `↓` | Next frame (+1) |
| `←` | Jump back by **Propagation** frames |
| `→` | Jump forward by **Propagation** frames |
| Hold `Space` | Temporarily hide label overlays on the B-frames and enface |

Shortcuts apply while the Volume Labeler tab is focused and are ignored while typing in text fields or spin boxes.

---

## 3D Viewer

The 3D view renders the **active label map**, not the raw volume intensities.

| Control | Options |
| --- | --- |
| Lighting | **Headlight**, **Three Lights**, **Ambient**, **Studio** (default) |
| **Reset Camera** | Restore a default view |

Labels touching the volume edge are rendered with a transparent pad so outer faces do not appear black. Enface-sized volumes are shown with a square lateral aspect in 3D, matching the squared enface view.

---

## Measurements and notes

- **Value** tab — per-label **Volume (voxels)** and **Area (pixels)** for the active map, with percentages
- **Note** tab — free text stored alongside the label maps when you save

Measurements refresh as you edit labels, using light background processing.

---

## Saving

### Save…

Opens **Save Label Map As** with:

| Format | Content |
| --- | --- |
| **TIFF** (`.tiff` / `.tif`) | All maps stacked along the frame axis, plus colormap and description metadata (`app_name`, `map_names`, `total_maps`) |
| **MAT** (`.mat`) | Dict under tag **`label`**: `maps`, `labels`, `notes`, `map_descriptions`, `app_name` |
| **MED** (`.med`) | The same **`label`** payload in MedICS HDF5 form |

The default name is `<volume_basename>_lmp`, with the suffix taken from the chosen save filter.

### Save to WS

Prompts for a workspace variable name (default: the currently selected label map name, dialog centred on the main window) and stores the current maps under that variable.

---

## Status bar

With a volume loaded you will see something like:

```text
Vol 1/1  |  Shape: 128 × 640 × 512  |  dtype: float32  |  range: [0, 255]  |  second volume: …
```

Mouse position and pixel / index values update as you move over the B-frames or the enface. Short messages appear for load / save and drag-and-drop hints.

---

## Tips and troubleshooting

| Topic | Tip |
| --- | --- |
| Nothing paints | Select a **label** class and enable a tool (**Brush**, …); make sure the label overlay is visible |
| Enface looks stretched | Non-square volumes are upsampled to a square for display; painting maps back to native size |
| Wrong slab / empty enface | Check the Upper / Lower layers and offsets; load a valid boundary file |
| Black 3D faces | Try **Reset Camera** or **Ambient** lighting |
| Shortcuts ignored | Click inside the Volume Labeler tab (not a text field) |
| Second volume | Prefer **Overlay** to keep the first volume and add flow / angiography on B-frame A |
| Custom loaders | Put `.py` loader functions in `~/.medics/customDataLoader/` and pick them in **Settings…** |

---

## Requirements

- Python ≥ 3.11
- MedICS `>=2026rc0`, SDK `>=2026.7.7`

---

## Related pages

- [Official Extensions](Official-Extensions)
- [Extensions](Extensions)
- [Workspace and Data](Workspace-and-Data)
- [MedImage](MedImage)
- [Toolboxes](Toolboxes)
