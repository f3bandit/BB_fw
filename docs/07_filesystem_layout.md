# Filesystem Layout

## Active rootfs (`nandd`)

```text
/usr/local/bunny/
/usr/local/bunny/bin/bunny_framework
/usr/local/bunny/bin/factory_reset_bunny
/usr/local/bunny/lib/bunny_gadget.ko
/usr/local/bunny/hid_reader.py
/usr/local/bunny/update_recovery.sh
/usr/local/bunny/recovery_patches/
/usr/local/bunny/udisk/
/lib/systemd/system/bunny.service
/etc/systemd/system/multi-user.target.wants/bunny.service
```

## User storage (`nandf` or SD-backed udisk)

```text
payloads/
loot/
tools/
config.txt
version.txt
```

## Recovery/template (`nandg`)

```text
/root/cherry.rootfs/rootfs/
```

## Update staging (`nandh`)

```text
/update/
```
