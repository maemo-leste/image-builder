#!/bin/sh
#
# This script will resize the second sdcard partition to maximum capacity.
# This file is part of Maemo Leste.
#

[ $( id -u ) = 0 ] || {
	echo "This script should be ran as root!"
	exit 1
}

root="$(egrep -o 'root=[^ ]*' /proc/cmdline | sed 's/root=//')"
card="$(lsblk -no PKNAME $root)"
start="$(partx -g -s -o START $root)"

# TODO: The '|| true' is because sometimes after fdisk an ioctl fails.
fdisk "/dev/$card" <<EOF || true
d
2
n
p
2
$start


w
EOF

partprobe "/dev/$card"
resize2fs "$root"
