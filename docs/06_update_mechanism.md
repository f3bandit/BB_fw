# Firmware Update Mechanism

`nandh` is an ext4 update staging partition. Observed update files:

```text
/update/cherry.rootfs.tar
/update/uImage
/update/cherry.rootfs.tar.md5
/update/uImage.md5
```

This suggests a file-based update model rather than raw NAND imaging.

Related live-rootfs paths:

```text
/usr/local/bunny/update_recovery.sh
/usr/local/bunny/recovery_patches/
```

Recommended rebuild strategy: extract `cherry.rootfs.tar`, modify rootfs, repack preserving ownership/permissions, regenerate MD5 files, then deploy through the update mechanism.
