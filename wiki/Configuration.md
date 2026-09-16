# Configuration

MedICS configuration lives in `config.ini` (INI format). Defaults are created on first launch when the file is missing. Changes via `ConfigManager.set()` are written back to disk.

---

## Location

The runtime config directory is managed by `ConfigManager.get_config_dir()` (platform-dependent user config path used by the installed app). The packaged defaults ship under `medics/config/` in the source tree.

---

## `config.ini` sections

### `[Theme]`

| Key | Type | Default | Description |
| --- | ---- | ------- | --- |
| `theme` | `str` | `dark` | Active theme ID: `dark` or `light` |

| ID | Typical QSS |
| -- | --- |
| `dark` | `QSS/MaterialDark.qss` |
| `light` | `QSS/Ubuntu.qss` |

### `[Logging]`

| Key | Type | Default | Description |
| --- | ---- | ------- | --- |
| `level` | `str` | `INFO` | `DEBUG`, `INFO`, `WARNING`, `ERROR` |
| `file` | `str` | `medics.log` | Log file name inside the log directory |

### `[Window]`

| Key | Type | Default | Description |
| --- | ---- | ------- | --- |
| `width` | `int` | `1200` | Initial window width |
| `height` | `int` | `800` | Initial window height |

### `[Extensions]`

| Key | Type | Default | Description |
| --- | ---- | ------- | --- |
| `auto_load` | `bool` | `true` | Auto-load enabled extensions on startup |
| `disabled` | `str` | *(empty)* | Comma-separated extension IDs to skip |

### `[Application]`

| Key | Type | Default | Description |
| --- | ---- | ------- | --- |
| `window_title` | `str` | `MedICS` | Title bar text |
| `auto_save_workspace` | `bool` | `true` | Periodic workspace auto-save |
| `show_system_tray` | `bool` | `true` | Show system tray icon |

### `[Plugins]`

| Key | Type | Default | Description |
| --- | ---- | ------- | --- |
| `auto_load_plugins` | `bool` | `true` | Auto-load enabled toolboxes on startup |
| `load_timeout` | `int` | `30` | Toolbox load timeout (seconds) |

### `[Chat]`

Used by the optional AI chat panel:

| Key | Type | Default | Description |
| --- | ---- | ------- | --- |
| `provider` | `str` | `openai` | Default LLM provider key |
| `*_model` | `str` | *(per provider)* | Default model for each provider |
| `temperature` | `float` | `0.7` | Sampling temperature |
| `max_tokens` | `int` | `2048` | Max tokens per response |
| `system_prompt` | `str` | *(built-in)* | Optional override |

### `[ChatKeys]`

Per-provider API keys (`openai_api_key`, `gemini_api_key`, …). Store secrets only on your machine; do not commit them.

### `[UI]`

| Key | Description |
| --- | --- |
| `use_native_menu_bar` | Prefer the native menu bar when available (macOS) |

---

## Changing settings from the UI

Use **File → Preferences / Settings** (wording may vary by build) to adjust theme, workspace auto-save, chat provider, and related options without editing INI by hand.

---

## Related pages

- [User Interface](User-Interface)
- [Workspace and Data](Workspace-and-Data)
- [Architecture](Architecture)
