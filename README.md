# xradio
Experimental xradio xr819 driver for the Orange Pi Zero based on fifteenhex' port.

# READ THIS

This experimental port is is ment to replace the driver provided by armbian which is not supported anymore.

# Building

To build the kernel module try something like this:

```
make ARCH=arm CROSS_COMPILE=arm-linux-gnueabihf- -C <PATH TO YOUR LINUX SRC> M=$PWD modules
make ARCH=arm CROSS_COMPILE=arm-linux-gnueabihf- -C <PATH TO YOUR LINUX SRC> M=$PWD INSTALL_MOD_PATH=<PATH TO INSTALL MODULE> modules_install
```

# How to use this

You need to specify one or two regulators for the xr819's 1.8v and 3.3v supplies in your device tree.
(for example, at: `.../linux_sources/linux-4.12-rc5/arch/arm/boot/dts/sun8i-h2-plus-orangepi-zero.dts`)

To use this driver with armbian add a couple of lines to sun8i-h2-plus-orangepi-zero.dts (e.g. by adding a corresponding git diff to a userpatch):

```
&mmc1 {
	...
	xr819: sdio_wifi@1 {
                reg = <1>;
                compatible = "xradio,xr819";
		/* pinctrl-names = "default"; */
                /* pinctrl-0 = <&wifi_wake>;  */
                interrupt-parent = <&pio>;
		interrupts = <6 10 IRQ_TYPE_EDGE_RISING>;
		interrupt-names = "host-wake";
		local-mac-address = [dc 44 6d c0 ff ee]; 
	};
};
```

# Kernel Module

place `xradio_wlan.ko` to your modules folder (for archlinux: `/lib/modules/<kernel-version>/kernel/drivers/net/wireless/xradio`)

# Firmware

Don't forget to take [firmware binaries from somewhere](https://github.com/armbian/build/tree/master/bin/firmware-overlay/xr819): `boot_xr819.bin`, `fw_xr819.bin`, `sdd_xr819.bin` (for archlunux place it to `/lib/firmware/xr819/`)

# What works, what doesn't

Working:

Standard client station mode seems to work fine.
Master (AP) mode works with WPA/WPA2 enabled etc.
Dual role station and master mode.

# Issues

The firmware running on the xr819 is very crash happy and the driver is a bit
stupid. For example the driver can get confused about how many packets of data
the xr819 has for it to read and can try to read too many. The firmware on the
xr819 responds by triggering an assert and shutting down. The driver gets
a packet that tells it that the firmware is dead and shuts down the thread used
to push and pull data but the rest of the driver and the os has no idea and
if the os tries to interact with the driver everything starts to lock up.

Pings from the device to the network are faster than from the network to the device.
This seems to be because of latency between the interrupt and servicing RX reports
from the device.

# Fun stuff

The driver is based on the driver for the ST CW1100/CW1200 chips.
The XR819 is probably a clone, licensed version or actually a CW1100 family chip
that has been packaged by xradio/allwinner as the CW1100 is available as a raw
wafer. 

The silicon version from the XR819 and procedure for loading firmware
matches up with the CW1x60 chips which were apparently never released so
maybe Allwinner bought the design after the ST/Ericsson split?

If anyone wants to mainline support for the XR819 they should probably do it by
adding support for the XR819 to the existing CW1200 driver so they don't have to
get thousands and thousands of lines of code signed off.
