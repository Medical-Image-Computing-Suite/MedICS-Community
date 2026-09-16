# Events and Data Flow

MedICS components communicate through **EventBus** (pub/sub) and **Qt signals** (UI thread).

---

## Example flows

### Theme change

```text
Settings → ThemeManager.set_theme(id)
    → theme_changed (signal) → DockManager / widgets refresh
    → event_bus.emit('theme_changed', {...}) → subscribers
```

### Workspace update (from Jupyter)

```text
Jupyter kernel poll → MedICSMain.update_workspace_data(data)
    → WorkspaceManager.update_workspace_data(data, 'jupyter')
    → event_bus.emit('workspace_updated', {data, source})
    → DockManager / Variables tree refresh
```

### Extension loaded

```text
ExtensionManager.load_extension(id)
    → event_bus.emit('extension_loaded', {...})
    → MenuManager.refresh_extension_menu()
    → ToolbarManager.refresh_toolbar()
```

---

## EventBus catalog (common events)

| Event | Typical source | Payload (conceptually) | Typical subscribers |
| --- | --- | --- | --- |
| `component_state_changed` | `ApplicationComponent.set_state` | `{component, state}` | monitoring |
| `component_registered` | `MedICSMain` | `{name, component}` | monitoring |
| `workspace_updated` | `WorkspaceManager` | `{data, source}` | DockManager, variables tree |
| `folder_changed` | `WorkspaceManager` | `{folder}` | file explorer |
| `theme_changed` | `ThemeManager` | `{theme_id, stylesheet, …}` | docks, toolbar |
| `toolbox_loaded` / `toolbox_unloaded` | `ToolboxManager` | toolbox info | Menu / Toolbar |
| `extension_loaded` / `extension_unloaded` | `ExtensionManager` | extension info | Menu / Toolbar |
| `extensions_reloaded` | `ExtensionManager` | reload results | MenuManager |
| `file_selected` | DockManager / Explorer | file path | toolboxes, extensions |

Exact payload shapes may evolve; treat this table as a guide when wiring extensions.

---

## File loading flow (ImportData → workspace)

```text
User drops file → ImportData
    → detect type
    → background worker (QThread) loads array / volume
    → preview
    → user confirms Import
    → workspace[name] = data
    → WorkspaceManager.update_workspace_data(...)
    → event_bus 'workspace_updated'
    → Variables tree + Jupyter namespace update
```

---

## Workspace save flow

```text
File → Save Workspace (or auto-save timer)
    → WorkspaceManager.save_workspace_async()
    → background worker writes .med (HDF5)
    → status bar / UI feedback
```

---

## Extension guidance

When writing an extension:

1. Prefer reading/writing data through the **workspace manager** on `app_context`.
2. Subscribe to EventBus events you need; unsubscribe in `cleanup()`.
3. Do UI work on the Qt main thread; use workers for heavy I/O.

See [Extensions](Extensions) and [Architecture](Architecture).
