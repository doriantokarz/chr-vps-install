#!/bin/bash -e

echo
echo "=== caliko.net ==="
echo "=== https://github.com/doriantokarz ==="
echo "=== Mikrotik CHR install helper ==="
echo
sleep 3
echo "-> ownloading latest version in /tmp ... "
echo
cd /tmp
wget https://download.mikrotik.com/routeros/7.16.1/chr-7.16.1.img.zip -O chr.comp.zip  && \
echo "-> Unzipping downloaded package"
echo
gunzip -c chr.comp.zip > chr.img  && \
echo "-> Information about your system:"
diskStor=`lsblk | grep disk | cut -d ' ' -f 1 | head -n 1` && \
echo Main partition: $diskStor && \
mainInt=`ip route show default | sed -n 's/.* dev \([^\ ]*\) .*/\1/p'` && \
echo Main network interface: is $mainInt && \
mainIntIp=`ip addr show $ETH | grep global | cut -d' ' -f 6 | head -n 1` && \
echo Main network interface IP: $mainIntIp && \
mainIntGw=`ip route list | grep default | cut -d' ' -f 3` && \
echo Maint interface gateway: is $mainIntGw && \
echo
read -p "/!\ Proceed with WRITE to disk? (Y/N): " confirm && [[ $confirm == [yY] || $confirm == [yY][eE][sS] ]] || exit 1
dd if=chr.img of=/dev/$diskStor bs=4M oflag=sync && \
echo "Write finished, reboot NOW" && \
echo 1 > /proc/sys/kernel/sysrq && \
echo b > /proc/sysrq-trigger && \
