# Publishing this wiki to GitHub

The Markdown sources in this folder are authored for the
[GitHub Wiki](https://github.com/Medical-Image-Computing-Suite/MedICS-Community/wiki)
of **MedICS-Community**.

## One-time setup

1. On the GitHub repo page: **Settings → Features → Wikis** → enable **Wikis**.
2. Create the first empty wiki page in the GitHub UI (GitHub creates the
   `MedICS-Community.wiki.git` repository on first use), **or** run:

```bash
# from a machine with push access
git clone https://github.com/Medical-Image-Computing-Suite/MedICS-Community.wiki.git
cd MedICS-Community.wiki
cp -R /path/to/MedICS-Community/wiki/* .
git add .
git commit -m "docs: add MedICS main-app wiki (no auth section)"
git push origin master   # wiki default branch is often 'master'
```

## Ongoing updates

Prefer editing files under `wiki/` in this repository, then sync with:

```bash
./scripts/sync-wiki.sh
```

or let the **Sync Wiki** GitHub Action push `wiki/**` to the wiki git remote
when it is configured with a token that can write the wiki.

## Page map

| File | Wiki page |
| --- | --- |
| `Home.md` | Home |
| `Getting-Started.md` | Getting Started |
| `_Sidebar.md` | Sidebar navigation |
| `_Footer.md` | Footer |
