# USB Gadget System

## Kernel Module

/usr/local/bunny/lib/bunny_gadget.ko

## Capabilities

- HID (keyboard injection)
- Mass Storage
- RNDIS Ethernet
- CDC Serial

## Control Interface

Configured via runtime scripts and ATTACKMODE commands.

## Modes

- STORAGE
- HID
- RNDIS_ETHERNET
- SERIAL

## Architecture

Userland → bunny_framework → kernel module → USB hardware

## Notes

- Based on sunxi USB UDC driver
- Composite USB device support
