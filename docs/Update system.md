cat > 03_update_system.md <<'EOF'
# Firmware Update System

## Location

nandh/update/

## Contents

- cherry.rootfs.tar
- uImage
- md5 checksum files

## Process

1. Update files placed in nandh
2. Recovery process triggered
3. Root filesystem extracted
4. Written to nandd

## Key Insight

Updates are file-based, not raw NAND images.
EOF
