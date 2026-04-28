# 10 — Ownership and Build Rules

## The Core Problem

When building BB firmware in WSL, files copied or extracted without `--numeric-owner`
as root get mapped to the WSL host user's UID (1000) instead of root (0).

On the target ARM device, systemd is strict about filesystem ownership.
If `/` or core directories are owned by a non-root user, services fail
to start in unpredictable ways — including bunny.service.

**Symptom:** Solid green LED then nothing. Framework starts, then hangs.

---

## Root Cause: chroot UID Mapping

When ChatGPT had the user run commands inside a chroot, files written inside
the chroot appeared as root inside but were stored as UID 1000 on the WSL host.

WSL maps UIDs differently than native Linux. Running `sudo chroot` does not
guarantee that files created inside will have UID 0 on the host filesystem.

**Result:** Every directory in `new_nandd.img` was owned by `f3ban:f3ban`
(1000:1000) instead of `root:root` (0:0).

---

## Correct Way to Extract Stock Rootfs

Always extract the stock `cherry.rootfs.tar` with `--numeric-owner` as root:

```bash
sudo tar --numeric-owner -xf /path/to/cherry.rootfs.tar -C /path/to/dest/
```

Without `--numeric-owner`, tar maps UIDs from the archive to the current
user, destroying the original ownership.

**Verified correct extraction path:**
```
/home/f3ban/bb/stock_rootfs_correct/rootfs/
```

---

## Correct Ownership — Stock Nandd Filesystem

### Top-Level Directories
All must be `0:0` (root:root):

| Path | UID:GID | Mode |
|------|---------|------|
| `/` | 0:0 | 755 |
| `/bin` | 0:0 | 755 |
| `/boot` | 0:0 | 755 |
| `/dev` | 0:0 | 755 |
| `/etc` | 0:0 | 755 |
| `/home` | 0:0 | 755 |
| `/lib` | 0:0 | 755 |
| `/media` | 0:0 | 755 |
| `/mnt` | 0:0 | 755 |
| `/opt` | 0:0 | 755 |
| `/proc` | 0:0 | 755 |
| `/root` | 0:0 | 700 |
| `/run` | 0:0 | 755 |
| `/sbin` | 0:0 | 755 |
| `/srv` | 0:0 | 755 |
| `/sys` | 0:0 | 755 |
| `/tmp` | 0:0 | 1777 |
| `/tools` | 0:0 | 755 |
| `/usr` | 0:0 | 755 |
| `/var` | 0:0 | 755 |

### Bunny Framework Files
Group 50 = `staff` on the BB device:

| Path | UID:GID | Mode |
|------|---------|------|
| `/usr/local/bunny/` | 0:50 | 755 |
| `/usr/local/bunny/bin/bunny_framework` | 0:50 | 755 |
| `/usr/local/bunny/bin/ATTACKMODE` | 0:50 | 755 |
| `/usr/local/bunny/lib/bunny_gadget.ko` | 0:50 | 644 |

### Setuid Binaries
Must have exact modes — wrong modes break login and su:

| Path | UID:GID | Mode |
|------|---------|------|
| `/bin/login` | 0:0 | 4755 |
| `/bin/su` | 0:0 | 4755 |
| `/usr/bin/passwd` | 0:0 | 4755 |

### Security Files

| Path | UID:GID | Mode |
|------|---------|------|
| `/etc/shadow` | 0:42 | 640 |
| `/etc/gshadow` | 0:42 | 640 |

---

## Build Rules

### Always build as root with sudo
```bash
sudo bash ./build_script.sh
```

### Always use --numeric-ids with rsync
```bash
rsync -aHAX --numeric-ids "$ROOTFS/" "$MNT/"
```

### Never ship qemu-arm-static in firmware
```bash
rm -f "$ROOTFS/usr/bin/qemu-arm-static"
```

### Always verify ownership in the image after rsync
```bash
IMG_ROOT_UID=$(stat -c '%u' "$MNT")
[ "$IMG_ROOT_UID" = "0" ] || fail "Image root not owned by root"
```

---

## Files That Must Never Be In Firmware

| File | Reason |
|------|--------|
| `/usr/bin/qemu-arm-static` | WSL chroot tool |
| `/etc/rc.local.v24bak.*` | Build artifacts |
| `/usr/local/bunny.pre-v9.*` | Leftover backup |
| `/etc/systemd/system/getty.target.wants/serial-getty@ttyGS0.service` | Pre-enables ttyGS0 before gadget loads — causes boot hang |
| `/etc/systemd/system/bunny-framework.service` | Forbidden — conflicts with bunny.service |

---

## The serial-getty@ttyGS0 Boot Hang

**Problem:** If `serial-getty@ttyGS0.service` is symlinked in
`getty.target.wants/`, systemd tries to start it at boot before
`bunny_gadget.ko` is loaded. `/dev/ttyGS0` doesn't exist yet.
Getty hangs waiting for the device. Boot appears frozen after green LED.

**Stock behavior:** ATTACKMODE loads the gadget, then manually calls
`systemctl start serial-getty@ttyGS0.service`. The symlink must NOT
be pre-created.

**Fix:** Remove the symlink:
```bash
rm -f /etc/systemd/system/getty.target.wants/serial-getty@ttyGS0.service
```
