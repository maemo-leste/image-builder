#!/bin/sh
#
# This script will resize the second sdcard partition to maximum capacity.
# This file is part of Maemo Leste.
#

[ "$UID" = 0 ] || {
	echo "This script should be ran as root!"
	exit 1
}

root="$(egrep -o 'root[^ ]*' /proc/cmdline | sed 's/root=//')"
card="$(lsblk -no PKNAME $root)"

# TODO: The '|| true' is because sometimes after fdisk an ioctl fails.
fdisk "$card" <<EOF || true
d
2
n
p
2


n
w
EOF

partprobe "$card"
resize2fs "$root"
