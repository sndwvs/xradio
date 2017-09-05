# Driver for the Allwinner xradio xr819 wifi chip 

This is an experimental wifi driver for the Orange Pi Zero. It is supposed to replace the driver provided by armbian (www.armbian.com) which is not supported anymore. 

Tested with kernel versions:

	4.11.3:  does not work, due to kernel error
	4.11.5:  tested ok
	4.11.12: tested ok

Standard client station mode seems to work, but connecing to open APs fails.
Master (AP) mode works with WPA/WPA2 enabled is supposed to work.
Don't expect throughputs substantially exceeding 10 Mbit/s.

WARNING, this is work in progress!


# Building an "out-of-tree" driver on the Orange Pi Zero

To use the driver on the Orange Pi Zero install Armbian from SD-card (prepared with Etcher - http://etcher.io). Log in as root.

Option 1: the quick way

Clone the driver code directly on the Orange Pi Zero and use the provided script to compile and install the driver.

```
git clone https://github.com/karabek/xradio.git
cd xradio
sudo ./xr-install.sh
```

Option 2: step-by-step

First clone driver code and compile locally on OrangePi Zero:

```
git clone https://github.com/karabek/xradio.git
cd xradio
make  -C /lib/modules/$(uname -r)/build M=$PWD modules
ll *.ko
```

You should see the compiled module (xradio_wlan.ko). Now copy it to the driver tree:

```
mkdir /lib/modules/$(uname -r)/kernel/drivers/net/wireless/xradio
cp xradio_wlan.ko /lib/modules/$(uname -r)/kernel/drivers/net/wireless/xradio/
```

Add xradio_wlan to the modules-file and make module dependencies available:

```
echo -e "xradio_wlan" >> /etc/modules
depmod
```

Finally add dts overlay and reboot:

```
armbian-add-overlay dts/xradio-mrk1.dts
reboot
```

Check for wlan0 now.

# Building a kernel on a host system

To cross-compile and build the kernel module on a host system try something like this:

```
make ARCH=arm CROSS_COMPILE=arm-linux-gnueabihf- -C <PATH TO YOUR LINUX SRC> M=$PWD modules
make ARCH=arm CROSS_COMPILE=arm-linux-gnueabihf- -C <PATH TO YOUR LINUX SRC> M=$PWD INSTALL_MOD_PATH=<PATH TO INSTALL MODULE> modules_install
```

To use this driver with armbian you will need to add a couple of lines to sun8i-h2-plus-orangepi-zero.dts (e.g. by adding a corresponding git diff to a userpatch). See here
https://github.com/karabek/xradio/blob/master/sun8i-h2-plus-orangepi-zero.dts

# Firmware

Get firmware binaries from somewhere, e.g. https://github.com/karabek/xradio/tree/master/firmware (`boot_xr819.bin`, `fw_xr819.bin`, `sdd_xr819.bin`) and place into your firmware folder (for armbian: `/lib/firmware/xr819/`)


