f3ban@FA506NF:~$ cd bb
f3ban@FA506NF:~/bb$ ls
analysis  mount  nand  reports  update
f3ban@FA506NF:~/bb$ cd ~/bb

for f in nand/*; do
  [ -f "$f" ] || continue
  echo "===== $f ====="
  file "$f"
  ls -lh "$f"
  sha256sum "$f"
  binwalk "$f" | head -40
  strings "$f" | grep -Ei 'u-boot|sunxi|bootargs|root=/dev|console=|Linux version|uImage' | head -40
done | tee reports/nand_quick_report_fixed.txt
===== nand/checksums.sha256.txt =====
nand/checksums.sha256.txt: ASCII text
-rw-r--r-- 1 f3ban f3ban 684 Apr 24 18:53 nand/checksums.sha256.txt
00cd89ccb35cf404d1a70503d982cbbf02a2990cf1206835c5f7f4eb671aa3b0  nand/checksums.sha256.txt

DECIMAL       HEXADECIMAL     DESCRIPTION
--------------------------------------------------------------------------------

===== nand/checksums.txt =====
nand/checksums.txt: ASCII text
-rw-r--r-- 1 f3ban f3ban 396 Apr 24 18:51 nand/checksums.txt
bff74e60f2cf57ef78c363b1bd406de6db6b34271b0b54ad25962516e7bd1ddb  nand/checksums.txt

DECIMAL       HEXADECIMAL     DESCRIPTION
--------------------------------------------------------------------------------

===== nand/nanda.img =====
nand/nanda.img: DOS/MBR boot sector, code offset 0x3c+2, OEM-ID "mkfs.fat", sectors/cluster 4, root entries 512, sectors 32768 (volumes <=32 MB), Media descriptor 0xf8, sectors/FAT 32, sectors/track 63, heads 255, serial number 0x6bf0b9, label: "BOOTCNT    ", FAT (16 bit)
-rwxr-xr-x 1 f3ban f3ban 16M Apr 24 18:47 nand/nanda.img
90c8eb25d64577c347987a5f3e2b058edb682ab9694ed5be2ef3c47b2b7cd3ff  nand/nanda.img

DECIMAL       HEXADECIMAL     DESCRIPTION
--------------------------------------------------------------------------------
629248        0x99A00         PC bitmap, Windows 3.x format,, 250 x 120 x 32
750080        0xB7200         PC bitmap, Windows 3.x format,, 250 x 120 x 32
991744        0xF2200         PC bitmap, Windows 3.x format,, 250 x 120 x 32
1112576       0x10FA00        PC bitmap, Windows 3.x format,, 250 x 120 x 32
1233408       0x12D200        PC bitmap, Windows 3.x format,, 250 x 120 x 32
1354240       0x14AA00        PC bitmap, Windows 3.x format,, 250 x 120 x 32
1475072       0x168200        PC bitmap, Windows 3.x format,, 250 x 120 x 32
1595904       0x185A00        PC bitmap, Windows 3.x format,, 250 x 120 x 32
1716736       0x1A3200        PC bitmap, Windows 3.x format,, 250 x 120 x 32
1837568       0x1C0A00        PC bitmap, Windows 3.x format,, 258 x 334 x 32
2183680       0x215200        PC bitmap, Windows 3.x format,, 250 x 120 x 32
2304512       0x232A00        PC bitmap, Windows 3.x format,, 250 x 120 x 32
2425344       0x250200        PC bitmap, Windows 3.x format,, 250 x 120 x 32
2546176       0x26DA00        PC bitmap, Windows 3.x format,, 800 x 480 x 32
4084224       0x3E5200        PC bitmap, Windows 3.x format,, 1280 x 720 x 32

===== nand/nandb.img =====
nand/nandb.img: data
-rwxr-xr-x 1 f3ban f3ban 16M Apr 24 18:47 nand/nandb.img
3d43142ab9f14f7a4d4af3e958e902d467afe527d37e51be3d5b7ad04231cd40  nand/nandb.img

DECIMAL       HEXADECIMAL     DESCRIPTION
--------------------------------------------------------------------------------
104           0x68            Unix path: /dev/block/mmcblk0p7

console=ttyS0,115200
nand_root=/dev/nandd
mmc_root=/dev/block/mmcblk0p7
setargs_nand=setenv bootargs console=${console} root=${nand_root} rootfstype=ext4 init=${init} loglevel=${loglevel} vmalloc=384M partitions=${partitions}
setargs_mmc=setenv bootargs console=${console} root=${mmc_root} rootfstype=ext4 init=${init} loglevel=${loglevel} vmalloc=384M partitions=${partitions}
boot_normal=sunxi_flash read 40007800 boot; bootm 40007800
boot_recovery=sunxi_flash read 40007800 recovery;boota 40007800 recovery
===== nand/nandc.img =====
nand/nandc.img: u-boot legacy uImage, Linux-3.4.39, Linux/ARM, OS Kernel Image (Not compressed), 4280768 bytes, Sun Jan31 02:25:46 2021, Load Address: 0X40008000, Entry Point: 0X40008000, Header CRC: 0XC709510F, Data CRC: 0X158A70D2
-rwxr-xr-x 1 f3ban f3ban 16M Apr 24 18:47 nand/nandc.img
f7961d5e33546e1da33fa3568882be4cd39e1b1032d027bd180b8b4d9a317ca2  nand/nandc.img

DECIMAL       HEXADECIMAL     DESCRIPTION
--------------------------------------------------------------------------------
0             0x0             uImage header, header size: 64 bytes, header CRC: 0xC709510F, created: 2021-01-31 02:25:46, image size: 4280768 bytes, Data Address: 0x40008000, Entry Point: 0x40008000, data CRC: 0x158A70D2, OS: Linux, CPU: ARM, image type: OS Kernel Image, compression type: none, image name: "Linux-3.4.39"
64            0x40            Linux kernel ARM boot executable zImage (little-endian)
16807         0x41A7          gzip compressed data, maximum compression, from Unix, last modified: 1970-01-01 00:00:00 (null date)

===== nand/nandd.img =====
nand/nandd.img: Linux rev 1.0 ext4 filesystem data, UUID=2c9eb171-80df-46bd-a2eb-b4aafd90ede5 (needs journal recovery) (extents) (large files) (huge files)
-rwxr-xr-x 1 f3ban f3ban 3.3G Apr 24 18:48 nand/nandd.img
0fc51e7f0bcd56322a9412230b7b582b9c3edc2a626f76b07038c5cbd24ce995  nand/nandd.img

DECIMAL       HEXADECIMAL     DESCRIPTION
--------------------------------------------------------------------------------
0             0x0             Linux EXT filesystem, blocks count: 851968, image size: 872415232, rev 1.0, ext4 filesystem data, UUID=2c9eb171-80df-46bd-a2eb-b4aafd90fd90
872415235     0x34000003      Copyright string: "Copyright 2009 The Go Authors. All rights reserved."
872427523     0x34003003      Copyright string: "Copyright 2009 The Go Authors. All rights reserved."
872448003     0x34008003      Copyright string: "Copyright 2009 The Go Authors. All rights reserved."
872464387     0x3400C003      Copyright string: "Copyright 2012 The Go Authors. All rights reserved."
872468483     0x3400D003      Copyright string: "Copyright 2013 The Go Authors. All rights reserved."
872472579     0x3400E003      Copyright string: "Copyright 2013 The Go Authors. All rights reserved."
872480771     0x34010003      Copyright string: "Copyright 2013 The Go Authors. All rights reserved."
872488963     0x34012003      Copyright string: "Copyright 2013 The Go Authors. All rights reserved."
872493059     0x34013003      Copyright string: "Copyright 2011 The Go Authors. All rights reserved."
872505347     0x34016003      Copyright string: "Copyright 2013 The Go Authors. All rights reserved."
872513539     0x34018003      Copyright string: "Copyright 2014 The Go Authors. All rights reserved."
872529923     0x3401C003      Copyright string: "Copyright 2013 The Go Authors. All rights reserved."
872534019     0x3401D003      Copyright string: "Copyright 2016 The Go Authors. All rights reserved."
872538115     0x3401E003      Copyright string: "Copyright 2013 The Go Authors. All rights reserved."
872546307     0x34020003      Copyright string: "Copyright 2012 The Go Authors. All rights reserved."
872562691     0x34024003      Copyright string: "Copyright 2013 The Go Authors. All rights reserved."
872574979     0x34027003      Copyright string: "Copyright 2014 The Go Authors. All rights reserved."
872579075     0x34028003      Copyright string: "Copyright 2013 The Go Authors. All rights reserved."
872587267     0x3402A003      Copyright string: "Copyright 2013 The Go Authors. All rights reserved."
872607747     0x3402F003      Copyright string: "Copyright 2012 The Go Authors. All rights reserved."
872611843     0x34030003      Copyright string: "Copyright 2013 The Go Authors. All rights reserved."
872620035     0x34032003      Copyright string: "Copyright 2012 The Go Authors. All rights reserved."
872640515     0x34037003      Copyright string: "Copyright 2013 The Go Authors. All rights reserved."
872681475     0x34041003      Copyright string: "Copyright 2012 The Go Authors. All rights reserved."
872693763     0x34044003      Copyright string: "Copyright 2014 The Go Authors. All rights reserved."
872706051     0x34047003      Copyright string: "Copyright 2013 The Go Authors. All rights reserved."
872718339     0x3404A003      Copyright string: "Copyright 2012 The Go Authors. All rights reserved."
872763395     0x34055003      Copyright string: "Copyright 2013 The Go Authors. All rights reserved."
872775683     0x34058003      Copyright string: "Copyright 2013 The Go Authors. All rights reserved."
872783875     0x3405A003      Copyright string: "Copyright 2011 The Go Authors. All rights reserved."
872792067     0x3405C003      Copyright string: "Copyright 2013 The Go Authors. All rights reserved."
872800259     0x3405E003      Copyright string: "Copyright 2013 The Go Authors. All rights reserved."
872804355     0x3405F003      Copyright string: "Copyright 2013 The Go Authors. All rights reserved."
872808451     0x34060003      Copyright string: "Copyright 2011 The Go Authors. All rights reserved."
872816643     0x34062003      Copyright string: "Copyright 2013 The Go Authors. All rights reserved."
872837123     0x34067003      Copyright string: "Copyright 2013 The Go Authors. All rights reserved."


^CException ignored in: <_io.TextIOWrapper name='<stdout>' mode='w' encoding='utf-8'>
BrokenPipeError: [Errno 32] Broken pipe
f3ban@FA506NF:~/bb$
