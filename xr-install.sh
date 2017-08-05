#!/bin/bash
if [[ $EUID != 0 ]]; then
	echo -e "This script requires \e[0;35mROOT\x1B[0m privileges."
	sudo "$0" "$@"
	exit $?
fi
echo ""
echo "******************************************************"
echo "*** out-of-tree xradio driver installer - vers 0.1 ***"
echo "*** https://github.com/karabek/xradio  (c) karabek ***"
echo "******************************************************"
echo ""
kvers="$(uname -r)"
#if [ -d /lib/modules/$kvers/kernel/drivers/net/wireless/xradio ]; then
#	echo "xradio installed already?"
#	exit
#fi
echo "=============== compiling driver for kernel version $kvers"
cp Makefile.orig Makefile
cp Makefile Makefile.orig
echo "CONFIG_WLAN_VENDOR_XRADIO := m" > Makefile
echo "CONFIG_XRADIO_USE_EXTENSIONS := y" >> Makefile
echo "CONFIG_XRADIO_WAPI_SUPPORT := n" >> Makefile
cat Makefile.orig >> Makefile
make  -C /lib/modules/$kvers/build M=$PWD modules
mkdir /lib/modules/$kvers/kernel/drivers/net/wireless/xradio
cp xradio_wlan.ko /lib/modules/$kvers/kernel/drivers/net/wireless/xradio/
xmod=`grep xradio /etc/modules`
if [ -z "$xmod" ]; then
        echo -e "xradio_wlan" >> /etc/modules
fi
echo "=============== calling depmod"
depmod
echo "=============== adding overlay"
armbian-add-overlay dts/xradio-mrk1.dts
exit

