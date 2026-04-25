
Debian GNU/Linux 8 bunny ttyGS0

bunny login: root
Password:
Linux bunny 3.4.39 #2 SMP PREEMPT Sun Jan 31 10:25:36 CST 2021 armv7l
           _____  _____  _____  _____     _____  _____  _____  _____  __ __
 (\___/)  | __  ||  _  ||   __||  |  |   | __  ||  |  ||   | ||   | ||  |  |
 (='.'=)  | __ -||     ||__   ||     |   | __ -||  |  || | | || | | ||_   _|
 (")_(")  |_____||__|__||_____||__|__|   |_____||_____||_|___||_|___|  |_|
 Bash Bunny by Hak5     USB Attack/Automation Platform

root@bunny:~# passwd
Enter new UNIX password:
Retype new UNIX password:
passwd: password updated successfully
root@bunny:~# cat /proc/cpuinfo
Processor       : ARMv7 Processor rev 5 (v7l)
processor       : 0
BogoMIPS        : 1920.00

processor       : 1
BogoMIPS        : 1920.00

processor       : 2
BogoMIPS        : 1920.00

processor       : 3
BogoMIPS        : 1920.00

Features        : swp half thumb fastmult vfp edsp thumbee neon vfpv3 tls vfpv4 idiva idivt
CPU implementer : 0x41
CPU architecture: 7
CPU variant     : 0x0
CPU part        : 0xc07
CPU revision    : 5

Hardware        : sun8i
Revision        : 0000
Serial          : 25307942840844390854
root@bunny:~# cat /proc/version
Linux version 3.4.39 (root@xbing-VirtualBox) (gcc version 4.6.3 20120201 (prerelease) (crosstool-NG linaro-1.13.1-2012.02-20120222 - Linaro GCC 2012.02) ) #2 SMP PREEMPT Sun Jan 31 10:25:36 CST 2021
root@bunny:~# uname -a
Linux bunny 3.4.39 #2 SMP PREEMPT Sun Jan 31 10:25:36 CST 2021 armv7l GNU/Linux
root@bunny:~# cat /proc/mtd
cat: /proc/mtd: No such file or directory
root@bunny:~# cat /proc/partitions
major minor  #blocks  name

  93        0      16384 nanda
  93        8      16384 nandb
  93       16      16384 nandc
  93       24    3407872 nandd
  93       32      32768 nande
  93       40    1835008 nandf
  93       48     753664 nandg
  93       56    1310720 nandh
  93       64     303104 nandi
root@bunny:~# mount
/dev/nandd on / type ext4 (rw,relatime,data=ordered)
devtmpfs on /dev type devtmpfs (rw,relatime,size=171872k,nr_inodes=42968,mode=755)
sysfs on /sys type sysfs (rw,nosuid,nodev,noexec,relatime)
proc on /proc type proc (rw,nosuid,nodev,noexec,relatime)
securityfs on /sys/kernel/security type securityfs (rw,nosuid,nodev,noexec,relatime)
tmpfs on /dev/shm type tmpfs (rw,nosuid,nodev)
devpts on /dev/pts type devpts (rw,nosuid,noexec,relatime,gid=5,mode=620,ptmxmode=000)
tmpfs on /run type tmpfs (rw,nosuid,nodev,mode=755)
tmpfs on /run/lock type tmpfs (rw,nosuid,nodev,noexec,relatime,size=5120k)
tmpfs on /sys/fs/cgroup type tmpfs (ro,nosuid,nodev,noexec,mode=755)
cgroup on /sys/fs/cgroup/systemd type cgroup (rw,nosuid,nodev,noexec,relatime,release_agent=/lib/systemd/systemd-cgroups-agent,name=systemd)
cgroup on /sys/fs/cgroup/debug type cgroup (rw,nosuid,nodev,noexec,relatime,debug)
cgroup on /sys/fs/cgroup/cpu,cpuacct type cgroup (rw,nosuid,nodev,noexec,relatime,cpuacct,cpu)
cgroup on /sys/fs/cgroup/freezer type cgroup (rw,nosuid,nodev,noexec,relatime,freezer)
root@bunny:~# lsmod
Module                  Size  Used by
g_ether                77006  2
root@bunny:~# dmesg | head -120
[    8.443326] EXT4-fs (nandg): recovery complete
[    8.446679] EXT4-fs (nandg): mounted filesystem with ordered data mode. Opts: (null)
[   11.870526] usb open backing file: /dev/nandf, 0xd3cf0400
[   11.870847] g_ether gadget: Mass Storage Function, version: 2009/09/11
[   11.870879] g_ether gadget: Number of LUNs=1
[   11.870931]  lun0: LUN: removable file: /dev/nandf
[   11.871000] gadget_is_softwinner_otg is not -int
[   11.871021] gadget_is_softwinner_otg is not -int
[   11.871069] g_ether gadget: Ethernet Gadget, version: Memorial Day 2008
[   11.871124] g_ether gadget: g_ether ready
[   12.159134] g_ether gadget: high-speed config #2: CDC Ethernet (ECM)
[   12.183050] WRN:L1135(drivers/usb/sunxi_usb/udc/sunxi_udc.c):handle_ep0: ep0 setup end
[  168.559319] WRN:L1135(drivers/usb/sunxi_usb/udc/sunxi_udc.c):handle_ep0: ep0 setup end
root@bunny:~# dmesg | grep -Ei 'nand|ubi|mtd|usb|gadget|sunxi|allwinner|otg|musb|dwc'
[    8.443326] EXT4-fs (nandg): recovery complete
[    8.446679] EXT4-fs (nandg): mounted filesystem with ordered data mode. Opts: (null)
[   11.870526] usb open backing file: /dev/nandf, 0xd3cf0400
[   11.870847] g_ether gadget: Mass Storage Function, version: 2009/09/11
[   11.870879] g_ether gadget: Number of LUNs=1
[   11.870931]  lun0: LUN: removable file: /dev/nandf
[   11.871000] gadget_is_softwinner_otg is not -int
[   11.871021] gadget_is_softwinner_otg is not -int
[   11.871069] g_ether gadget: Ethernet Gadget, version: Memorial Day 2008
[   11.871124] g_ether gadget: g_ether ready
[   12.159134] g_ether gadget: high-speed config #2: CDC Ethernet (ECM)
[   12.183050] WRN:L1135(drivers/usb/sunxi_usb/udc/sunxi_udc.c):handle_ep0: ep0 setup end
[  168.559319] WRN:L1135(drivers/usb/sunxi_usb/udc/sunxi_udc.c):handle_ep0: ep0 setup end
root@bunny:~# ls -R /lib/modules
ls: cannot access /lib/modules: No such file or directory
root@bunny:~# ls -R /boot 2>/dev/null
/boot:
root@bunny:~# ls -R /usr/local/bunny
/usr/local/bunny:
bin  hid_reader.py  lib  recovery_patches  udisk  update_recovery.sh

/usr/local/bunny/bin:
ATTACKMODE  Q      bunny_framework      sysfixtime
LED         QUACK  factory_reset_bunny  udisk

/usr/local/bunny/lib:
bunny_gadget.ko  languages

/usr/local/bunny/lib/languages:
be.json     ca.json  de.json     es.json  gb.json  mx.json  se.json  us.json
br.json     ch.json  dk.json     fi.json  hr.json  no.json  si.json
ca-fr.json  cz.json  es-la.json  fr.json  it.json  pt.json  sk.json

/usr/local/bunny/recovery_patches:
001-update-init-leds.patch          003-rewrite-update-script.patch
002-fix-post_update-mounting.patch

/usr/local/bunny/udisk:
config.txt  docs  payloads  upgrade.html  version.txt  win7-win8-cdc-acm.inf

/usr/local/bunny/udisk/docs:
EULA  LICENSE  full_documentation.html  readme.txt

/usr/local/bunny/udisk/payloads:
extensions  library  switch1  switch2

/usr/local/bunny/udisk/payloads/extensions:
cucumber.sh    get2_dhclient.sh  runpayload.sh           wait_for_present.sh
debug.sh       mac_happy.sh      setkb.sh                waiteject.sh
ducky_lang.sh  requiretool.sh    wait.sh
get.sh         run.sh            wait_for_notpresent.sh

/usr/local/bunny/udisk/payloads/library:
get_payloads.html

/usr/local/bunny/udisk/payloads/switch1:
payload.txt

/usr/local/bunny/udisk/payloads/switch2:
payload.txt
root@bunny:~#
