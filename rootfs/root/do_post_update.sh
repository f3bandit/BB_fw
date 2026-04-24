#!/bin/sh


###############################################################################
# Post update: copy user data
###############################################################################

userdata_folder="/root/userdata"
udisk_folder="/root/udisk"
destfolder="/root/rootfs"
ret_post_update_filename="/tmp/ret_post_update"

do_copy_user_data() {
	/root/blink_led.initrd.sh blue &

	rm -rf $udisk_folder/preinstall
	rm -rf $udisk_folder/ducky
	rm -rf $udisk_folder/readme.txt

	rm -rf $udisk_folder/payloads/library/bunny_helpers.sh
	rm -rf $udisk_folder/payloads/library/extensions

	mkdir -p $udisk_folder/loot
	mkdir -p $udisk_folder/tools


	cp -rf $destfolder/usr/local/bunny/udisk/* $udisk_folder/
	cp $destfolder/root/version.txt  $udisk_folder/

	echo 1 > $ret_post_update_filename
	sync
	sleep 10
}

do_copy_user_data
rm -f $destfolder/root/do_post_update.sh
exit 0
