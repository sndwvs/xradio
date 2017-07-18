# Driver for the Allwinner xradio xr819 wifi chip 

This is an experimental wifi driver for the Orange Pi Zero. It is supposed to replace the driver provided by armbian which is not supported anymore.

Most of all, this is work in progress.

# Building on the Orange Pi Zero

To use the driver on the Orange Pi Zero install Armbian from SD-card (preferbly prepared with Etcher). Log in as root.
First clone this code and compile locally on OrangePi Zero (using kernel version 4.11.5 here ...):

```
git clone https://github.com/karabek/xradio.git
cd xradio
make  -C /lib/modules/4.11.5-sun8i/build M=$PWD modules
ll *.ko
```

You should see the compiled module (xradio_wlan.ko). Now copy it into the driver tree:

```
mkdir /lib/modules/4.11.5-sun8i/kernel/drivers/net/wireless/xradio
cp xradio_wlan.ko /lib/modules/4.11.5-sun8i/kernel/drivers/net/wireless/xradio/
```

Add xradio_wlan to the modules-file and make module dependencies available:

```
nano /etc/modules
	add single line: 
		xradio_wlan
depmod
```

Finally add dts overlay and reboot:

```
armbian-add-overlay xradio-mrk1.dts
reboot
```

Check ifconfig for the wlan0 interface ...

# Building on a host system

To cross-compile and build the kernel module on a host system try something like this:

```
make ARCH=arm CROSS_COMPILE=arm-linux-gnueabihf- -C <PATH TO YOUR LINUX SRC> M=$PWD modules
make ARCH=arm CROSS_COMPILE=arm-linux-gnueabihf- -C <PATH TO YOUR LINUX SRC> M=$PWD INSTALL_MOD_PATH=<PATH TO INSTALL MODULE> modules_install
```

To use this driver with armbian you will need to add a couple of lines to sun8i-h2-plus-orangepi-zero.dts (e.g. by adding a corresponding git diff to a userpatch). See here
https://github.com/karabek/xradio/blob/master/sun8i-h2-plus-orangepi-zero.dts

# Firmware

Get firmware binaries from somewhere, e.g. https://github.com/karabek/xradio/tree/master/firmware (`boot_xr819.bin`, `fw_xr819.bin`, `sdd_xr819.bin`) and place into your firmware folder (for armbian: `/lib/firmware/xr819/`)

# What works, what doesn't

Tested with:

	Kernel version 4.11.x
	Armbian version 5.32 

Standard client station mode seems to work, but connecing to open APs fails.
Master (AP) mode works with WPA/WPA2 enabled is supposed to work.
Don't expect throughputs substantially exceeding 10 Mbit/s.
