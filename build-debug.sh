#!/bin/sh
set -eu

BUILD_DIR="build"
REPO_DIR="repo"

flatpak-builder -v --force-clean --repo "${REPO_DIR}" --keep-build-dirs --ccache "$@" "${BUILD_DIR}" net.jami.Jami.json
