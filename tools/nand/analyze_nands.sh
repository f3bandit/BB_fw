#!/usr/bin/env bash
set -euo pipefail
NAND_DIR="${1:-$HOME/bb/nand}"
OUT_DIR="${2:-$HOME/bb/analysis}"
mkdir -p "$OUT_DIR"/{reports,strings,headers,binwalk,entropy,fsdetect}
cd "$NAND_DIR"
for img in nand*.img; do
  base="${img%.img}"
  echo "[*] Analyzing $img"
  file "$img" > "$OUT_DIR/reports/${base}.file.txt"
  stat "$img" > "$OUT_DIR/reports/${base}.stat.txt"
  sha256sum "$img" > "$OUT_DIR/reports/${base}.sha256.txt"
  md5sum "$img" > "$OUT_DIR/reports/${base}.md5.txt"
  xxd -l 1024 "$img" > "$OUT_DIR/headers/${base}.header.hex.txt"
  strings -a "$img" | head -500 > "$OUT_DIR/strings/${base}.strings.head.txt" || true
  binwalk "$img" > "$OUT_DIR/binwalk/${base}.binwalk.txt" || true
  binwalk -E "$img" > "$OUT_DIR/entropy/${base}.entropy.txt" || true
  blkid "$img" > "$OUT_DIR/fsdetect/${base}.blkid.txt" 2>&1 || true
  fdisk -l "$img" > "$OUT_DIR/fsdetect/${base}.fdisk.txt" 2>&1 || true
done
