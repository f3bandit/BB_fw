# Bash Bunny Serial TTY / Login Stack Analysis

## Overview

This document captures the **fully verified behavior** of the Bash Bunny serial console (`ttyGS0`) and why hybrid firmware builds previously failed.

This is based on:

* Stock firmware extraction
* Runtime logging
* Direct code inspection of:

  * `bunny_framework`
  * `ATTACKMODE`
  * systemd services
  * PAM/login stack

---

## Confirmed Serial Execution Chain

```
systemd
→ bunny.service
→ /usr/local/bunny/bin/bunny_framework
→ /usr/local/bunny/bin/ATTACKMODE
→ insmod bunny_gadget.ko
→ systemctl start serial-getty@ttyGS0.service
→ /sbin/agetty
→ /bin/login (PAM)
→ shell
```

---

## Key Components

### 1. bunny.service

```
/lib/systemd/system/bunny.service
```

```ini
[Service]
ExecStart=/usr/local/bunny/bin/bunny_framework
```

* Primary entrypoint for Bunny runtime
* Runs at `multi-user.target`

---

### 2. bunny_framework

Location:

```
/usr/local/bunny/bin/bunny_framework
```

Key behavior:

```bash
run_payload "arming" || /bin/bash -c "ATTACKMODE SERIAL STORAGE"
```

* Handles switch logic (SW1 / SW2 / SW3)
* Falls back to `ATTACKMODE SERIAL STORAGE` if no payload runs

---

### 3. ATTACKMODE

Location:

```
/usr/local/bunny/bin/ATTACKMODE
```

### Critical behaviors

#### a. Stops existing serial session

```bash
systemctl stop serial-getty@ttyGS0.service
```

#### b. Loads gadget driver

```bash
insmod /usr/local/bunny/lib/bunny_gadget.ko
```

#### c. Starts serial login

```bash
systemctl start serial-getty@ttyGS0.service
```

#### d. Enables getty target

```bash
systemctl start getty.target
```

---

### 4. USB Gadget Driver

```
/usr/local/bunny/lib/bunny_gadget.ko
```

* Provides USB composite device
* Creates `/dev/ttyGS0`
* Controls all ATTACKMODE USB behavior

---

## Serial Console Service

### [serial-getty@ttyGS0.service](mailto:serial-getty@ttyGS0.service)

```
/lib/systemd/system/serial-getty@.service
```

Key line:

```ini
ExecStart=-/sbin/agetty --keep-baud 115200,38400,9600 %I $TERM
```

---

## Authentication Stack (CRITICAL)

### Stock Firmware Uses PAM Login

```
/bin/login = 34KB ELF binary (PAM-enabled)
/etc/pam.d/login = full PAM config
```

### PAM Enforces:

```text
pam_securetty.so → root allowed only on secure TTYs
pam_unix.so → password verification
```

---

## Root Authentication Requirements

### Required state:

```
/etc/passwd:
root:x:0:0:root:/root:/bin/bash

/etc/shadow:
root:$6$<hash>:...
```

### Required file:

```
/etc/securetty:
ttyGS0
```

---

## Root Cause of Hybrid Firmware Failure

### What was done incorrectly:

```
Replaced /bin/login with BusyBox
Left PAM configuration intact
Used Debian agetty
```

### Resulting mismatch:

```
agetty (expects PAM login)
→ BusyBox login (NO PAM support)
→ PAM config still active
→ authentication failure
```

---

## Observed Failure Behavior

```
login: root
Password:
Login incorrect
```

Even when:

```
✔ correct password hash
✔ ttyGS0 present
✔ securetty configured
✔ serial-getty running
```

---

## Why It Failed

```
Mismatch between:
agetty + systemd + PAM
vs
BusyBox login (no PAM)
```

---

## Correct Model

```
ATTACKMODE → controls serial-getty lifecycle
serial-getty → runs agetty
agetty → runs PAM login
PAM → enforces authentication
```

---

## Critical Rules for Firmware Builds

### MUST PRESERVE

```
/usr/local/bunny/bin/bunny_framework
/usr/local/bunny/bin/ATTACKMODE
/usr/local/bunny/lib/bunny_gadget.ko
/lib/systemd/system/bunny.service
/lib/systemd/system/serial-getty@.service
/bin/login (PAM version)
/etc/pam.d/*
/etc/login.defs
/etc/securetty
```

---

### MUST NOT DO

```
Replace /bin/login with BusyBox
Disable PAM stack
Use /etc/inittab for ttyGS0
Spawn shells manually on ttyGS0
Modify ATTACKMODE serial logic
```

---

## Safe Modifications

```
Debian userland packages
Tools and binaries
Filesystem additions
```

---

## Key Insight

```
Serial login is NOT controlled by Linux alone.

It is controlled by:

ATTACKMODE + systemd + PAM working together.
```

---

## Summary

```
The Bash Bunny serial system is a tightly integrated stack:

bunny_framework → ATTACKMODE → systemd → agetty → PAM login

Breaking ANY layer causes login failure.
```

---

## Final Conclusion

```
The issue was never ttyGS0.

It was always authentication stack mismatch.
```
