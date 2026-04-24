TARGETS = mountkernfs.sh hostname.sh udev mountdevsubfs.sh networking mountall.sh mountall-bootclean.sh urandom resolvconf mountnfs.sh mountnfs-bootclean.sh hwclock.sh checkroot.sh procps checkfs.sh bootmisc.sh checkroot-bootclean.sh kmod x11-common udev-finish screen-cleanup
INTERACTIVE = udev checkroot.sh checkfs.sh
udev: mountkernfs.sh
mountdevsubfs.sh: mountkernfs.sh udev
networking: mountkernfs.sh mountall.sh mountall-bootclean.sh urandom resolvconf procps
mountall.sh: checkfs.sh checkroot-bootclean.sh
mountall-bootclean.sh: mountall.sh
urandom: mountall.sh mountall-bootclean.sh hwclock.sh
resolvconf: mountall.sh mountall-bootclean.sh
mountnfs.sh: mountall.sh mountall-bootclean.sh networking
mountnfs-bootclean.sh: mountall.sh mountall-bootclean.sh mountnfs.sh
hwclock.sh: mountdevsubfs.sh
checkroot.sh: hwclock.sh mountdevsubfs.sh hostname.sh
procps: mountkernfs.sh mountall.sh mountall-bootclean.sh udev
checkfs.sh: checkroot.sh
bootmisc.sh: mountall-bootclean.sh mountnfs-bootclean.sh checkroot-bootclean.sh mountall.sh mountnfs.sh udev
checkroot-bootclean.sh: checkroot.sh
kmod: checkroot.sh
x11-common: mountall.sh mountall-bootclean.sh mountnfs.sh mountnfs-bootclean.sh
udev-finish: udev mountall.sh mountall-bootclean.sh
screen-cleanup: mountall.sh mountall-bootclean.sh mountnfs.sh mountnfs-bootclean.sh
