# Architecture

High-level design of the MedICS main application.

---

## Overview

MedICS is a modular Qt desktop platform:

- **Version family**: 0.x / packaging builds use calendar or PEP 440 versions depending on channel
- **Python**: ≥ 3.11
- **UI**: PySide6 (Qt 6)
- **License**: see the MedICS repository `LICENSE.md`

### Core capabilities

- Multi-format medical image I/O
- Embedded Python (in-process Jupyter + PyEditor)
- Optional AI chat / agent panel
- Dynamic extension system (pip entry points or filesystem drop-in)
- Dark / light themes via QSS
- Workspace persistence in `.med` (HDF5)

---

## Component diagram

```text
┌─────────────────────────────────────────────────────┐
│                   ApplicationInitializer              │
│  main.py: SafeApplication + ExceptionHandler +       │
│           ApplicationInitializer                     │
└──────────────────────┬──────────────────────────────┘
                       │
                       ▼
┌─────────────────────────────────────────────────────┐
│                     MedICSMain                       │
│  main_window_app.py: coordinator + service locator  │
│                                                     │
│  Components (ApplicationComponent):                 │
│  ┌──────────────┐  ┌──────────────────────────────┐ │
│  │  Core Layer  │  │       UI Layer               │ │
│  │  config_mgr  │  │  UIComponentManager          │ │
│  │  logger      │  │  ├─ MainWindowUI             │ │
│  │  theme_mgr   │  │  ├─ DockManager              │ │
│  │  workspace   │  │  ├─ MenuManager              │ │
│  │  toolbox_mgr │  │  ├─ ToolbarManager           │ │
│  │  ext_mgr     │  │  └─ StatusBarManager         │ │
│  └──────────────┘  └──────────────────────────────┘ │
│                                                     │
│  Communication: EventBus (pub/sub) + Qt signals     │
└─────────────────────────────────────────────────────┘
```

---

## Startup lifecycle

```text
Phase 1 (core):     config_manager → logger
Phase 2 (business): theme_manager → workspace_manager
Phase 3 (plugins):  toolbox_manager → extension_manager
Phase 4 (UI):       MainWindowUI → DockManager → MenuManager
                    → ToolbarManager → StatusBarManager
```

All managers inherit `ApplicationComponent` with `initialize()` / `cleanup()` and a small state machine (`UNINITIALIZED` → `INITIALIZED` → …).

---

## Package map (simplified)

```text
medics/
├── main.py / main_window_app.py   # Bootstrap + coordinator
├── config/                        # config.ini, models.json, …
├── core/                          # Config, theme, workspace, toolbox, extension managers
│   └── medimage/                  # Canonical image model
├── ui/                            # Main window, docks, menus, toolbars, dialogs
├── toolboxes/                     # Built-in PyEditor, ImportData, …
├── utils/                         # FileIO, EventBus, DataDict, plots, …
├── agents/                        # Optional AI agent stack
└── extension_template/            # Scaffold used by --create-ext
```

---

## Key files

| Path | Role |
| ---- | ---- |
| `medics/main.py` | Bootstrap: `SafeApplication`, `ExceptionHandler`, `ApplicationInitializer` |
| `medics/main_window_app.py` | `MedICSMain` coordinator + `UIComponentManager` |
| `medics/core/base_component.py` | `ApplicationComponent` ABC |
| `medics/utils/eventBus.py` | Pub/sub `EventBus` |
| `medics/config/config.ini` | Runtime configuration defaults |
| `medics/utils/build_wheel.py` | Extension wheel builder |

---

## Communication patterns

| Mechanism | Use |
| --- | --- |
| **EventBus** | Cross-component events (`workspace_updated`, `theme_changed`, `extension_loaded`, …) |
| **Qt signals/slots** | UI-thread widgets and managers |
| **app_context** | Passed to toolboxes / extensions — the live `MedICSMain` service locator |

See [Events and Data Flow](Events-and-Data-Flow).

---

## Out of scope for this wiki version

License checks, payment setup, and runtime authorization / usage-guard documentation are **omitted** from the current Community wiki.

---

## Related pages

- [Getting Started](Getting-Started)
- [MedImage](MedImage)
- [Extensions](Extensions)
- [Configuration](Configuration)
