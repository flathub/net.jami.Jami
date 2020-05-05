#!/bin/sh
set -eu

BUILD_DIR="build"
REPO_DIR="repo"

# Sanity check
json-glib-validate *.json

exec flatpak-builder --force-clean --repo "${REPO_DIR}" --ccache "$@" "${BUILD_DIR}" net.jami.Jami_dev.json
