/*
 * DebugFS code for XRadio drivers
 *
 * Copyright (c) 2013, XRadio
 * Author: XRadio
 *
 * This program is free software; you can redistribute it and/or modify
 * it under the terms of the GNU General Public License version 2 as
 * published by the Free Software Foundation.
 */
#ifndef XRADIO_DEBUG_H_INCLUDED
#define XRADIO_DEBUG_H_INCLUDED

#define XRADIO_DBG_ALWY   0x01		/* general - always */
#define XRADIO_DBG_ERROR  0x02		/* error */
#define XRADIO_DBG_WARN   0x04		/* warning */
#define XRADIO_DBG_NIY    0x08		/* info (parameters etc.) */
#define XRADIO_DBG_MSG    0x10		/* verbose debug */
#define XRADIO_DBG_OPS    0x20		/* trace IEEE802.11 ops calls */
#define XRADIO_DBG_DEV    0x40		/* current dev */

#define XRADIO_DBG_LEV_XR	0x07	/* debug level - xradio - default: 0x07 */
#define XRADIO_DBG_LEV_STA	0x47	/* debug level - sta,keys - default: 0x07 */


#define xr_printk(level, ...)	\
	do {			\
		if ((level) & XRADIO_DBG_LEV_XR & XRADIO_DBG_ERROR)		\
			printk(KERN_ERR "[XR ERR] " __VA_ARGS__);		\
		else if ((level) & XRADIO_DBG_LEV_XR & XRADIO_DBG_WARN)		\
			printk(KERN_WARNING "[XR WRN] " __VA_ARGS__);		\
		else if ((level) & XRADIO_DBG_LEV_XR & XRADIO_DBG_NIY)		\
			printk(KERN_DEBUG "[XR NIY] " __VA_ARGS__);		\
		else if ((level) & XRADIO_DBG_LEV_XR & XRADIO_DBG_MSG)		\
			printk(KERN_DEBUG "[XR MSG] " __VA_ARGS__);		\
		else if ((level) & XRADIO_DBG_LEV_XR & XRADIO_DBG_OPS)		\
			printk(KERN_DEBUG "[XR OPS] " __VA_ARGS__);		\
		else if ((level) & XRADIO_DBG_LEV_XR & XRADIO_DBG_DEV)		\
			printk(KERN_NOTICE "[XR DEV] " __VA_ARGS__);		\
		else if ((level) & XRADIO_DBG_LEV_XR & XRADIO_DBG_ALWY)		\
			printk(KERN_INFO "[XRADIO] " __VA_ARGS__); 		\
	} while (0)

#define sta_printk(level, ...)	\
	do {			\
		if ((level) & XRADIO_DBG_LEV_STA & XRADIO_DBG_ERROR)		\
			printk(KERN_ERR "[XR-STA ERR] " __VA_ARGS__);		\
		else if ((level) & XRADIO_DBG_LEV_STA & XRADIO_DBG_WARN)	\
			printk(KERN_WARNING "[XR-STA WRN] " __VA_ARGS__);	\
		else if ((level) & XRADIO_DBG_LEV_STA & XRADIO_DBG_NIY)		\
			printk(KERN_DEBUG "[XR-STA NIY] " __VA_ARGS__);		\
		else if ((level) & XRADIO_DBG_LEV_STA & XRADIO_DBG_MSG)		\
			printk(KERN_DEBUG "[XR-STA MSG] " __VA_ARGS__);		\
		else if ((level) & XRADIO_DBG_LEV_STA & XRADIO_DBG_OPS)		\
			printk(KERN_DEBUG "[XR-STA OPS] " __VA_ARGS__);		\
		else if ((level) & XRADIO_DBG_LEV_STA & XRADIO_DBG_DEV)		\
			printk(KERN_NOTICE "[XR-STA DEV] " __VA_ARGS__);	\
		else if ((level) & XRADIO_DBG_LEV_STA & XRADIO_DBG_ALWY)	\
			printk(KERN_INFO "[XR-STA] " __VA_ARGS__); 		\
	} while (0)

#define ap_printk(level, ...)
#define pm_printk(level, ...)
#define scan_printk(level, ...)
#define txrx_printk(level, ...)
#define wsm_printk(level, ...)

#endif /* XRADIO_DEBUG_H_INCLUDED */
