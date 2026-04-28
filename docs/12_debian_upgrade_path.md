# 12 — Debian Upgrade Path

## Why Stock Firmware Needs Upgrading

Stock BB firmware runs **Debian 8 Jessie** (EOL June 2018).

Problems with Jessie:
- `apt-get update` fails — package mirrors are gone
- Must use `archive.debian.org` which is slow and requires workarounds
- Many packages unavailable or severely outdated
- Security vulnerabilities throughout

---

## Kernel Constraint

The BB Mark II runs kernel **3.4.39** (built Jan 31 2021).
This is an old kernel that limits which Debian versions are compatible.

| Debian Version | Codename | glibc | Min Kernel | Compatible |
|----------------|----------|-------|------------|------------|
| 8 | Jessie | 2.19 | 2.6.32 | ✅ (stock) |
| 9 | Stretch | 2.24 | 3.2 | ✅ |
| 10 | Buster | 2.28 | 3.2 | ✅ |
| 11 | Bullseye | 2.31 | 3.2 | ✅ **TARGET** |
| 12 | Bookworm | 2.36 | 3.2+ | ❌ |
| 13 | Trixie | 2.37+ | 4.19+ | ❌ |

---

## Why Bookworm (12) Fails

glibc 2.36 uses syscalls and kernel features not available in 3.4.39.
Attempting to run Bookworm userspace on 3.4.39 kernel results in:
- Systemd fails to initialize
- Basic tools crash with illegal instruction or missing syscall errors
- Device appears soft-bricked

**Confirmed:** `new_rootfs_debian12_failed_20260424_230228/` — Bookworm
rootfs that failed exactly this way.

---

## Why Bullseye (11) is the Target

- glibc 2.31 — compatible with kernel 3.2+, works on 3.4.39 ✅
- Active package mirrors at `deb.debian.org` until 2026 ✅
- `apt-get update/upgrade` works without hacks ✅
- Full armhf support ✅
- debootstrap available in standard WSL Ubuntu ✅

---

## Apt Sources for Bullseye

```
deb http://deb.debian.org/debian bullseye main contrib non-free
deb http://deb.debian.org/debian bullseye-updates main contrib non-free
deb http://security.debian.org/debian-security bullseye-security main contrib non-free
```

These are live mirrors — no archive.debian.org needed.

---

## Build Approach

1. `debootstrap --arch=armhf --foreign bullseye` — stage 1 on x86 host
2. `qemu-arm-static` chroot — stage 2 inside ARM environment
3. Drop in stock BB framework files with correct ownership
4. Build ext4 image with `--numeric-ids`
5. Pack as stock firmware

### Required WSL Tools
```
debootstrap        ✅ (confirmed installed)
qemu-user-static   ✅ (confirmed installed)
binfmt-support     ✅ (confirmed installed)
qemu-arm-static    ✅ at /usr/bin/qemu-arm-static
```

---

## Stretch (9) — Not Recommended

`/home/f3ban/bb/new_rootfs/` contains a Debian 9 Stretch rootfs.
Stretch is also EOL (June 2022) and still uses `archive.debian.org`.
Skip Stretch — go directly to Bullseye.

---

## Framework Compatibility

The stock BB framework binaries are statically linked or linked against
Jessie-era libraries. They run fine on Bullseye because:

- `bunny_framework` — bash script, no binary compat issues
- `ATTACKMODE` — bash script, no binary compat issues  
- `bunny_gadget.ko` — kernel module, kernel ABI is fixed at 3.4.39

The `.ko` is tied to the kernel version, not the userspace Debian version.
As long as the kernel doesn't change, the module works regardless of
which Debian version is in userspace.

---

## Future: Full Port

Once Bullseye hybrid firmware is confirmed working, the full port involves:
- Rebuilding kernel 3.4.39 with updated config if needed
- Or upgrading to a newer kernel that supports the BB hardware
- Full Bullseye userspace with no Jessie remnants

This is out of scope until the hybrid firmware is confirmed stable.
