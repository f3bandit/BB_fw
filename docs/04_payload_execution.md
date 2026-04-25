# Payload Execution

Payload root:

```text
/root/udisk/payloads/
```

Standard layout:

```text
payloads/
  arming/payload.txt
  switch1/payload.txt
  switch2/payload.txt
  extensions/*.sh
```

If `install.sh` exists for a switch, the framework copies it to `/tmp/install_payload.sh`, normalizes CRLF, and executes it. `payload.txt` is copied to `/tmp/payload.sh`, normalized, extensions are sourced, and it is executed by bash as root.
