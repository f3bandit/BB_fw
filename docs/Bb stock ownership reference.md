# Bash Bunny Stock Firmware — Filesystem Ownership Reference

## Source
- Device: Bash Bunny Mark II
- Firmware: stock `ch_fw_1.7_332`
- Partition: `nandd` (ext4, ~3.3GB)
- Captured: fresh `dd` dump from running stock device

---

## Critical Ownership Rules

The BB stock rootfs uses **numeric UIDs/GIDs**. The ARM rootfs has different
user/group names than the WSL host building it. All files must be owned by
**root:root (0:0)** except for the specific exceptions listed below.

**If any top-level directory is owned by a non-root user (e.g. 1000:1000),
systemd will fail to boot correctly.**

---

## Top-Level Directory Ownership

| Path | Owner | Group | Mode |
|------|-------|-------|------|
| `/` | root | root | 755 |
| `/bin` | root | root | 755 |
| `/boot` | root | root | 755 |
| `/dev` | root | root | 755 |
| `/etc` | root | root | 755 |
| `/home` | root | root | 755 |
| `/lib` | root | root | 755 |
| `/media` | root | root | 755 |
| `/mnt` | root | root | 755 |
| `/opt` | root | root | 755 |
| `/proc` | root | root | 755 |
| `/root` | root | root | 700 |
| `/run` | root | root | 755 |
| `/sbin` | root | root | 755 |
| `/srv` | root | root | 755 |
| `/sys` | root | root | 755 |
| `/tmp` | root | root | 1777 |
| `/tools` | root | root | 755 |
| `/usr` | root | root | 755 |
| `/var` | root | root | 755 |

---

## Known Exceptions (non-root ownership)

| Path | Owner | Group | Mode | Reason |
|------|-------|-------|------|--------|
| `/tmp` | root | root | 1777 | sticky bit |
| `/var/tmp` | root | root | 1777 | sticky bit |
| `/etc/shadow` | root | shadow (42) | 640 | PAM security |
| `/etc/gshadow` | root | shadow (42) | 640 | PAM security |
| `/var/spool/cron/crontabs` | root | crontab | 1730 | cron security |
| `/run/log/journal` | root | systemd-journal | 2755 | journald |

---

## Setuid/Setgid Binaries

These must have exact permissions — wrong modes break login and su:

| Path | Mode | Owner | Group |
|------|------|-------|-------|
| `/bin/login` | 4755 | root | root |
| `/bin/su` | 4755 | root | root |
| `/usr/bin/passwd` | 4755 | root | root |
| `/bin/busybox` | 4755 | root | root |
| `/usr/local/bunny` | 755 | root | staff (50) |
| `/usr/local/bunny/bin/bunny_framework` | 755 | root | staff (50) |
| `/usr/local/bunny/bin/ATTACKMODE` | 755 | root | staff (50) |
| `/usr/local/bunny/lib/bunny_gadget.ko` | 644 | root | staff (50) |

---

## Bunny Framework File Hashes (stock)

| File | SHA256 |
|------|--------|
| `bunny_framework` | `e954e731d0fe49347225e59f1750ee0942bd8f1a24ad3ca22b46776237541f79` |
| `ATTACKMODE` | `12566fc0f35dee601181ce3a07823d40a18e1734df60afaa137861bdbb46a163` |
| `bunny_gadget.ko` (GOOD) | `7a27b30f074a40758a9e50ff80ab286d79d1b5c57519fcc5d5ecf5fcbeeee032` |
| `bunny_gadget.ko` (BAD) | `3f8321294a267b7f50fd3e734b18dc76fa323c91845385456ea2ee1df33a930b` |

---

## Systemd Service Wiring (stock)

### Must exist:
- `/lib/systemd/system/bunny.service`
- `/etc/systemd/system/multi-user.target.wants/bunny.service` → symlink to `/lib/systemd/system/bunny.service`
- `/etc/systemd/system/default.target` → symlink to `/lib/systemd/system/multi-user.target`
- `/sbin/init` → symlink to `/lib/systemd/systemd`

### Must NOT exist:
- `/etc/systemd/system/bunny-framework.service`
- `/etc/systemd/system/multi-user.target.wants/bunny-framework.service`
- `/etc/systemd/system/getty.target.wants/serial-getty@ttyGS0.service`

### bunny.service content (exact):
```
[Unit]
After=network.target auditd.service

[Service]
Type=forking
KillMode=process
ExecStart=/usr/local/bunny/bin/bunny_framework

[Install]
WantedBy=multi-user.target
```

---

## rc.local (stock — inert stub):
```
#!/bin/sh -e

exit 0
```

Must be owned root:root, mode 755.  
Must NOT launch bunny_framework, ATTACKMODE, or any serial starter.

---

## Files That Must NOT Be In Firmware

| File | Reason |
|------|--------|
| `/usr/bin/qemu-arm-static` | WSL chroot tool — never ship in firmware |
| `/etc/rc.local.v24bak.*` | Build artifacts — clean before packing |
| `/usr/local/bunny.pre-v9.*` | Leftover backup directory — remove |
| Any `*.v24bak.*` files | Build artifacts — clean before packing |

---

## Build Rules for WSL

When building the image in WSL, all files rsync'd into the ext4 image
must use `--numeric-ids` and the image must be mounted and `chown`'d
before packing:

```bash
# After mounting image and rsyncing rootfs:
chown -R root:root /mnt/bbimg/
# Then restore specific exceptions listed above
```

Never run the build script as a non-root user without `sudo` — rsync
will copy files with the WSL host user's UID (1000) instead of root (0).

---

## Partition Map Reference

| Partition | Name | Size | Format | Purpose |
|-----------|------|------|--------|---------|
| nanda | bootloader | 16MB | FAT16 | Boot counter |
| nandb | env | 16MB | raw | U-Boot env |
| nandc | boot | 16MB | uImage | Kernel |
| nandd | system | 3.3GB | ext4 | RootFS |
| nande | recovery | 32MB | uImage | Recovery kernel |
| nandf | mass_storage | 1.8GB | FAT32 | USB storage (udisk) |
| nandg | sysrecovery | 736MB | ext4 | System recovery |
| nandh | cache | 1.3GB | ext4 | Update staging |
| nandi | UDISK | 296MB | ext4 | Internal storage |
