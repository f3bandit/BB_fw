# Payload Execution System

## Payload Location

/root/udisk/payloads/

## Structure

payloads/
├── switch1/
│   └── payload.txt
├── switch2/
│   └── payload.txt
├── arming/
│   └── payload.txt
└── extensions/

## Execution Flow

1. Switch position detected
2. Corresponding payload selected
3. payload.txt copied to /tmp
4. Executed via bash

## Extensions

Loaded dynamically from:

payloads/extensions/

## Key Property

No sandboxing — full system access.
