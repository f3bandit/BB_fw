#!/bin/bash

function apply_patches() {
    cur=$(pwd)
    cd /mnt/recovery
    for f in /usr/local/bunny/recovery_patches/*
    do
        patch --dry-run -p1 < $f &> /dev/null
        [[ "$?" == "0" ]] && {
            patch -p1 < $f &> /dev/null
        }
    done
    sync
    cd $cur
}

function mount_recovery() {
    mkdir -p /mnt/recovery
    mount /dev/nandg /mnt/recovery
}

function unmount_recovery() {
    umount /dev/nandg
}

mount_recovery
apply_patches
unmount_recovery