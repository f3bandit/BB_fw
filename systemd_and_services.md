# systemd and Services

## Primary Service

bunny.service is the main entry point for runtime execution.

## Service Definition

- Type: forking
- ExecStart: /usr/local/bunny/bin/bunny_framework
- Target: multi-user.target

## Execution Order

systemd → multi-user.target → bunny.service

## Dependencies

- network.target
- auditd.service

## Observations

- rc.local is unused
- systemd fully controls runtime behavior
