#!/usr/bin/env bash
# Regenerates the one synced query file from its canonical source
# (../tree-sitter-ohh), mirrors zed-phh/scripts/sync-queries.sh. Only
# highlights.scm is a straight copy; brackets.scm, indents.scm and
# outline.scm are Zed-specific adaptations (different capture conventions,
# see each file's own header comment) and are NOT touched by this
# script. OHH has no injected sub-grammar, so there is no second grammar's
# highlights.scm to sync the way zed-phh syncs phh_actions's.
set -euo pipefail
cd "$(dirname "$0")/.."

cp ../tree-sitter-ohh/queries/highlights.scm languages/ohh/highlights.scm

echo "Synced languages/ohh/highlights.scm."
echo "brackets.scm, indents.scm, outline.scm are Zed-specific, edit by hand."
