#!/bin/bash
if [[ $EUID != 0 ]]; then
	echo -e "This script requires [\e[0;35m ROOT \x1B[0m] privileges."
	sudo "$0" "$@"
	exit $?
fi
echo ""
echo "***********************************************"
echo "*** xradio out-of-tree driver installer 0.1 ***"
echo "***********************************************"
echo ""
kvers="$(uname -r)"
if [ -d /lib/modules/$kvers/kernel/drivers/net/wireless/xradio ]; then
	echo "xradio installed already?"
	exit
fi
echo "=============== compiling driver for kernel version $kvers"
make  -C /lib/modules/$kvers/build M=$PWD modules
mkdir /lib/modules/$kvers/kernel/drivers/net/wireless/xradio
cp xradio_wlan.ko /lib/modules/$kvers/kernel/drivers/net/wireless/xradio/
echo -e "xradio_wlan" >> /etc/modules
depmod
armbian-add-overlay xradio-mrk1.dts
exit

