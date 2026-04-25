# Rebuild Workspace

This directory is reserved for firmware rebuild and repack experiments.

Do not commit firmware blobs or extracted root filesystems here.

Recommended local-only workflow:

```text
rebuild/
├─ README.md
├─ scripts/        # safe helper scripts committed to Git
├─ patches/        # small text patches committed to Git
└─ work/           # local ignored workspace for extracted firmware
```

Planned pipeline:

1. Extract `ch_fw_1.7_332.tar.gz` outside Git.
2. Extract `upgrade/cherry.rootfs.tar` into a local work directory.
3. Apply controlled rootfs patches.
4. Repack `cherry.rootfs.tar` preserving ownership, permissions, and symlinks.
5. Recalculate `cherry.rootfs.tar.md5`.
6. Repack the final firmware archive.
