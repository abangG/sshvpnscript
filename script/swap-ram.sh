#SWAP RAM 1GB
# BY MKSSHVPN

dd if=/dev/zero of=/swap.file bs=1024 count=1024k
mkswap /swap.file
swapon /swap.file
chmod 0600 /swap.file
sysctl vm.swappiness=30
echo "/swap.file              swap                    swap    defaults        0 0" >> /etc/fstab

rm swap-ram.sh
