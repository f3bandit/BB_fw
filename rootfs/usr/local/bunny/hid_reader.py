#!/usr/bin/python
# Simple program to read HID output reports.
# Converts output to HEX and stores the latest output in a file

HID_DEV = "/dev/hidg0"
OUT_FILE = "/tmp/hid_out"


def poller():
	while True:
		with open(HID_DEV, "rb") as r:
			output = r.read(1).encode("hex")
			with open(OUT_FILE, "w") as w:
				w.write(output)


if __name__ == "__main__":
	poller()
