# systemd and Services

Primary Bunny service:

```ini
[Unit]
After=network.target auditd.service

[Service]
Type=forking
KillMode=process
ExecStart=/usr/local/bunny/bin/bunny_framework

[Install]
WantedBy=multi-user.target
```

The main runtime path is systemd → multi-user.target → bunny.service. `/etc/rc.local` exists but is effectively empty.
