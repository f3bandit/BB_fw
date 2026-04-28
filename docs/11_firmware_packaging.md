# 11 — Firmware Packaging

## Stock Firmware Format

Stock firmware: `ch_fw_1.7_332.tar.gz`

```
ch_fw_1.7_332.tar.gz
└── upgrade/
    ├── cherry.rootfs.tar      ← ext4 image of nandd (raw, NOT a tar of files)
    ├── cherry.rootfs.tar.md5  ← md5sum of cherry.rootfs.tar
    ├── uImage                 ← kernel (u-boot image, ARM, not compressed)
    └── uImage.md5             ← md5sum of uImage
```

### cherry.rootfs.tar
Despite the `.tar` extension, this is a **raw ext4 filesystem image**.
The BB updater writes it directly to the `nandd` partition via `dd`-equivalent.
It is NOT extracted as a tar archive.

Size: matches the `nandd` partition exactly (~1.2GB for stock 1.7 firmware).
`nandd` partition capacity: 3,407,872 blocks × 1024 = ~3.3GB.

### uImage
Standard u-boot legacy image format.
- Architecture: ARM
- Compression: none (raw zImage inside uImage header)
- Kernel: Linux 3.4.39
- Built: Sun Jan 31 02:25:46 2021
- Header CRC: 0xC709510F (stock Jan 31 build)
- Header CRC: 0xD1183FDD (stock Jan 29 build — in update package)

**Always use the uImage from the stock firmware update package.**
Never replace uImage unless explicitly working on kernel changes.

---

## Update Staging Process

The BB updater looks for firmware in the `nandh` partition (cache/update staging).
Files must be named starting with `ch_fw_` to be recognized.

### Update Log Stages
```
Stage 1 — Start
Stage 2 — Identify update file (matches ch_fw_ prefix)
Stage 3 — Extract and validate
Stage 4 — Write rootfs to nandd
Stage 5 — Write kernel to nandc
Stage 7 — Complete
```

Stage 3→4 takes ~3 minutes (rootfs write).
Stage 4→5 takes ~1-3 minutes (kernel write).
No Stage 6 in observed logs.

### Fatal Error Conditions
```
Fatal Error: Could not extract the file ch_fw_*.tar.gz
```
Caused by: tar-in-tar format (wrapping ext4 image inside another tar).
The updater expects the outer `.tar.gz` to contain `upgrade/` directly,
and `upgrade/cherry.rootfs.tar` to be a raw ext4 image.

---

## Correct Packing Method

```bash
# 1. Start from stock firmware to get uImage + uImage.md5
tar -xzf ch_fw_1.7_332.tar.gz -C /tmp/pkg/

# 2. Replace cherry.rootfs.tar with our ext4 image
cp new_nandd.img /tmp/pkg/upgrade/cherry.rootfs.tar

# 3. Regenerate md5
cd /tmp/pkg/upgrade && md5sum cherry.rootfs.tar > cherry.rootfs.tar.md5

# 4. Repack exactly as stock
tar -C /tmp/pkg -czf ch_fw_custom.tar.gz upgrade
```

---

## What v3 Taught Us

`ch_fw_custom_v24_winexport_v3.tar.gz` used a tar-in-tar format:
```
upgrade/cherry.rootfs.tar  ← tar archive containing new_nandd.img
```

The updater rejected this with "Fatal Error: Could not extract".
**Do not use tar-in-tar format.**

---

## Firmware File Naming

The updater matches filenames starting with `ch_fw_`:
```
startString = ch_fw_
lenString = 6
lenMatch = 6
```

Custom firmware must be named `ch_fw_*.tar.gz` to be recognized.

---

## Image Size Reference

| Item | Size |
|------|------|
| nandd partition | 3,407,872 blocks = ~3.3GB |
| Stock cherry.rootfs.tar | 1,232,844,800 bytes = ~1.2GB |
| Recommended custom image | 3,200MB (fits in nandd with room) |

---

## MD5 Verification

The updater verifies MD5 checksums before flashing.
Always regenerate after replacing cherry.rootfs.tar:

```bash
cd upgrade/
md5sum cherry.rootfs.tar > cherry.rootfs.tar.md5
md5sum uImage > uImage.md5  # only if uImage changed
```
