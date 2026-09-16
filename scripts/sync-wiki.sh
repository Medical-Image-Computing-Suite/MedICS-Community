#!/usr/bin/env bash
# Sync wiki/*.md into the GitHub Wiki git repository.
set -euo pipefail

ROOT="$(cd "$(dirname "$0")/.." && pwd)"
WIKI_SRC="$ROOT/wiki"
WIKI_URL="${WIKI_URL:-https://github.com/Medical-Image-Computing-Suite/MedICS-Community.wiki.git}"
TMP="${TMPDIR:-/tmp}/MedICS-Community.wiki-sync-$$"

cleanup() { rm -rf "$TMP"; }
trap cleanup EXIT

if [[ ! -d "$WIKI_SRC" ]]; then
  echo "Missing wiki source directory: $WIKI_SRC" >&2
  exit 1
fi

echo "Cloning $WIKI_URL ..."
git clone --depth 1 "$WIKI_URL" "$TMP"

# Copy page sources (skip the local wiki/README.md publish guide if desired).
rsync -a --delete \
  --exclude 'README.md' \
  --exclude '.git' \
  "$WIKI_SRC"/ "$TMP"/

cd "$TMP"
git add -A
if git diff --cached --quiet; then
  echo "Wiki already up to date."
  exit 0
fi

git -c user.name="${GIT_AUTHOR_NAME:-MedICS Docs}" \
    -c user.email="${GIT_AUTHOR_EMAIL:-medics.support@gmail.com}" \
    commit -m "docs: sync MedICS main-app wiki from MedICS-Community/wiki"

BRANCH="$(git rev-parse --abbrev-ref HEAD)"
echo "Pushing to origin/$BRANCH ..."
git push origin "HEAD:refs/heads/$BRANCH"
echo "Done. Open https://github.com/Medical-Image-Computing-Suite/MedICS-Community/wiki"
