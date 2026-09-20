# Volume Viewer

**Volume Viewer** (`medics-ext-volume-viewer`) is the official MedICS extension for **GPU-accelerated 3D visualization** of medical volumes: overlay several datasets, switch among volume / surface / mesh / slice rendering, crop with interactive clip widgets, and export snapshots or camera-path movies.

| | |
| --- | --- |
| **Package** | `medics-ext-volume-viewer` |
| **Extension name** | Volume Viewer |
| **Version** | 1.0.0 |
| **Category** | Visualization |
| **Capabilities** | `ui`, `workspace` |
| **Requires** | MedICS `>=2026rc0`, SDK `>=2026.7.7` |
| **Source** | [medics-ext-volume-viewer](https://github.com/Medical-Image-Computing-Suite/medics-ext-volume-viewer) |

---

## Requirements

- MedICS (host application)
- Python 3.11, 3.12, or 3.13
- A **GPU is recommended**. CPU rendering works but is slower on large volumes.

```bash
pip install medics-ext-volume-viewer
```

Then start MedICS and open **Volume Viewer** from the **Extensions** menu (category **Visualization**). See [Official Extensions](Official-Extensions) for install / update details.

---

## Window layout

```text
┌───────────────────────────────────────────┬─────────────────────┐
│ File | Display | Settings                 │ Volume Items        │
│ Load / snapshot / movie                   │ search, sort, show  │
├───────────────────────────────────────────┼─────────────────────┤
│                                           │                     │
│              3D View                      │  Volume list        │
│         (VTK GPU renderer)                │  (one card per      │
│                                           │   loaded volume)    │
│                                           │                     │
└───────────────────────────────────────────┴─────────────────────┘
 Status bar
```

| Area | What it is |
| --- | --- |
| **Toolbar** | **File**, **Display**, and **Settings** tabs |
| **Volume Items** | Search, expand / collapse, sort, and show / hide all volumes |
| **3D View** | Interactive GPU rendering of every loaded volume |
| **Volume list** | Independent appearance, clipping, and transform controls per volume |

---

## Load data

### From a file

**File → Load Volume…** opens a file dialog.

| Format | Extensions |
| --- | --- |
| NIfTI | `.nii`, `.nii.gz` |
| NRRD | `.nrrd` |
| MetaImage | `.mhd`, `.mha` |
| DICOM | `.dcm` |
| TIFF stack | `.tif`, `.tiff` |
| MATLAB | `.mat` |
| MedICS HDF5 | `.med` |
| OCT / angiography | `.foct`, `.octa`, `.ssada` |

A progress bar appears in the status bar while the file is read. The new volume is **added** to the list; existing volumes stay loaded.

For `.mat` and `.med` files the file must contain a 3-D array; keys such as `oct`, `octa`, `volume`, `data`, or `image` are tried.

### From an image sequence

**File → Load Image Sequence…** builds one volume from many 2-D files.

- Select PNG, JPEG, TIFF, BMP, GIF, WebP, PPM, or DICOM frames.
- Files are stacked in **natural filename order** (`slice_2` before `slice_10`).
- Multi-page TIFF / GIF files contribute every frame.
- A DICOM series is read with spacing and origin preserved when possible.

### Drag and drop

Drop onto the Volume Viewer window:

- **Files or folders** from the desktop or file manager. The first loadable file in a folder is used — not every file.
- **Workspace variables** from the MedICS variable tree (`ws.<name>`). 3-D NumPy arrays become volumes.

### From the workspace

Volumes can also go the other way: the **📥** button on a volume card saves the current voxel data as a MedICS workspace variable. See [Volume list](#volume-list).

---

## Navigate the 3D view

| Action | Control |
| --- | --- |
| Rotate | Left-drag |
| Pan | Right-drag |
| Zoom | Mouse wheel |
| Context menu | Right-click **without** dragging |

### Right-click menu

- **Default View** — reset the camera so all volumes fit in the window.
- **Trackball** — show or hide the camera-orientation widget in the corner of the 3D view.
- **Bounding Box** — show or hide the scene bounding box.
- **Save Snapshot** — same as **File → Save Snapshot…**.

A camera-orientation widget is on by default, so you can tell which way the volume is facing.

---

## Volume list

Each loaded volume has a card on the right.

### Header (always visible)

| Control | What it does |
| --- | --- |
| ⋮⋮ | Drag to reorder. Order is the rendering order (later items draw on top). |
| ▼ / ▶ | Expand or collapse appearance controls. |
| Name | File or variable name. |
| ◉ | Show / hide this volume in the 3D view. |
| 📥 | Save the current voxel data as a MedICS workspace variable. |
| ❌ | Remove the volume from the viewer. |

### List toolbar

Above the list:

- **Search** — filter cards by name.
- **Expand all / Collapse all** — fold every card at once.
- **Sort** — load order, name A→Z, name Z→A, or visible first.
- **Show all / Hide all** — toggle visibility of every volume.

The summary line reports how many volumes are loaded and how many are visible.

---

## Appearance (per volume)

Expand a card to edit rendering for that volume only.

### Threshold and opacity

- **Threshold** — intensities below this value are treated as transparent. The slider and spin box share a 0–255 scalar range (data is mapped to 8-bit for rendering).
- **Opacity** — overall translucency (`0.01`–`1.0`). Useful when overlaying several volumes.

### Display range

Maps original intensities onto the colormap.

- Set **min** and **max** in physical units (for example Hounsfield units).
- **⚡ Auto** — pick a range from data percentiles, so dim anatomy is visible without saturating bright voxels.
- **↺ Reset** — restore the full data range.

8-bit masks and label volumes keep their original integer values; they are not stretched to 0–255.

### Colormap

- Click the **colorbar** to open the colormap menu (grayscale, CET, and other pyqtgraph maps).
- Use the **color swatch** for a single solid colour (typical for surfaces and meshes).
- **🎨 Label colormap** — discrete colours for segmentation:
  - presets for 2, 4, 8, or 16 labels
  - **Custom…** to set the number of labels and pick each colour
  - label `0` is background (black / transparent)

### Lighting

**Light** presets:

| Preset | Typical use |
| --- | --- |
| `flat` | No shading; fastest preview |
| `phong` | Generic shaded surfaces |
| `ct_bone`, `ct_soft_tissue`, `ct_lung`, `ct_abdomen` | CT |
| `mr_t1`, `mr_t2` | MRI |
| `angiography`, `vessel` | Vessels |
| `ultrasound`, `pet` | US / PET |
| `scattering`, `retina`, `bone` | Specialized looks |

Click **☰** for **Ambient**, **Diffuse**, **Specular**, **Specular Power**, back-face culling, and edge / shadow options. Fine-tune after picking a preset.

### Render mode

| Mode | Result |
| --- | --- |
| **Volume** | GPU ray casting through the voxels (default). |
| **Binary** | Hard threshold as a solid mask. |
| **Slice** | A single cutting plane through the volume. |
| **Surface** | Semi-transparent isosurface (ChimeraX-style compositing). |
| **Mesh** | Extracted mesh with lighting. |
| **Surface (Opaque)** / **Mesh (Opaque)** | Same geometry, fully opaque. |

**Step** (`1`–`64`) downsamples before isosurface / mesh / binary extraction. Higher steps are faster and coarser. Default is `2`.

### Blend mode

Applies mainly to **Volume** mode:

| Mode | Result |
| --- | --- |
| `composite` | Standard alpha compositing (default). |
| `mip` | Maximum intensity projection. |
| `minip` | Minimum intensity projection. |
| `average` | Mean intensity along the ray. |
| `additive` | Intensities add (bright overlays). |
| `opaque` | Treat samples as opaque. |
| `alpha` | Alpha blending. |

When several volumes share a multi-volume pipeline, some blend modes may fall back to composite — `vtkMultiVolume` only supports composite blending.

---

## Clipping

Each volume has independent clip widgets. Enable one or more, then drag in the 3D view.

| Widget | What it does |
| --- | --- |
| **Plane** | One cutting plane. Drag the plane to move it; rotate the handles to change orientation. |
| **Box** | Axis-aligned crop. Drag each face along its own axis. |
| **Cube** | Freely rotatable crop box. Drag handles to rotate, translate, or scale. |

**↺** next to each option resets that widget to the full volume. **◉** hides the widget geometry while keeping the clip in effect — useful for snapshots and movies.

Clip state is stored **per camera-path anchor**, so movies can animate crops.

---

## Axis transforms

Flip or swap voxel axes without reloading:

- **Flip X / Y / Z** — reverse that dimension.
- **Swap XY / XZ / YZ** — exchange two axes (reorient to RAS / LPS, etc.).

Transforms apply to the data currently in the viewer. Save to the workspace (📥) if you want the reoriented array elsewhere in MedICS.

---

## Overlay several volumes

Typical workflow:

1. Load anatomy (CT / OCT) as **Volume**.
2. Load a segmentation and switch it to **Surface** or **Mesh**, or apply a **label colormap**.
3. Lower **Opacity** on the anatomy so the overlay shows through.
4. Drag cards so the overlay is **below** anatomy in the list if you need it composited first — order affects multi-volume compositing.

Visibility, colormap, clip, and lighting stay independent per volume.

---

## Snapshots and movies

### Snapshot

**File → Save Snapshot…** (or the 3D context menu) captures the current 3D view.

- Formats: PNG, JPEG, TIFF.
- Default name is `snapshot.png` (then `snapshot(1).png`, …).

### Preset movies

**File → Export Movie…** records an MP4 (30 fps, H.264) of a canned camera move around the **current** view. Click the button for a 360° spin, or open the menu:

| Preset | Motion |
| --- | --- |
| Spin (360° horizontal) | Full orbit about the vertical axis |
| Rock Left–Right | Swing left and right, return to center |
| Tilt Up–Down | Nod up and down, return to center |
| Up–Down–Left–Right Tour | Pan right, left, up, down, then return |
| Vertical Spin (360°) | Orbit about the horizontal axis |

You pick an output folder. The file is named `movie_<preset>_<timestamp>.mp4`. The camera is restored when recording finishes.

### Advanced camera-path movie

**File → Create Advanced Movie…** opens the camera-path editor.

1. Set the 3D view (and any volume clips / opacities) the way you want.
2. Click **Add Anchor** to store camera **and** per-volume state (opacity, threshold, clip plane / box).
3. Move the camera (or change appearance) and add more anchors.
4. Optionally **Insert Preset Movie** to drop a spin / rock / tour as a group of anchors.
5. For each anchor, set:
   - **Dwell** — hold time before moving on (seconds).
   - **Duration** — time to the next anchor.
   - **Easing** — Linear, EaseIn, EaseOut, EaseInOut.
6. Use **Quick Camera Controls** to rotate about world X / Y / Z, change distance, or jump to Top / Bottom / Front / Back / Left / Right.
7. **Re-capture Camera** / **Re-capture All Volumes** overwrite an anchor from the live view.
8. **Preview** plays the path in the 3D view; **Stop Preview** cancels.
9. **Generate Video** writes an MP4 of the interpolated path.
10. **Save Path** / **Load Path** store the path as JSON so you can reuse it.

Per-parameter interpolation can be turned off in the **Volumes** tab (for example keep opacity fixed while the camera moves). Enable **Loop** to connect the last anchor back to the first.

Delete or reorder anchors in the list (`Delete` / `Backspace`, `Up` / `Down`, drag).

---

## Display and Settings tabs

**Display**

- **Background** — Black, White, or Gray.

**Settings**

- **Quality** — Low, Medium, High, Ultra. Higher quality uses more GPU time. Default is **Medium**.
- **Enable GPU Acceleration** — on by default. Turn off only for troubleshooting.
- **Cache Size** — 100–2000 MB for volume caching. Default **512 MB**.

Some quality / GPU / cache changes apply the next time volumes are loaded.

---

## Suggested workflows

| Goal | Recipe |
| --- | --- |
| **CT bone vs soft tissue** | Load the CT, set Light to `ct_bone` or `ct_soft_tissue`, raise Threshold until noise disappears, then Auto-adjust the display range. |
| **Segmentation overlay** | Load the image, then the label volume. On the label card use the 🎨 colormap (or Surface mode), lower anatomy Opacity, enable a **Plane** clip to inspect interiors. |
| **OCT / angiography** | Load `.foct` / `.octa` / `.ssada`, try Light `retina` or `angiography`, Blend `mip` for vessels. |
| **Talk or paper figure** | Black or white background, hide clip widgets (◉), Default View, Save Snapshot at the window size you want. |
| **Turntable video** | Frame the volume, then Export Movie → Spin. For a custom fly-through, use Create Advanced Movie. |

---

## Tips

- Scroll-wheel on sliders and combos is ignored, so you do not change values while scrolling the volume list.
- Threshold updates are throttled while you drag; the final value applies on release.
- If a volume looks washed out, Auto-adjust the display range, then set Threshold just above background.
- If surfaces look blocky, lower **Step** (try `1`). If extraction is slow, raise Step.
- If rendering is slow, hide unused volumes, drop Quality, or raise Step on meshes.
- Reordering cards changes compositing order for overlapping volumes.
- Dropping a folder loads the first supported file inside it, not every file.

---

## Troubleshooting

| Problem | What to try |
| --- | --- |
| Extension does not appear | Confirm `pip show medics-ext-volume-viewer` in the MedICS environment and restart MedICS. |
| File will not load | Check the format table above. For `.mat` / `.med`, the file must contain a 3-D array (keys such as `oct`, `octa`, `volume`, `data`, or `image` are tried). |
| Volume is invisible | Lower Threshold, raise Opacity, click ◉, and Reset the display range. |
| Labels look continuous | Apply a **label colormap**, not a smooth colorbar. |
| Movie export fails | `imageio` with ffmpeg is required. Install ffmpeg, or use snapshots instead. |
| GPU errors / black view | Uncheck **GPU Acceleration** in Settings, or lower Quality. |
| Clip widget in the way of a figure | Toggle ◉ to hide widgets; the crop stays. |

---

## Requirements and license

- Python ≥ 3.11
- MedICS `>=2026rc0`, SDK `>=2026.7.7`
- Runtime dependencies: `vtk>=9.3.1`, `SimpleITK>=2.2.0`, `imageio[ffmpeg]>=0.6.0`, `superqt>=0.7.6`
- License: Proprietary

---

## Related pages

- [Official Extensions](Official-Extensions)
- [Extensions](Extensions)
- [Volume Labeler](Extensions-Volume-Labeler)
- [MedImage](MedImage)
- [Workspace and Data](Workspace-and-Data)
