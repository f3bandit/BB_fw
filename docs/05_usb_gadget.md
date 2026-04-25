# USB Gadget System

Kernel module:

```text
/usr/local/bunny/lib/bunny_gadget.ko
```

Confirmed strings include `Mass Storage`, `RNDIS/Ethernet Gadget`, `is_storage`, `is_hid`, `is_cdc_serial`, `is_cdc_ecm`, `is_rndis`, `idVendor`, `idProduct`, and `file`.

Architecture:

```text
payload ATTACKMODE commands
  -> bunny_framework
  -> bunny_gadget.ko / sunxi USB UDC
  -> host-visible USB composite device
```

Observed mass-storage backing path:

```text
/sys/devices/platform/sunxi_usb_udc/gadget/lun0/file
```
