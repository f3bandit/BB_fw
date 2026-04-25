# Firmware Update Mechanism

## Location

nandh/update/

## Contents

- cherry.rootfs.tar
- uImage
- md5 checksum files

## Process

1. Update files placed in nandh
2. Recovery environment loads
3. rootfs tar extracted
4. Written to nandd

## Key Property

File-based update (not raw imaging)

## Implications

- Easy to modify firmware
- No observed signature enforcement
