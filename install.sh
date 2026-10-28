#!/usr/bin/env bash
# gtree 首次安装(给别人用)。之后的版本由 gtree 自己提示更新,不用再跑这个。
#   curl -fsSL https://gtree.dobbylab.com/install.sh | bash
# (同一份脚本也作为 Release 附件发布,老地址 …/releases/latest/download/install.sh 仍可用)
#
# 终端输出用英文(面向所有语言的用户);注释照仓库惯例用中文。
# 变量一律写成 ${VAR}:macOS 自带 bash 3.2 在 UTF-8 环境下会把紧跟变量名的多字节字符(如「…」)
# 的首字节当成变量名的一部分,`$VERSION…` 在 set -u 下直接报 unbound variable(v0.3.3 起的安装脚本栽过)。
# 用 curl 下载而不是让人从浏览器下 zip:浏览器下载的文件带隔离属性,
# 未签名的 app 会被 Gatekeeper 拦下(「无法验证开发者」),curl 下的不会。
set -euo pipefail

# 先走我们的下载中转(infra/dl-worker,转发 GitHub Release 并记一次匿名下载),不通再直连 GitHub
DL="${GTREE_DL:-https://gtree-dl.dobbylab.com}"
REPO="${GTREE_RELEASE_REPO:-dobbylabhq/gtree-releases}"
DEST_DIR="${HOME}/Applications"
ARCH="$(uname -m)"; [ "${ARCH}" = "arm64" ] && ARCH="aarch64"

TMP="$(mktemp -d)"
trap 'rm -rf "${TMP}"' EXIT

echo "▶ Checking the latest version…"
curl -fsSL --connect-timeout 10 "${DL}/latest.json" -o "${TMP}/latest.json" 2>/dev/null \
  || curl -fsSL "https://github.com/${REPO}/releases/latest/download/latest.json" -o "${TMP}/latest.json"
VERSION="$(plutil -extract version raw -o - "${TMP}/latest.json")"
URL="$(plutil -extract "assets.${ARCH}.url" raw -o - "${TMP}/latest.json" 2>/dev/null)" \
  || { echo "❌ No build for ${ARCH} yet (gtree currently supports Apple Silicon Macs)"; exit 1; }
SHA="$(plutil -extract "assets.${ARCH}.sha256" raw -o - "${TMP}/latest.json")"

# 发布脚本的自检用:只验证能读到版本号,不下载、不安装
[ -z "${GTREE_INSTALL_DRY_RUN:-}" ] || { echo "dry run ok: ${VERSION}"; exit 0; }

echo "▶ Downloading gtree ${VERSION}…"
curl -fL --progress-bar "${URL}" -o "${TMP}/gtree.zip"
[ "$(shasum -a 256 "${TMP}/gtree.zip" | cut -d' ' -f1)" = "${SHA}" ] || { echo "❌ Checksum mismatch — download was corrupted, please try again"; exit 1; }

ditto -x -k "${TMP}/gtree.zip" "${TMP}/unpacked"
mkdir -p "${DEST_DIR}"
if pgrep -f "^${DEST_DIR}/gtree.app/Contents/MacOS/gtree\$" >/dev/null; then
  echo "ℹ️  gtree is running. Quit it (⌘Q) and run this again."; exit 1
fi
rm -rf "${DEST_DIR}/gtree.app"
mv "${TMP}/unpacked/gtree.app" "${DEST_DIR}/gtree.app"

echo "✅ Installed gtree ${VERSION} to ${DEST_DIR}/gtree.app"
open "${DEST_DIR}/gtree.app"
