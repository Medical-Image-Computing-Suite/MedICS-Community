# CLI Reference

The `medics` command is the entry point for launching the app and for extension packaging helpers.

Implemented at `medics.__main__:main_entry`.

---

## Launch

```bash
medics
python -m medics
```

---

## Common options

```text
medics                              Start the desktop application
medics --version, -V                Print the installed version
medics --help                       Show CLI help
```

---

## Extension scaffolding

```bash
medics --create-ext
medics --create-ext medics-ext-my-tool
medics --create-ext medics-ext-my-tool /path/to/parent
```

Copies `medics/extension_template/` and substitutes package / class names. See [Extensions](Extensions).

---

## Extension build

```bash
# from an extension project directory (or pass the path as allowed by your build)
medics --build-ext                 # protected / Cython wheel when configured
medics --build-ext --unprotected   # plain-Python wheel
```

The extension wheel builder lives in `medics.utils.build_wheel` and is also used by many extension CI workflows.

---

## Main package build (developers)

From a MedICS source checkout (not required for end users):

```bash
medics --build                     # protected main wheel
medics --build --unprotected       # plain-Python main wheel
```

Root helpers such as `build_medics.py` / `setup_cython.py` support packaging pipelines.

---

## Related pages

- [Getting Started](Getting-Started)
- [Extensions](Extensions)
