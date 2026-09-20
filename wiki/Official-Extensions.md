# Official Extensions

MedICS ships a set of **official extensions** maintained by the MedICS Team. Each one is a normal MedICS extension: install it with `pip`, then open it from the **Extensions** menu.

For the extension system itself (discovery, `extension.json`, packaging, publishing), see [Extensions](Extensions).

---

## Bundled official extensions

| Extension | Category | What it does | Docs |
| --- | --- | --- | --- |
| **Volume Labeler** | Medical Imaging | Annotate 3D volumes: paint labels on B-frames / enface, constrain work to a slab with boundary curves, inspect in 3D, export label maps | [Volume Labeler](Extensions-Volume-Labeler) |
| **Measurement** | Analysis | Draw ROIs on images and volumes and measure them: 53 measurement types, calibration-aware units, results export | [Measurement](Extensions-Measurement) |
| **Image Labeler** | Medical Imaging | Annotate 2D images with multiple label types and annotation workflows | *(page pending)* |
| **Volume Viewer** | Visualization | 3D / 2D volume visualization with GPU-accelerated rendering and multi-planar reconstruction | *(page pending)* |
| **OCT Viewer** | Medical Imaging | OCT visualization and analysis | *(page pending)* |
| **Retinal Layer Segmentation** | Medical Imaging | Automated retinal layer segmentation with quantitative features | *(page pending)* |
| **GraphicPy** | Visual Programming | Node-based visual programming for building and running computational graphs | *(page pending)* |
| **Deep Learning Pipeline** | Deep Learning | Design, train, evaluate, test, and deploy deep learning models inside MedICS | *(page pending)* |

Pages are added as extensions are documented — this table is the index.

---

## Installing an official extension

```bash
pip install medics-ext-volume-labeler
medics
```

Then open it from **Extensions** (or the extension manager dialog). Windowed extensions open as a central tab.

Pinning a version:

```bash
pip install "medics-ext-volume-labeler==1.0.0"
```

---

## Updating

```bash
pip install --upgrade medics-ext-volume-labeler
```

Or use **Extensions → Extension Manager → Update** to update from PyPI, then reload the extension without restarting MedICS.

---

## Extension requirements

Official extensions declare their compatibility in `extension.json`:

```json
{
  "schema": "medics.extension/1",
  "api_version": 1,
  "name": "Volume Labeler",
  "version": "1.0.0",
  "category": "Medical Imaging",
  "windowed": true,
  "capabilities": ["ui", "workspace"],
  "requires": {
    "medics": ">=2026rc0",
    "sdk": ">=2026.7.7",
    "extensions": []
  }
}
```

The extension manager checks `requires` before loading and reports a clear error when the MedICS build is too old.

---

## Support

- Bugs / feature requests: [MedICS-Community issues](https://github.com/Medical-Image-Computing-Suite/MedICS-Community/issues)
- Main application: [Medical-Image-Computing-Suite/MedICS](https://github.com/Medical-Image-Computing-Suite/MedICS)

---

## Related pages

- [Extensions](Extensions) — how extensions work, how to build your own
- [Volume Labeler](Extensions-Volume-Labeler)
- [Measurement](Extensions-Measurement)
- [Toolboxes](Toolboxes)
- [Workspace and Data](Workspace-and-Data)
