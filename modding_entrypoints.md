# Modding Entry Points

## Safe Modification Targets

1. bunny_framework
2. payload system
3. /usr/local/bin tools
4. firmware rootfs tar

## High-Control Areas

- USB behavior (via framework)
- payload execution pipeline
- systemd service injection

## Recommended Approach

1. Extract cherry.rootfs.tar
2. Modify filesystem
3. Repack tar
4. Deploy via update system

## Notes

- Kernel modification not required
- Userland fully controls behavior
