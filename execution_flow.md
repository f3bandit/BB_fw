# Execution Flow

## Full Runtime Flow

Bootloader
→ Kernel
→ RootFS mount
→ systemd
→ bunny.service
→ bunny_framework
→ payload execution

## Payload Flow

Switch → Payload selection → Execution → USB mode activation

## Control Points

- bunny.service
- bunny_framework
- payload.txt
