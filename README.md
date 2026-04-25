# Bash Bunny Firmware Analysis

This repository documents the Bash Bunny firmware layout from NAND dumps, mounted filesystem images, bootloader strings, kernel inspection, systemd service discovery, USB gadget strings, payload runtime analysis, and update-staging contents.

## What is in this repo

- `docs/` — clean, human-readable firmware notes.
- `raw/` — renamed raw command output/transcripts used as evidence.
- `tools/` — helper scripts for repeatable analysis.
- `rebuild/` — notes and placeholders for a future custom firmware rebuild pipeline.

## Important exclusions

Firmware blobs and NAND images are intentionally excluded from Git:

- `*.tar.gz`
- `*.img`
- `*.rootfs`
- `*.rootfs.tar`
- `*.md5`

## Confirmed architecture

```text
U-Boot / boot env
  -> Linux uImage kernel
  -> ext4 live rootfs on nandd
  -> systemd multi-user.target
  -> bunny.service
  -> /usr/local/bunny/bin/bunny_framework
  -> payload execution from /root/udisk/payloads/
```


## Current Project Structure

```text
BB_fw/
├─ docs/       Reverse-engineering notes and conclusions
├─ raw/        Raw captured evidence and command output
├─ tools/      Helper scripts grouped by task
├─ rebuild/    Rebuild/repack workspace and notes
└─ .gitignore  Blocks firmware blobs and generated output
```

Firmware archives, NAND dumps, rootfs images, kernel modules, and generated analysis output should stay outside Git.
