#!/usr/bin/env bash
set -euo pipefail

REPO_URL="${HKZ_PKG_REPO:-https://github.com/hakyzmain/PackageAutoUpdater.git}"
BRANCH="${HKZ_PKG_BRANCH:-main}"
INSTALL_DIR="${HKZ_PKG_DIR:-/opt/hkz-packages}"
BIN_LINK=/usr/local/bin/hkz-packages

[[ $EUID -eq 0 ]] || { echo "root required"; exit 1; }

if [ -d "$INSTALL_DIR/.git" ]; then
  git -C "$INSTALL_DIR" fetch --depth 1 origin "$BRANCH"
  git -C "$INSTALL_DIR" reset --hard "origin/$BRANCH"
else
  rm -rf "$INSTALL_DIR"
  git clone --depth 1 -b "$BRANCH" "$REPO_URL" "$INSTALL_DIR"
fi

chmod +x "$INSTALL_DIR/hkz-packages" "$INSTALL_DIR/install.sh"
ln -sfn "$INSTALL_DIR/hkz-packages" "$BIN_LINK"
echo "installed: hkz-packages ($(cat "$INSTALL_DIR/VERSION" 2>/dev/null || echo '?'))"
echo "run: hkz-packages update"
