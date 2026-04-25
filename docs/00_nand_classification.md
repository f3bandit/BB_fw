# NAND Classification

| NAND | FS Type | Role | Confidence | Evidence |
|---|---|---|---|---|
| `nanda` | FAT16 | Boot assets / boot counter | High | FAT label `BOOTCNT`, boot counter strings, boot asset references |
| `nandb` | Raw text/env | U-Boot environment | High | Contains `bootcmd`, `setargs_nand`, `nand_root=/dev/nandd`, `init=/init` |
| `nandc` | uImage | Primary kernel | High | uImage header: Linux 3.4.39, ARM, load/entry `0x40008000` |
| `nandd` | ext4 | Active live root filesystem | Critical | Contains `/usr/local/bunny`, `bunny_framework`, `bunny.service`, Debian userspace |
| `nande` | uImage | Backup/alternate kernel | High | Same style Linux 3.4.39 uImage as `nandc` |
| `nandf` | FAT32 | User-facing Bash Bunny storage / udisk | High | FAT32 label `BashBunny`; contains payload/tools/loot structure |
| `nandg` | ext4 | Recovery / rootfs-template area | High | Contains `/root/cherry.rootfs/rootfs` and recovery material |
| `nandh` | ext4 | Firmware update staging | High | Contains `/update/cherry.rootfs.tar`, `/update/uImage`, checksum files |
| `nandi` | None in original dump | Unused / erased NAND partition | 100% | Original dump is all `0xFF`; no strings or binwalk signatures |
