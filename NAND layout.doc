cat > 01_nand_layout.md <<'EOF'
# NAND Layout

## Overview

The device contains 9 NAND partitions with distinct roles.

## Partition Breakdown

| NAND   | FS Type | Role |
|--------|--------|------|
| nanda  | FAT16  | Boot assets |
| nandb  | Raw    | U-Boot environment |
| nandc  | uImage | Kernel (primary) |
| nande  | uImage | Kernel (backup) |
| nandd  | ext4   | Active root filesystem |
| nandf  | FAT32  | User storage (USB exposed) |
| nandg  | ext4   | Root filesystem template |
| nandh  | ext4   | Firmware update staging |
| nandi  | None   | Unused / empty partition |

## Notes

- `nandd` is the live system
- `nandh` is used for firmware updates
- `nandg` contains a base rootfs template
- `nandi` is completely empty (all 0xFF)
EOF
