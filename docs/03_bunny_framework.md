# Bunny Framework

Location:

```text
/usr/local/bunny/bin/bunny_framework
```

The framework is launched by `bunny.service` and handles switch-position logic, payload installation, payload execution, extension loading, and USB attack-mode orchestration.

Confirmed functions include `install_payload()` and `run_payload()`.

Observed payload flow:

```text
/root/udisk/payloads/<switch>/payload.txt
  -> /tmp/payload.sh
  -> bash -c '/tmp/payload.sh'
```

Payloads execute as root.
