# Bash Bunny Firmware Analysis

This repository documents the internal architecture of the Bash Bunny firmware based on full NAND extraction and analysis.

## Scope

This project covers:

- Boot chain (U-Boot → Kernel → RootFS)
- systemd service structure
- Bunny runtime framework
- Payload execution system
- USB gadget implementation
- NAND partition layout
- Firmware update mechanism
- Modding and injection entry points

## Methodology

Firmware was analyzed by:

1. Dumping NAND partitions
2. Mounting filesystem images
3. Extracting update payloads
4. Reverse engineering runtime scripts and services

## Key Findings

- Debian Jessie-based root filesystem
- systemd-managed boot process
- Root-level payload execution (no sandboxing)
- Custom USB gadget kernel module
- File-based firmware update system (tar-based)

## Structure

See individual markdown files for detailed breakdowns.

## Disclaimer

For educational and research purposes only.
