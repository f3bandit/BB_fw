# NAND Layout

## Partitions

nanda → Boot assets (FAT)
nandb → U-Boot environment
nandc → Kernel
nande → Backup kernel
nandd → Root filesystem
nandf → USB storage (payloads)
nandg → Recovery rootfs
nandh → Firmware update staging

## Filesystems

- ext4 (rootfs)
- FAT (boot + storage)

## Observations

- RootFS stored separately from update image
- Payload storage is user-accessible
