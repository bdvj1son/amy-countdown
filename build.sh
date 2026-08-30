#!/usr/bin/env bash
# Wraps the Artifact source (index.html, which has no <head> because the Artifact
# runtime supplies one) into a standalone document for GitHub Pages.
#
#   ./build.sh   ->  writes docs/index.html
#
# Run this after any edit to index.html so the two never drift.

set -euo pipefail
cd "$(dirname "$0")"

SRC="index.html"
OUT="docs/index.html"
mkdir -p docs

# Everything up to and including </style> is head material (title, font links,
# stylesheet). Everything after it is the body (markup + script).
HEAD_PART="$(sed -n '1,/<\/style>/p' "$SRC")"
BODY_PART="$(sed -n '/<\/style>/,$p' "$SRC" | tail -n +2)"

{
  cat <<'EOF'
<!doctype html>
<html lang="en">
<head>
<meta charset="utf-8">
<meta name="viewport" content="width=device-width, initial-scale=1, viewport-fit=cover">
<meta name="robots" content="noindex, nofollow">
<meta name="description" content="A countdown through Amy's residency schedule.">
<meta name="theme-color" content="#FBF5F6" media="(prefers-color-scheme: light)">
<meta name="theme-color" content="#171220" media="(prefers-color-scheme: dark)">
<meta name="apple-mobile-web-app-capable" content="yes">
<meta name="apple-mobile-web-app-status-bar-style" content="default">
<meta name="apple-mobile-web-app-title" content="Countdown">
<meta name="mobile-web-app-capable" content="yes">
<link rel="apple-touch-icon" sizes="180x180" href="icon-180.png">
<link rel="icon" type="image/png" sizes="192x192" href="icon-192.png">
<link rel="icon" type="image/png" sizes="512x512" href="icon-512.png">
<link rel="manifest" href="manifest.webmanifest">
EOF
  printf '%s\n' "$HEAD_PART"
  printf '%s\n' "</head>"
  printf '%s\n' "<body>"
  printf '%s\n' "$BODY_PART"
  printf '%s\n' "</body>"
  printf '%s\n' "</html>"
} > "$OUT"

echo "wrote $OUT ($(wc -c < "$OUT") bytes)"
