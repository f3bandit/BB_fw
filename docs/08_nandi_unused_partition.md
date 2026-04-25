# `nandi` Unused Partition

The original `nandi.img` dump is an erased NAND partition, shown as continuous `0xFF` bytes. It has no filesystem, no strings, and no binwalk signatures.

A local ext4 experiment can be created from a copy:

```sh
cp nandi.empty-original.img nandi.ext4.img
mkfs.ext4 -F nandi.ext4.img
sudo mount -o loop nandi.ext4.img ~/bb/mount/nandi
```

The stock firmware does not automatically mount or use `nandi`.
