# Boot Chain

## Overview

The Bash Bunny firmware follows a standard embedded Linux boot sequence.

## Flow

U-Boot → Kernel → RootFS → systemd → Bunny Runtime

## Detailed Sequence

1. Bootloader (U-Boot)
2. Kernel loads from NAND (uImage)
3. Root filesystem mounted from `/dev/nandd`
4. systemd initializes system
5. `bunny.service` launches runtime

## Kernel

- Linux 3.4.39 (ARM)
- No embedded initramfs
- Root filesystem required for boot

## RootFS

- ext4 filesystem
- Debian Jessie-based
