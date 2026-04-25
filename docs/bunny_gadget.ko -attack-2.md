f3ban@FA506NF:~/bb$ cd ~/bb

echo "===== STOCK INIT ====="
ls -l work/rootfs_mod/sbin/init
file work/rootfs_mod/lib/systemd/systemd

echo "===== NEW INIT ====="
ls -l new_rootfs/sbin/init
file new_rootfs/lib/systemd/systemd
===== STOCK INIT =====
lrwxrwxrwx 1 root root 20 Dec 31  1969 work/rootfs_mod/sbin/init -> /lib/systemd/systemd
work/rootfs_mod/lib/systemd/systemd: ELF 32-bit LSB executable, ARM, EABI5 version 1 (SYSV), dynamically linked, interpreter /lib/ld-linux-armhf.so.3, for GNU/Linux 2.6.32, BuildID[sha1]=6cc18a01c1bfdac2342292bf8e4db7e8829844e6, stripped
===== NEW INIT =====
lrwxrwxrwx 1 root root 20 Jun 26  2025 new_rootfs/sbin/init -> /lib/systemd/systemd
new_rootfs/lib/systemd/systemd: ELF 32-bit LSB pie executable, ARM, EABI5 version 1 (SYSV), dynamically linked, interpreter /lib/ld-linux-armhf.so.3, BuildID[sha1]=fd846dcf8647b28a2a6bc9ae92a6b250413fb613, for GNU/Linux 3.2.0, stripped
f3ban@FA506NF:~/bb$ cd ~/bb

sudo chroot new_rootfs /lib/systemd/systemd --version
systemd 252 (252.39-1~deb12u1)
+PAM +AUDIT +SELINUX +APPARMOR +IMA +SMACK +SECCOMP +GCRYPT -GNUTLS +OPENSSL +ACL +BLKID +CURL +ELFUTILS +FIDO2 +IDN2 -IDN +IPTC +KMOD +LIBCRYPTSETUP +LIBFDISK +PCRE2 -PWQUALITY +P11KIT +QRENCODE +TPM2 +BZIP2 +LZ4 +XZ +ZLIB +ZSTD -BPF_FRAMEWORK -XKBCOMMON +UTMP +SYSVINIT default-hierarchy=unified
f3ban@FA506NF:~/bb$ strings new_rootfs/lib/systemd/systemd | grep -Ei 'cgroup|unified|seccomp|bpf|landlock|ambient|namespace' | head -80
seccomp_restrict_archs
is_seccomp_available
mount_cgroup_controllers
capability_ambient_set_apply
Failed to mount cgroup hierarchies
f3ban@FA506NF:~/bb$ cd ~/bb

ls -l new_rootfs/etc/init.d/rcS
ls -l new_rootfs/etc/rcS.d
ls: cannot access 'new_rootfs/etc/init.d/rcS': No such file or directory
total 0
lrwxrwxrwx 1 root root 20 Apr 24 22:01 S01hwclock.sh -> ../init.d/hwclock.sh
lrwxrwxrwx 1 root root 14 Apr 24 22:03 S01kmod -> ../init.d/kmod
lrwxrwxrwx 1 root root 16 Apr 24 22:03 S01procps -> ../init.d/procps
lrwxrwxrwx 1 root root 14 Apr 24 22:03 S01udev -> ../init.d/udev
lrwxrwxrwx 1 root root 15 Apr 24 22:12 S03bunny -> ../init.d/bunny
f3ban@FA506NF:~/bb$ cd ~/bb

modinfo work/rootfs_mod/usr/local/bunny/lib/bunny_gadget.ko
filename:       /home/f3ban/bb/work/rootfs_mod/usr/local/bunny/lib/bunny_gadget.ko
license:        GPL
author:         David Brownell, Benedikt Spanger
description:    RNDIS/Ethernet Gadget
srcversion:     FCF6B0AFACE5D3F632E6DF1
depends:
intree:         Y
vermagic:       3.4.39 SMP preempt mod_unload modversions ARMv7 p2v8
parm:           is_rndis:We support rndis or cdc ecm exclusively. (int)
parm:           is_cdc_ecm:Include CDC ACM serial into CDC ether? (int)
parm:           is_cdc_serial:Include CDC ACM serial into CDC ether? (int)
parm:           is_hid:Include HID into g_ether? (int)
parm:           is_storage:Include HID into g_ether? (int)
parm:           rndis_speed:Set RNDIS Speed (uint)
parm:           idVendor:USB Vendor ID (ushort)
parm:           idProduct:USB Product ID (ushort)
parm:           bcdDevice:USB Device version (BCD) (ushort)
parm:           iManufacturer:USB Manufacturer string (charp)
parm:           iProduct:USB Product string (charp)
parm:           iSerialNumber:SerialNumber string (charp)
parm:           qmult:queue length multiplier at high/super speed (uint)
parm:           dev_addr:Device Ethernet Address (charp)
parm:           host_addr:Host Ethernet Address (charp)
parm:           file:names of backing files or devices (array of charp)
parm:           ro:true to force read-only (array of bool)
parm:           removable:true to simulate removable media (array of bool)
parm:           cdrom:true to simulate CD-ROM instead of disk (array of bool)
parm:           nofua:true to ignore SCSI WRITE(10,12) FUA bit (array of bool)
parm:           luns:number of LUNs (uint)
parm:           stall:false to prevent bulk stalls (bool)
parm:           use_eem:use CDC EEM mode (bool)
f3ban@FA506NF:~/bb$ vermagic
parm:
depends
vermagic: command not found
parm:: command not found
depends: command not found
f3ban@FA506NF:~/bb$
