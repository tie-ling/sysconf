mkdir -p /etc/repart.d/

tee /etc/repart.d/00-esp.conf <<EOF
[Partition]
Type=esp
SizeMinBytes=1G
SizeMaxBytes=1G
EOF


tee /etc/repart.d/01-xbootldr.conf <<EOF
[Partition]
Type=xbootldr
SizeMinBytes=2G
SizeMaxBytes=2G
EOF


tee /etc/repart.d/02-root.conf <<EOF
[Partition]
Type=root
Encrypt=key-file
EOF

tee /etc/repart.d/03-swap.conf <<EOF
[Partition]
Type=swap
SizeMinBytes=2G
SizeMaxBytes=8G
EOF


printf "put_my_text_password_here" > /root/diskpw

DISK=/dev/disk/by-id/ata-INTEL_SSDSCKKF256G8H_BTLA81651HQR256J

systemd-repart --dry-run=no --empty=force --discard=yes --key-file=/root/diskpw $DISK

cryptsetup open -q --type plain --key-file /dev/random ${DISK}-part4 swap
mkswap ${DISK}-part4
swapon ${DISK}-part4

cryptsetup open --allow-discards --key-file=/root/diskpw ${DISK}-part3 root

mount /dev/mapper/root /mnt

mkdir -p /mnt/efi /mnt/boot
mkfs.vfat ${DISK}-part1
mkfs.ext4 ${DISK}-part2
mount -o umask=077,iocharset=iso8859-1  ${DISK}-part1 /mnt/efi
mount ${DISK}-part2 /mnt/boot

nixos-generate-config --root /mnt
nixos-install --root /mnt --no-root-passwd


umount -Rl $MNT
poweroff

