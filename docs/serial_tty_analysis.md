# Bash Bunny Serial TTY / Login Stack Analysis

## Overview

This document captures the **fully verified behavior** of the Bash Bunny serial console (`ttyGS0`) and why hybrid firmware builds previously failed.

---

## Confirmed Serial Execution Chain

systemd
→ bunny.service
→ /usr/local/bunny/bin/bunny_framework
→ /usr/local/bunny/bin/ATTACKMODE
→ insmod bunny_gadget.ko
→ systemctl start serial-getty@ttyGS0.service
→ /sbin/agetty
→ /bin/login (PAM)
→ shell

---

## Key Components

### bunny.service
/lib/systemd/system/bunny.service

ExecStart=/usr/local/bunny/bin/bunny_framework

---

### bunny_framework

run_payload "arming" || /bin/bash -c "ATTACKMODE SERIAL STORAGE"

---

### ATTACKMODE

- Stops serial-getty
- Loads bunny_gadget.ko
- Starts serial-getty@ttyGS0

---

### serial-getty@.service

ExecStart=-/sbin/agetty --keep-baud 115200,38400,9600 %I $TERM

---

## Authentication Stack

Stock uses PAM-based login:

/bin/login (PAM-enabled)
/etc/pam.d/login

---

## Root Cause of Failure

Hybrid firmware used:

BusyBox login + PAM config

Mismatch caused:

login prompt → password accepted → auth fails → "Login incorrect"

---

## Correct Requirements

- Use stock /bin/login
- Keep PAM stack intact
- Ensure ttyGS0 is in /etc/securetty
- Do NOT replace login with BusyBox

---

## Key Insight

Serial access is controlled by:

ATTACKMODE → systemd → agetty → PAM login

Not by Linux defaults alone.

---

## Conclusion

The issue was not ttyGS0.

It was authentication stack mismatch between BusyBox and PAM.
