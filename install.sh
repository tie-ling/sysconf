DISK=/dev/disk/by-id/nvme-SAMSUNG_MZVLV256HCHP-000H1_S2CSNA0J547878
MNT=$(mktemp -d)

SWAPSIZE=4

RESERVE=1
partition_disk () {
    local disk="${1}";
    blkdiscard -f "${disk}" || true;
    parted --script --align=optimal  "${disk}" --  \
           mklabel gpt \
           mkpart EFI 1MiB 4GiB \
           mkpart root 4GiB -$((SWAPSIZE + RESERVE))GiB \
           mkpart swap  -$((SWAPSIZE + RESERVE))GiB -"${RESERVE}"GiB \
           set 1 esp on;
    partprobe "${disk}";
}
partition_disk ${DISK}

i=$DISK

cryptsetup open --type plain --key-file /dev/random "${i}"-part3 "${i##*/}"-part3;
mkswap /dev/mapper/"${i##*/}"-part3;
swapon /dev/mapper/"${i##*/}"-part3;

printf "ernseitspc" | cryptsetup luksFormat --type luks2 "${i}"-part2 -; 
printf "enrstinets" | cryptsetup luksOpen --allow-discards "${i}"-part2 luks-"${i##*/}"-part2 -;

mkfs.f2fs /dev/mapper/luks-"${i##*/}"-part2
mount /dev/mapper/luks-"${i##*/}"-part2 $MNT
mkdir -p $MNT/boot
mount -o umask=077,iocharset=iso8859-1 ${DISK}-part1 $MNT/boot/

nixos-install  --root "${MNT}"

umount -Rl $MNT
poweroff

