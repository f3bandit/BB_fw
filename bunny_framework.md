# Bunny Framework

## Location

/usr/local/bunny/bin/bunny_framework

## Purpose

Central runtime controller responsible for:

- Payload selection
- Payload execution
- USB mode switching
- System interaction

## Core Functions

install_payload()
run_payload()

## Execution Model

Payloads are:

1. Copied from storage
2. Converted to Unix format
3. Executed via bash

## Key Behavior

Payloads execute as root without restriction.
