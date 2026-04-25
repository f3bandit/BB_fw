cat > 02_boot_chain.md <<'EOF'
# Boot Chain

## Sequence

U-Boot → Kernel → RootFS → systemd → bunny.service → bunny_framework

## Details

- Bootloader environment stored in `nandb`
- Kernel loaded from `nandc` (or fallback `nande`)
- Root filesystem mounted from `nandd`
- systemd initializes services
- bunny runtime started via bunny.service
EOF
