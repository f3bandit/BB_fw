# Modding Entry Points

Lowest-risk entry points:

1. Payload scripts on user storage
2. `bunny_framework` wrapper/hook logic
3. Additional systemd service
4. Rootfs changes inside `cherry.rootfs.tar`

High-value files:

```text
/usr/local/bunny/bin/bunny_framework
/lib/systemd/system/bunny.service
/usr/local/bunny/update_recovery.sh
/usr/local/bunny/lib/bunny_gadget.ko
```

Avoid bootloader/kernel changes until userland rebuilds are reliable.
