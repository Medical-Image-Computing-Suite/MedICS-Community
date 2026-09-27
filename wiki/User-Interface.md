# User Interface

MedICS is a single-window Qt desktop application. Toolboxes open as **central tabs**, while Explorer, Variables, Jupyter, and related panels live in **docks**.

---

## Main window layout

```text
┌──────────────────────────────────────────────────────────────┐
│  Menu bar                                                     │
├────┬───────────────────────────────────────────────┬─────────┤
│    │                                               │         │
│ A  │              Central tab widget               │  Vars   │
│ c  │         (toolboxes, previews, extensions)     │  dock   │
│ t  │                                               │         │
│ i  ├───────────────────────────────────────────────┤         │
│ v  │  Bottom tabs: Logging | Terminal | Jupyter    │         │
│ i  │                                               │         │
│ t  │                                               │         │
│ y  │                                               │         │
├────┴───────────────────────────────────────────────┴─────────┤
│  Status bar                                                   │
└──────────────────────────────────────────────────────────────┘
```

---

## Core UI managers

The UI is assembled after core components initialize:

| Manager | Role |
| --- | --- |
| **MainWindowUI** | `QMainWindow` + central `QTabWidget` |
| **DockManager** | File tree, variables, Jupyter, chat, logs, and other docks |
| **MenuManager** | Menu bar, dynamic toolbox/extension menus |
| **ToolbarManager** | Draggable activity / toolbar strip |
| **StatusBarManager** | Status messages and indicators |

Theme (dark / light) is applied through QSS stylesheets via **ThemeManager**.

---

## Docks

Typical docks (names may vary slightly by version):

| Dock | What it shows |
| --- | --- |
| **Explorer** | Current project folder; double-click to preview |
| **Variables** | In-memory workspace keys and shapes |
| **Chat / Agent** | Optional AI assistant panel (when enabled) |
| **Bottom panel** | A single dock holding the tabs **Logging**, **Terminal**, **Jupyter**, and **Results** (when a results extension is loaded) |

The bottom panel is one dock with tabs, not four docks: its entries are aliases of
the same panel, so hiding one hides the strip. **Terminal** is the tab shown by
default.

Double-clicking a central tab can toggle dock visibility (layout convenience).

---

## Menus (overview)

| Menu | Common actions |
| --- | --- |
| **File** | Open folder, save / load workspace, preferences, quit |
| **View** | Theme, dock visibility |
| **Toolboxes** | Toggle activity-bar icons; open built-in toolboxes |
| **Extensions** | Show / manage installed extensions |
| **Help** | About, docs links |

---

## Central tabs

Built-in toolboxes and many extensions open as tabs in the center:

- **PyEditor** — Python IDE
- **ImportData** — drag-and-drop importer
- **FilePreview** — read-only file / volume preview
- **Jupyter Lab** — JupyterLab in a tab, sharing the workspace as `ws`
- Extension windows when `windowed` is true in their manifest

See [Toolboxes](Toolboxes) and [Extensions](Extensions).

---

## Themes

| Theme ID | Typical look |
| --- | --- |
| `dark` | Material-style dark QSS |
| `light` | Light QSS |

Change theme from **View** / **Settings**. The active theme is stored in `config.ini` under `[Theme]`. See [Configuration](Configuration).

---

## Tips

- Open a folder first so Explorer and relative paths make sense.
- Imported data appears in **Variables** and is visible to Jupyter / PyEditor.
- Prefer packaging new tools as **extensions** rather than editing built-in toolboxes.
