# Driver for the Allwinner XRadio XR819 wifi chip 

This is an experimental wifi driver for devices using the XRADIO XR819 wifi chip - such as the Orange Pi Zero, the Nanopi Duo, or the Sunvell R69. This port is based on `https://github.com/fifteenhex/xradio`.

Tested kernel version: 4.14 - 5.5

Standard client station mode seems to work, but connecing to open APs does not.
Master (AP) mode works with WPA/WPA2 enabled works.
Don't expect throughputs substantially exceeding 25 Mbit/s, depending on the device.

# Firmware

Get firmware binaries from somewhere, e.g. https://github.com/karabek/xradio/tree/master/firmware (`boot_xr819.bin`, `fw_xr819.bin`, `sdd_xr819.bin`) and place into your firmware folder (for armbian: `/lib/firmware/xr819/`)

# Building an "out-of-tree" driver on the device

Make sure kernel headers are installed.

Option 1: the quick way

Clone the driver code directly on the device and use the provided script to compile and install the driver. This only works with armbian (www.armbian.com).

```
git clone https://github.com/karabek/xradio.git
cd xradio
sudo ./xr-install.sh
```

Use armbians armbian-add-overlay command to install a device-specific extension of the device tree (example here for the OrangePi Zero) and reboot:

```
armbian-add-overlay dts/xradio-overlay-xxxx.dts
reboot
```


Option 2: step-by-step

First clone driver code and compile locally on the device:

```
git clone https://github.com/karabek/xradio.git
cd xradio
```

Uncomment line 4-6 of Makefile:
```
	CONFIG_WLAN_VENDOR_XRADIO := m
	CONFIG_XRADIO_USE_EXTENSIONS := y
	CONFIG_XRADIO_WAPI_SUPPORT := n
```

Make kernel module:

```
make  -C /lib/modules/$(uname -r)/build M=$PWD modules
ll *.ko
```

You should see the compiled module (xradio_wlan.ko). Now copy the module to the correct driver directory:

```
mkdir /lib/modules/$(uname -r)/kernel/drivers/net/wireless/xradio
cp xradio_wlan.ko /lib/modules/$(uname -r)/kernel/drivers/net/wireless/xradio/
```

Add xradio_wlan to the modules-file and make module dependencies available:

```
echo -e "xradio_wlan" >> /etc/modules
depmod
```

Make sure that the xradio-chip is supported by the device tree. For armbian (www.armbian.com) this can be achieved by loading a dts-overlay:

```
armbian-add-overlay dts/xradio-mrk1.dts
```

Finally reboot the device.

# Building a kernel on a host system

To cross-compile and build the kernel module on a host system try something like this:

```
make ARCH=arm CROSS_COMPILE=arm-linux-gnueabihf- -C <PATH TO YOUR LINUX SRC> M=$PWD modules
make ARCH=arm CROSS_COMPILE=arm-linux-gnueabihf- -C <PATH TO YOUR LINUX SRC> M=$PWD INSTALL_MOD_PATH=<PATH TO INSTALL MODULE> modules_install
```

An example device tree file (for the Orange Pi Zero) can be found here
https://github.com/karabek/xradio/blob/master/dts/sun8i-h2-plus-orangepi-zero.dts



