docs/bunny_framework.md
# Bash Bunny Runtime Framework (Stock Firmware Analysis)

## Overview

The Bash Bunny firmware does **not** rely on traditional Linux init patterns like:

- `/etc/inittab`
- persistent `/etc/rc.local`
- manual getty spawning

Instead, it uses a **systemd-driven control layer** implemented under:


/usr/local/bunny/


---

## Boot Execution Chain

Confirmed runtime sequence:


systemd (PID 1)
→ bunny.service
→ /usr/local/bunny/bin/bunny_framework
→ /usr/local/bunny/bin/ATTACKMODE
→ bunny_gadget.ko
→ systemctl start serial-getty@ttyGS0.service

→ /bin/login on ttyGS0


---

## Systemd Entry Point

### `bunny.service`


[Unit]
After=network.target auditd.service

[Service]
Type=forking
KillMode=process
ExecStart=/usr/local/bunny/bin/bunny_framework

[Install]
WantedBy=multi-user.target


### Key Facts

- `bunny_framework` is the **primary runtime controller**
- Runs under systemd as a long-lived service
- All device behavior flows through this binary/script

---

## Core Components

### 1. `bunny_framework`

Location:

/usr/local/bunny/bin/bunny_framework


Responsibilities:

- Detects switch position (SW1 / SW2 / SW3)
- Executes payload logic
- Calls `ATTACKMODE`
- Controls device state transitions

---

### 2. `ATTACKMODE`

Location:

/usr/local/bunny/bin/ATTACKMODE


Responsibilities:

- Loads and configures USB gadget via:

bunny_gadget.ko

- Switches device modes:

SERIAL
STORAGE
HID
RNDIS / ECM

- Controls serial access via systemd:

systemctl start/stop serial-getty@ttyGS0.service


---

### 3. `bunny_gadget.ko`

Location:

/usr/local/bunny/lib/bunny_gadget.ko


Responsibilities:

- Kernel-level USB gadget driver
- Defines:
  - USB descriptors
  - Device identity
  - Composite interfaces
- Central to all ATTACKMODE functionality

---

### 4. Serial Console Path


ATTACKMODE SERIAL
→ systemctl start serial-getty@ttyGS0.service

→ /bin/login
→ shell access


Requirements:

- `/dev/ttyGS0` must exist
- `/etc/securetty` must include:

ttyGS0


---

## Important Systemd Units

Relevant units found in stock firmware:


/lib/systemd/system/bunny.service
/lib/systemd/system/serial-getty@.service
/lib/systemd/system/console-getty.service
/lib/systemd/system/console-shell.service


---

## rc.local Behavior

Stock firmware uses:


/etc/rc.local


But:

- It executes:

/usr/local/bunny/update_recovery.sh

- Then **overwrites itself** to a minimal stub

Conclusion:


rc.local is NOT a persistent hook point


---

## Key Design Insight

The Bash Bunny firmware is built around a **custom control layer**, not standard Linux services.

All critical behavior flows through:


bunny.service → bunny_framework → ATTACKMODE → bunny_gadget.ko


---

## Porting Rules (CRITICAL)

When building hybrid firmware:

### MUST PRESERVE


/usr/local/bunny/bin/bunny_framework
/usr/local/bunny/bin/ATTACKMODE
/usr/local/bunny/lib/bunny_gadget.ko
/lib/systemd/system/bunny.service
systemd unit enablement
serial-getty@ttyGS0 behavior


---

### MUST NOT DO


Replace login with BusyBox blindly
Use /etc/inittab for ttyGS0
Rely on rc.local for persistent hooks
Manually spawn shells on ttyGS0
Bypass ATTACKMODE


---

## Failure Modes Observed


Login incorrect (even with correct password)
Serial present but unusable
TTY exists but not bound correctly
Broken ATTACKMODE switching


Root cause:


Breaking the Bunny control layer, not Linux itself


---

## Correct Strategy


Preserve Bunny framework completely
Adapt Debian userland underneath it
Verify behavior AFTER final image build


---

## Summary

Bash Bunny is NOT a generic Linux device.

It is a systemd-driven appliance with a custom runtime:
bunny_framework + ATTACKMODE + bunny_gadget

Treat it as such when modifying firmware.
