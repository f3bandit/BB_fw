# Boot Chain

```text
nanda/nandb boot state and environment
  -> nandc kernel uImage (or nande alternate kernel)
  -> nandd ext4 root filesystem
  -> systemd
  -> multi-user.target
  -> bunny.service
  -> /usr/local/bunny/bin/bunny_framework
```

## Bootloader environment

Extracted `nandb` strings include `bootcmd=run setargs_nand boot_normal`, `nand_root=/dev/nandd`, and `init=/init`.

## Kernel

`nandc` is a U-Boot legacy `uImage` for Linux 3.4.39 ARM with load/entry address `0x40008000`. `nande` appears to be an alternate or backup kernel.

## Warning

WSL `/proc/cmdline` output is WSL VM data, not Bunny boot data. Capture live boot args on the Bunny itself.
