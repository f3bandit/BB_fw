# Bash Bunny Hybrid Firmware Build Notes and Handoff

## Purpose

This document captures the working findings from the Bash Bunny hybrid firmware work. It is intended as a detailed handoff/reference for continuing development without losing the state of what has already been proven, what broke, and why.

The goal of the project is to build a newer non-EOL userspace/rootfs for the Bash Bunny while preserving the stock firmware updater structure, stock kernel/uImage, stock Hak5 Bunny framework components, USB gadget behavior, storage behavior, and payload-driven ATTACKMODE behavior.

---

## High-Level Result So Far

A hybrid firmware can be built and flashed using:

- Stock firmware update package layout.
- Stock `uImage` kernel.
- Newer Debian-based `armhf` rootfs.
- Stock `/usr/local/bunny` framework copied into the new rootfs.
- Stock `bunny_gadget.ko` kernel module preserved.
- Correct firmware archive layout:

```text
upgrade/
upgrade/cherry.rootfs.tar
upgrade/uImage
upgrade/uImage.md5
upgrade/cherry.rootfs.tar.md5
```

A firmware package with the wrong archive nesting will not be accepted correctly by the updater.

---

## Known Working Directory Layout on WSL

Main working directory:

```text
~/bb
```

Known subdirectories used:

```text
~/bb/analysis
~/bb/mount
~/bb/nand
~/bb/reports
~/bb/update
~/bb/new_rootfs
~/bb/new_nandd.img
~/bb/work/rootfs_mod
```

Important meanings:

| Path | Meaning |
|---|---|
| `~/bb/work/rootfs_mod` | Extracted/modified stock rootfs reference tree. Used to compare stock behavior. |
| `~/bb/new_rootfs` | New hybrid Debian rootfs tree being built and patched. |
| `~/bb/new_nandd.img` | Loopback ext4 rootfs image used to repack `cherry.rootfs.tar`. |
| `~/bb/update` | Firmware updater working folder. |
| `~/bb/update/extracted/upgrade` | Extracted stock updater contents. Contains `uImage`, `uImage.md5`, `cherry.rootfs.tar`, `cherry.rootfs.tar.md5`. |
| `~/bb/ch_fw_custom.tar.gz` | Final custom firmware tarball after correct repack. |
| `/mnt/c/Users/f3ban/Downloads/ch_fw_custom.tar.gz` | Windows-visible final firmware package location. |

---

## Firmware Updater Structure

The Bash Bunny firmware updater expects the tarball root to contain an `upgrade/` directory directly.

Correct:

```text
ch_fw_custom.tar.gz
└── upgrade/
    ├── cherry.rootfs.tar
    ├── cherry.rootfs.tar.md5
    ├── uImage
    └── uImage.md5
```

Incorrect:

```text
ch_fw_custom.tar.gz
└── extracted/
    └── upgrade/
        ├── cherry.rootfs.tar
        ├── cherry.rootfs.tar.md5
        ├── uImage
        └── uImage.md5
```

The updater does not expect `extracted/upgrade/...`. If the archive is one directory too deep, the flash process can appear to run but the firmware payload is not laid out as expected.

Correct final package command from `~/bb/update/extracted`:

```bash
cd ~/bb/update/extracted
tar -czvf ../../ch_fw_custom.tar.gz upgrade
```

Verification command:

```bash
tar -tf ~/bb/ch_fw_custom.tar.gz | head
```

Expected output:

```text
upgrade/
upgrade/cherry.rootfs.tar
upgrade/uImage
upgrade/uImage.md5
upgrade/cherry.rootfs.tar.md5
```

---

## Rootfs Image Build Flow

The hybrid rootfs is first built as a directory tree at:

```text
~/bb/new_rootfs
```

Then it is copied into an ext4 image:

```text
~/bb/new_nandd.img
```

Known rootfs image build commands:

```bash
cd ~/bb

rm -f new_nandd.img
rm -rf mount_new

dd if=/dev/zero of=new_nandd.img bs=1M count=3500
mkfs.ext4 -F new_nandd.img

mkdir -p mount_new
sudo mount -o loop new_nandd.img mount_new
sudo rsync -aHAX --numeric-ids ~/bb/new_rootfs/ mount_new/
sync
sudo umount mount_new
```

For small later fixes, do not rebuild the image from scratch. Re-sync into the existing image:

```bash
cd ~/bb

mkdir -p mount_fix
sudo mount -o loop ~/bb/new_nandd.img mount_fix
sudo rsync -aHAX --numeric-ids ~/bb/new_rootfs/ mount_fix/
sync
sudo umount mount_fix
```

---

## Rootfs Tar Repack Flow

After `new_nandd.img` is updated, repack `cherry.rootfs.tar`:

```bash
cd ~/bb/update/extracted/upgrade

rm -f cherry.rootfs.tar cherry.rootfs.tar.md5

mkdir rootfs_tmp
sudo mount -o loop ~/bb/new_nandd.img rootfs_tmp
sudo tar -cvf cherry.rootfs.tar -C rootfs_tmp .
sudo umount rootfs_tmp
rm -rf rootfs_tmp

md5sum cherry.rootfs.tar > cherry.rootfs.tar.md5
```

Verify MD5:

```bash
cd ~/bb/update/extracted/upgrade
md5sum cherry.rootfs.tar
cat cherry.rootfs.tar.md5
```

The two hash values must match exactly.

Then repack final firmware:

```bash
cd ~/bb/update/extracted
tar -czvf ../../ch_fw_custom.tar.gz upgrade
```

Copy to Windows:

```bash
cp ~/bb/ch_fw_custom.tar.gz /mnt/c/Users/f3ban/Downloads/
```

Windows path:

```text
C:\Users\f3ban\Downloads\ch_fw_custom.tar.gz
```

---

## Pre-Flash Validation Checklist

Before copying/flashing, run these checks.

### Verify rcS

```bash
grep "exec /etc/init.d/rc S" ~/bb/new_rootfs/etc/init.d/rcS
ls -l ~/bb/new_rootfs/etc/init.d/rcS
```

Expected:

```text
exec /etc/init.d/rc S
-rwxr-xr-x ... rcS
```

### Verify rc.local

```bash
grep bunny_framework ~/bb/new_rootfs/etc/rc.local
ls -l ~/bb/new_rootfs/etc/rc.local
```

Expected:

```text
/usr/local/bunny/bin/bunny_framework ... &
-rwxr-xr-x ... rc.local
```

### Verify Bunny framework exists

```bash
ls -l ~/bb/new_rootfs/usr/local/bunny/bin/bunny_framework
```

Expected:

```text
-rwxr-xr-x ... bunny_framework
```

### Verify login binary permissions

```bash
ls -l ~/bb/new_rootfs/bin/login
ls -l ~/bb/new_rootfs/bin/su
ls -l ~/bb/new_rootfs/usr/bin/passwd
```

Expected:

```text
-rwsr-xr-x root root ... /bin/login
-rwsr-xr-x root root ... /bin/su
-rwsr-xr-x root root ... /usr/bin/passwd
```

### Verify serial root login allowed

```bash
grep ttyGS0 ~/bb/new_rootfs/etc/securetty
```

Expected:

```text
ttyGS0
```

### Verify image contains changes

```bash
cd ~/bb
mkdir -p test_mount
sudo mount -o loop ~/bb/new_nandd.img test_mount

ls -l test_mount/bin/login
ls -l test_mount/bin/su
ls -l test_mount/usr/bin/passwd
grep ttyGS0 test_mount/etc/securetty
ls test_mount/usr/local/bunny/bin/

sudo umount test_mount
```

### Verify final firmware tar structure

```bash
tar -tf ~/bb/ch_fw_custom.tar.gz | head
```

Expected:

```text
upgrade/
upgrade/cherry.rootfs.tar
upgrade/uImage
upgrade/uImage.md5
upgrade/cherry.rootfs.tar.md5
```

---

## Stock vs Hybrid Findings

The stock rootfs reference used for comparison was:

```text
~/bb/work/rootfs_mod
```

The hybrid rootfs tree was:

```text
~/bb/new_rootfs
```

Important stock/hybrid comparison commands:

```bash
cd ~/bb

mkdir -p reports/stock_auth

sudo cp work/rootfs_mod/etc/passwd reports/stock_auth/passwd.stock
sudo cp work/rootfs_mod/etc/shadow reports/stock_auth/shadow.stock
sudo cp work/rootfs_mod/etc/group reports/stock_auth/group.stock
sudo cp work/rootfs_mod/etc/securetty reports/stock_auth/securetty.stock 2>/dev/null || true
sudo cp work/rootfs_mod/etc/nsswitch.conf reports/stock_auth/nsswitch.stock 2>/dev/null || true

sudo cp new_rootfs/etc/passwd reports/stock_auth/passwd.hybrid
sudo cp new_rootfs/etc/shadow reports/stock_auth/shadow.hybrid
sudo cp new_rootfs/etc/group reports/stock_auth/group.hybrid
sudo cp new_rootfs/etc/securetty reports/stock_auth/securetty.hybrid 2>/dev/null || true
sudo cp new_rootfs/etc/nsswitch.conf reports/stock_auth/nsswitch.hybrid 2>/dev/null || true
```

Diff commands:

```bash
diff -u reports/stock_auth/passwd.stock reports/stock_auth/passwd.hybrid | tee reports/stock_auth/diff_passwd.txt
diff -u reports/stock_auth/shadow.stock reports/stock_auth/shadow.hybrid | tee reports/stock_auth/diff_shadow.txt
diff -u reports/stock_auth/group.stock reports/stock_auth/group.hybrid | tee reports/stock_auth/diff_group.txt
diff -u reports/stock_auth/securetty.stock reports/stock_auth/securetty.hybrid | tee reports/stock_auth/diff_securetty.txt
diff -u reports/stock_auth/nsswitch.stock reports/stock_auth/nsswitch.hybrid | tee reports/stock_auth/diff_nsswitch.txt
```

Key stock root user line:

```text
root:x:0:0:root:/root:/bin/bash
```

Stock `/etc/securetty` contains:

```text
ttyGS0
```

This matters because the Bash Bunny serial console appears as:

```text
ttyGS0
```

If `ttyGS0` is missing from `/etc/securetty`, root login over USB serial can be blocked even when the password/shadow file is otherwise correct.

---

## Serial Login Findings

The serial console prompt observed:

```text
Debian GNU/Linux 9 FA506NF ttyGS0

FA506NF login:
```

Important behavior observed:

- Pressing Enter at the login prompt proceeds to password prompt.
- Typing `root` previously looped back to login.
- That behavior strongly indicated login/auth binary permission problems, not merely a wrong password.

Expected working serial login after fixes:

```text
login: root
password: [press ENTER]
```

The intended root auth state during testing is root with a blank password, but only after:

1. `/etc/securetty` includes `ttyGS0`.
2. `login`, `su`, and `passwd` have correct root ownership and setuid bits.
3. The corrected files are synced into `new_nandd.img`.
4. `cherry.rootfs.tar` and final firmware are repacked.

---

## Critical Authentication Bug Found

The major confirmed login breakage was stripped setuid/root ownership on auth binaries in `new_rootfs`.

Stock permissions:

```text
work/rootfs_mod/bin/login      -rwxr-xr-x root root
work/rootfs_mod/bin/su         -rwsr-xr-x root root
work/rootfs_mod/usr/bin/passwd -rwsr-xr-x root root
```

Broken hybrid permissions previously observed:

```text
new_rootfs/bin/login           -rwxr-xr-x f3ban f3ban
new_rootfs/bin/su              -rwxr-xr-x f3ban f3ban
new_rootfs/usr/bin/passwd      -rwxr-xr-x f3ban f3ban
```

Fixed hybrid permissions:

```text
new_rootfs/bin/login           -rwsr-xr-x root root
new_rootfs/bin/su              -rwsr-xr-x root root
new_rootfs/usr/bin/passwd      -rwsr-xr-x root root
```

Fix commands:

```bash
sudo chown root:root ~/bb/new_rootfs/bin/login
sudo chown root:root ~/bb/new_rootfs/bin/su
sudo chown root:root ~/bb/new_rootfs/usr/bin/passwd

sudo chmod 4755 ~/bb/new_rootfs/bin/login
sudo chmod 4755 ~/bb/new_rootfs/bin/su
sudo chmod 4755 ~/bb/new_rootfs/usr/bin/passwd
```

Verify:

```bash
ls -l ~/bb/new_rootfs/bin/login
ls -l ~/bb/new_rootfs/bin/su
ls -l ~/bb/new_rootfs/usr/bin/passwd
```

Expected:

```text
-rwsr-xr-x 1 root root ... /home/f3ban/bb/new_rootfs/bin/login
-rwsr-xr-x 1 root root ... /home/f3ban/bb/new_rootfs/bin/su
-rwsr-xr-x 1 root root ... /home/f3ban/bb/new_rootfs/usr/bin/passwd
```

Fix `securetty`:

```bash
echo ttyGS0 | sudo tee -a ~/bb/new_rootfs/etc/securetty
```

Verify:

```bash
grep ttyGS0 ~/bb/new_rootfs/etc/securetty
```

---

## Boot Chain Findings

### rcS

The file:

```text
/etc/init.d/rcS
```

should be left as the stock-style simple handoff:

```sh
#! /bin/sh
#
# rcS
#
# Call all S??* scripts in /etc/rcS.d/ in numerical/alphabetical order
#

exec /etc/init.d/rc S
```

Important finding:

Do not append commands after:

```sh
exec /etc/init.d/rc S
```

Reason:

```text
exec replaces the current shell process.
```

Anything after `exec /etc/init.d/rc S` is dead code and will never run.

A previous attempted `rcS` hack looked like:

```sh
exec /etc/init.d/rc S

echo "[RC.S] launching bunny_framework" > /root/udisk/rcS_debug.txt
/usr/local/bunny/bin/bunny_framework >> /root/udisk/rcS_debug.txt 2>&1 &
```

This does not work because the `echo` and `bunny_framework` lines are never reached.

### rc.local

The hybrid rootfs has rc.local links in runlevel directories, including:

```text
/etc/rc2.d/S03rc.local -> ../init.d/rc.local
/etc/rc3.d/S03rc.local -> ../init.d/rc.local
/etc/rc4.d/S03rc.local -> ../init.d/rc.local
/etc/rc5.d/S03rc.local -> ../init.d/rc.local
```

The practical boot hook is:

```text
/etc/rc.local
```

A safe debug rc.local used during bring-up:

```sh
#!/bin/sh

LOG=/root/udisk/rc_boot_debug.txt

echo "[RC.LOCAL] START" > $LOG
date >> $LOG

touch /root/udisk/rc_test.txt

echo "[RC.LOCAL] starting bunny_framework" >> $LOG
/usr/local/bunny/bin/bunny_framework >> $LOG 2>&1 &

echo "[RC.LOCAL] DONE" >> $LOG

exit 0
```

Expected debug files after boot:

```text
/root/udisk/rc_boot_debug.txt
/root/udisk/rc_test.txt
```

Because SSH and serial were not always reliable during bring-up, writing debug files to `/root/udisk` is the best validation method.

---

## Systemd vs SysV Notes

The hybrid rootfs contains systemd files such as:

```text
/lib/systemd/system/rc.local.service
/lib/systemd/system/rc-local.service
/lib/systemd/system-generators/systemd-rc-local-generator
```

However, the observed SysV-style boot files and runlevel links are still important:

```text
/etc/init.d/rcS
/etc/init.d/rc
/etc/init.d/rc.local
/etc/rcS.d/
/etc/rc2.d/
```

Do not assume pure systemd behavior without proving what `/sbin/init` is actually doing on device.

Known safe principle:

- Verify what stock does before patching.
- Prefer matching stock boot flow where possible.
- Avoid adding duplicate startup paths for `bunny_framework`.

---

## Bunny Framework Files

Stock Bunny framework must be preserved/copied into the hybrid rootfs:

```text
/usr/local/bunny/
```

Important binaries observed:

```text
/usr/local/bunny/bin/ATTACKMODE
/usr/local/bunny/bin/LED
/usr/local/bunny/bin/Q
/usr/local/bunny/bin/QUACK
/usr/local/bunny/bin/bunny_framework
/usr/local/bunny/bin/factory_reset_bunny
/usr/local/bunny/bin/sysfixtime
/usr/local/bunny/bin/udisk
```

Important module:

```text
/usr/local/bunny/lib/bunny_gadget.ko
```

Verification command:

```bash
ls ~/bb/new_rootfs/usr/local/bunny/bin/
ls ~/bb/new_rootfs/usr/local/bunny/lib/
```

Expected Bunny bin listing includes:

```text
ATTACKMODE
LED
Q
QUACK
bunny_framework
factory_reset_bunny
sysfixtime
udisk
```

---

## How Bunny Framework Should Start

The Bunny framework should be started once, not multiple times.

Preferred test hook in `/etc/rc.local`:

```sh
/usr/local/bunny/bin/bunny_framework >> /root/udisk/rc_boot_debug.txt 2>&1 &
```

The Bunny framework is responsible for:

- Initializing Bunny runtime behavior.
- Reading switch position.
- Mounting or preparing `/root/udisk`.
- Launching switch payloads.
- Eventually allowing payload-controlled `ATTACKMODE`.

Do not directly force ATTACKMODE from rc.local during normal boot unless specifically testing USB gadget behavior.

---

## ATTACKMODE and USB Gadget Findings

The Bash Bunny USB personality is payload-driven.

The user clarified that networking is controlled by `RNDIS_ETHERNET` being called in the switch payload:

```text
payload.txt for SW1 or SW2 controls whether RNDIS_ETHERNET is enabled.
```

Example payload ATTACKMODE:

```text
ATTACKMODE RNDIS_ETHERNET STORAGE
```

or:

```text
ATTACKMODE SERIAL RNDIS_ETHERNET STORAGE
```

Important finding:

Do not force ATTACKMODE in `rc.local` while also allowing the Bunny payload system to call ATTACKMODE. That risks double gadget initialization.

Bad pattern:

```sh
/usr/local/bunny/bin/bunny_framework &
sleep 8
/usr/local/bunny/bin/ATTACKMODE SERIAL RNDIS_ETHERNET STORAGE
```

Why it breaks:

```text
bunny_framework -> payload -> ATTACKMODE
rc.local        -> forced ATTACKMODE
```

This can cause two separate gadget setup attempts. Embedded USB gadget state is timing-sensitive. Double initialization can cause:

- USB instability.
- Storage disconnects.
- RNDIS appearing briefly then crashing.
- Serial disappearing.
- Windows device re-enumeration failures.
- Boot appearing to hang or crash after gadget init.

Correct approach:

```text
Start bunny_framework once.
Let payload.txt choose ATTACKMODE.
```

---

## bunny_gadget.ko Findings

The stock kernel module:

```text
/usr/local/bunny/lib/bunny_gadget.ko
```

is central to Bash Bunny USB device behavior.

It must match the stock kernel/uImage. Since this hybrid build keeps the stock `uImage`, the stock `bunny_gadget.ko` should also be preserved.

Do not replace `uImage` without also re-evaluating:

- Kernel module ABI compatibility.
- `bunny_gadget.ko` vermagic.
- USB gadget driver expectations.
- ATTACKMODE implementation assumptions.

Known behavior:

- If Bunny framework/ATTACKMODE initializes gadget once, USB can enumerate.
- If gadget setup is forced twice or racing between boot scripts and payloads, storage/RNDIS/serial can become unstable.
- RNDIS may appear first and then crash when storage is added if gadget state is inconsistent.

Recommended future analysis commands:

```bash
modinfo ~/bb/new_rootfs/usr/local/bunny/lib/bunny_gadget.ko 2>/dev/null || true
file ~/bb/new_rootfs/usr/local/bunny/lib/bunny_gadget.ko
strings ~/bb/new_rootfs/usr/local/bunny/lib/bunny_gadget.ko | less
```

On device after login, useful commands:

```sh
lsmod
modprobe bunny_gadget 2>&1
insmod /usr/local/bunny/lib/bunny_gadget.ko 2>&1
dmesg | tail -100
ls /sys/class/udc 2>/dev/null
ls /sys/kernel/config/usb_gadget 2>/dev/null
```

Do not run these blindly in production boot scripts until login/debug is stable.

---

## Storage Findings

The Bash Bunny exposes storage from the udisk area. Runtime path:

```text
/root/udisk
```

Not:

```text
/mnt/udisk
```

Debug files should be written to:

```text
/root/udisk/
```

Example:

```sh
echo "[BOOT] test" > /root/udisk/boot_test.txt
```

This lets Windows see the debug result through the Bunny storage drive if `ATTACKMODE STORAGE` or equivalent storage exposure works.

Important note:

If `bunny_framework` is not running, payloads will not execute and storage may not be exposed the way stock firmware does.

If `bunny_framework` starts but ATTACKMODE is unstable/double-called, storage may appear and then drop.

---

## Networking Findings

RNDIS is not supposed to be globally forced during boot. It is controlled by payload ATTACKMODE.

Known issue:

- `ATTACKMODE RNDIS_ETHERNET STORAGE` on SW1 brought RNDIS up first, then appeared to crash after storage loaded.

Likely cause:

- USB gadget race/double initialization.
- Kernel/userspace mismatch around gadget setup.
- Payload ATTACKMODE and boot-time forced ATTACKMODE competing.

Correct staged bring-up order:

1. Boot with safe storage/logging only.
2. Confirm `/root/udisk` debug files are created.
3. Confirm serial login works.
4. Start Bunny framework once.
5. Test `ATTACKMODE STORAGE` only.
6. Test `ATTACKMODE SERIAL STORAGE`.
7. Test `ATTACKMODE RNDIS_ETHERNET STORAGE`.
8. Only after each mode works, combine modes.

---

## Services and Init Notes

Do not create duplicate Bunny startup services unless needed.

Earlier, an `/etc/init.d/bunny` service was considered/created in one iteration. That can cause duplicate startup if rc.local also starts Bunny framework.

Check for duplicates:

```bash
grep -R "bunny_framework" ~/bb/new_rootfs/etc/init.d ~/bb/new_rootfs/etc/rc*.d ~/bb/new_rootfs/etc/rc.local
```

Desired result during current bring-up:

```text
Only /etc/rc.local starts bunny_framework.
```

Disable duplicate Bunny init links if present:

```bash
sudo rm -f ~/bb/new_rootfs/etc/rc2.d/*bunny
sudo rm -f ~/bb/new_rootfs/etc/rc3.d/*bunny
sudo rm -f ~/bb/new_rootfs/etc/rc4.d/*bunny
sudo rm -f ~/bb/new_rootfs/etc/rc5.d/*bunny
sudo rm -f ~/bb/new_rootfs/etc/rcS.d/*bunny
```

---

## SSH Findings

SSH was not reliable initially. Serial became the better debug channel once `ttyGS0` appeared.

Do not assume SSH is working until:

- RNDIS is stable.
- IP config is known.
- SSH service starts successfully.
- Root authentication is confirmed.

Avoid relying on:

```sh
service ssh start
```

as a required boot step during early bring-up. If `service ssh start` fails and rc.local uses `#!/bin/sh -e`, the script may abort before starting `bunny_framework`.

Safer rc.local shebang during debugging:

```sh
#!/bin/sh
```

Not:

```sh
#!/bin/sh -e
```

Reason:

`-e` exits on command failure. A non-critical SSH failure can stop the rest of the boot script.

---

## rc.local Safe Versions

### Minimal proof rc.local

Use this to prove rc.local executes without starting Bunny framework:

```sh
#!/bin/sh

LOG=/root/udisk/boot_safe.txt

echo "[SAFE BOOT]" > $LOG
date >> $LOG

touch /root/udisk/boot_ok.txt

exit 0
```

Expected files:

```text
/root/udisk/boot_safe.txt
/root/udisk/boot_ok.txt
```

### Bunny framework debug rc.local

Use this after safe boot is proven:

```sh
#!/bin/sh

LOG=/root/udisk/rc_boot_debug.txt

echo "[RC.LOCAL] START" > $LOG
date >> $LOG

touch /root/udisk/rc_test.txt

echo "[RC.LOCAL] starting bunny_framework" >> $LOG
/usr/local/bunny/bin/bunny_framework >> $LOG 2>&1 &

echo "[RC.LOCAL] DONE" >> $LOG

exit 0
```

Do not add forced ATTACKMODE here during normal bring-up.

---

## Known Bad Patterns

### Running target script content in WSL

Do not paste this directly into WSL as commands:

```sh
#!/bin/sh
LOG=/tmp/bunny.log
...
```

That is target file content, not a host command.

Correct method:

```bash
sudo tee ~/bb/new_rootfs/etc/rc.local >/dev/null <<'EOF'
#!/bin/sh
...
EOF
```

### Removing bunny_framework from boot

A build where rc.local only had:

```sh
#!/bin/sh

echo "[DEBUG] rc.local started" > /tmp/debug.log

exit 0
```

broke Bunny behavior because nothing started the Bunny framework.

Result:

- No payload execution.
- No ATTACKMODE.
- No expected USB personalities.

### Adding code after `exec` in rcS

Does not run.

### Forcing ATTACKMODE in rc.local

Can race with payload ATTACKMODE and break USB gadget enumeration.

### Losing setuid bits

Breaks login/authentication.

### Missing `ttyGS0` from securetty

Blocks root login on USB serial.

### Wrong final tar nesting

Breaks updater expectations.

---

## Known Good Current Fixes to Preserve

These should remain in the working hybrid rootfs:

```bash
sudo chown root:root ~/bb/new_rootfs/bin/login
sudo chown root:root ~/bb/new_rootfs/bin/su
sudo chown root:root ~/bb/new_rootfs/usr/bin/passwd

sudo chmod 4755 ~/bb/new_rootfs/bin/login
sudo chmod 4755 ~/bb/new_rootfs/bin/su
sudo chmod 4755 ~/bb/new_rootfs/usr/bin/passwd

grep -q '^ttyGS0$' ~/bb/new_rootfs/etc/securetty || echo ttyGS0 | sudo tee -a ~/bb/new_rootfs/etc/securetty
```

And:

```text
/etc/init.d/rcS should only exec /etc/init.d/rc S.
/etc/rc.local should be executable.
/etc/rc.local should start bunny_framework once.
/usr/local/bunny must exist.
/usr/local/bunny/lib/bunny_gadget.ko must exist.
Final firmware tar must contain upgrade/ at archive root.
```

---

## Recommended Next Debug Steps

After flashing the fixed auth build:

1. Connect serial.
2. Confirm prompt:

```text
Debian GNU/Linux 9 FA506NF ttyGS0
FA506NF login:
```

3. Login:

```text
login: root
password: [ENTER]
```

4. Once logged in, check:

```sh
whoami
mount
ls -l /root/udisk
ls -l /usr/local/bunny/bin
ls -l /usr/local/bunny/lib/bunny_gadget.ko
lsmod
dmesg | tail -100
```

5. Check Bunny framework manually only if it did not start:

```sh
ps aux | grep bunny
/usr/local/bunny/bin/bunny_framework
```

6. Check USB gadget messages:

```sh
dmesg | grep -i gadget
dmesg | grep -i usb
dmesg | grep -i rndis
dmesg | grep -i mass
```

7. Test ATTACKMODE in stages:

```sh
/usr/local/bunny/bin/ATTACKMODE STORAGE
/usr/local/bunny/bin/ATTACKMODE SERIAL STORAGE
/usr/local/bunny/bin/ATTACKMODE RNDIS_ETHERNET STORAGE
```

Do not test all modes at once until simple modes are stable.

---

## Final Known Working Build/Repack Sequence After a Small Fix

Use this after making small changes in `~/bb/new_rootfs`:

```bash
cd ~/bb

mkdir -p mount_fix
sudo mount -o loop ~/bb/new_nandd.img mount_fix
sudo rsync -aHAX --numeric-ids ~/bb/new_rootfs/ mount_fix/
sync
sudo umount mount_fix
```

```bash
cd ~/bb/update/extracted/upgrade

rm -f cherry.rootfs.tar cherry.rootfs.tar.md5

mkdir rootfs_tmp
sudo mount -o loop ~/bb/new_nandd.img rootfs_tmp
sudo tar -cvf cherry.rootfs.tar -C rootfs_tmp .
sudo umount rootfs_tmp
rm -rf rootfs_tmp

md5sum cherry.rootfs.tar > cherry.rootfs.tar.md5
```

```bash
cd ~/bb/update/extracted
tar -czvf ../../ch_fw_custom.tar.gz upgrade
```

```bash
tar -tf ~/bb/ch_fw_custom.tar.gz | head
cp ~/bb/ch_fw_custom.tar.gz /mnt/c/Users/f3ban/Downloads/
```

---

## Summary of Most Important Lessons

1. The updater archive structure matters exactly.
2. The stock kernel and `bunny_gadget.ko` should stay matched.
3. `bunny_framework` must start once, not zero times and not twice.
4. Payloads should control ATTACKMODE.
5. Do not force ATTACKMODE in rc.local during normal boot.
6. `rcS` uses `exec`; anything after the exec line is dead code.
7. `/root/udisk` is the correct runtime storage/debug path.
8. Serial is `ttyGS0` and must be present in `/etc/securetty` for root login.
9. Login failure was caused by bad ownership/setuid bits on auth binaries.
10. Always compare against stock before guessing.
11. Always verify the mounted image, not just `new_rootfs`.
12. Always verify `cherry.rootfs.tar.md5` and final tar structure before flashing.

