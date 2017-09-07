#!/bin/bash
if [[ $EUID != 0 ]]; then
	echo -e "This script requires \e[0;35mROOT\x1B[0m privileges."
	sudo "$0" "$@"
	exit $?
fi
echo ""
echo "******************************************************"
echo "*** out-of-tree xradio driver installer - vers 0.2 ***"
echo "*** https://github.com/karabek/xradio              ***"
echo "******************************************************"
echo ""
KVERS="$(uname -r)"
KERNELDIR="/lib/modules/$KVERS"
HEADERS="linux-headers-dev-sun8i_5.32_armhf.deb"
if [ ! -d "$KERNELDIR/build" ]; then
	wget "https://apt.armbian.com/pool/main/l/linux-$KVERS/$HEADERS"
	if [ -f "$HEADERS" ]; then
		dpkg -i "$HEADERS"
	else
		echo "***** FATAL: Headers not found at apt.armbian.com - Try installing current ..."
		echo "    linux-headers-headers-sun8i_5.32XXXXXXX.deb"
		echo "... from beta.armbian.com and try again!"
		exit 0
	fi
fi

echo "=============== compiling driver for kernel version $KVERS"
# prepare Makefile for stand alone compilation and compile
cp Makefile.orig Makefile
cp Makefile Makefile.orig
echo "CONFIG_WLAN_VENDOR_XRADIO := m" > Makefile
echo "CONFIG_XRADIO_USE_EXTENSIONS := y" >> Makefile
echo "CONFIG_XRADIO_WAPI_SUPPORT := n" >> Makefile
cat Makefile.orig >> Makefile
make  -C /lib/modules/$KVERS/build M=$PWD modules
if [ ! -d /lib/modules/$KVERS/kernel/drivers/net/wireless/xradio ]; then
	mkdir /lib/modules/$KVERS/kernel/drivers/net/wireless/xradio
fi
cp xradio_wlan.ko /lib/modules/$KVERS/kernel/drivers/net/wireless/xradio/
xmod=`grep xradio /etc/modules`
if [ -z "$xmod" ]; then
        echo -e "xradio_wlan" >> /etc/modules
fi
echo "=============== calling depmod"
depmod
echo "=============== adding overlay"
armbian-add-overlay dts/xradio-mrk1.dts
exit

