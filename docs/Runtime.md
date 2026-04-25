cat > 04_runtime.md <<'EOF'
# Runtime System

## Entry Point

/usr/local/bunny/bin/bunny_framework

## Trigger

systemd service: bunny.service

## Responsibilities

- Payload execution
- USB mode control
- System interaction

## Execution Model

payload.txt is executed as root via bash.
EOF
