beaglebone-universal-io
=======================

Overview
--------

Device tree overlay and support scripts for using most available hardware I/O on the BeagleBone without editing dts files or rebuilding the kernel


Usage
-----

Load the overlay as usual

    echo cape-universal > /sys/devices/bone_capemgr.*/slots

At this point, the various devices are loaded and all gpio have been
exported.  All pins currently default to gpio inputs, with pull up or
pull down resistors set the same as when the AM335x comes out of reset.
This behavior may change, however.  If the BeagleBone begins shipping
with some I/O pins configured by default at boot, this overlay will
likely change to match.

To control the gpio pins, you may use the sysfs interface.  Each
exported gpio pin has an entry under /sys/class/gpio/gpioNN, where NN
represents the kernel gpio number for that pin.  I hope to write a
utility to control pin multiplexing and GPIO setup that doesn't
require mapping BeagleBone pin numbering to kernel gpio numbers, but
in the mean time you can find the list created for you in the status
file of the device tree overlay:

    root@arm:~# cat /sys/devices/ocp.*/cape-universal.*/status
     0 P9_92                    114 IN  0
     1 P9_42                      7 IN  0
     2 P9_91                    116 IN  0
     3 P9_41                     20 IN  0
     4 P9_31                    110 IN  0
     5 P9_30                    112 IN  0
     6 P9_29                    111 IN  0
     7 P9_28                    113 IN  0
     8 P9_27                    115 IN  0
     9 P9_26                     14 IN  0
    10 P9_25                    117 IN  0
    11 P9_24                     15 IN  0
    12 P9_23                     49 IN  0
    13 P9_22                      2 IN  0
    14 P9_21                      3 IN  0
    15 P9_20                     12 IN  0
    16 P9_19                     13 IN  0
    17 P9_18                      4 IN  0
    18 P9_17                      5 IN  0
    19 P9_16                     51 IN  0
    20 P9_15                     48 IN  0
    21 P9_14                     50 IN  0
    22 P9_13                     31 IN  0
    23 P9_12                     60 IN  0
    24 P9_11                     30 IN  0
    25 P8_26                     61 IN  0
    26 P8_19                     22 IN  0
    27 P8_18                     65 IN  0
    28 P8_17                     27 IN  0
    29 P8_16                     46 IN  0
    30 P8_15                     47 IN  0
    31 P8_14                     26 IN  0
    32 P8_13                     23 IN  0
    33 P8_12                     44 IN  0
    34 P8_11                     45 IN  0
    35 P8_10                     68 IN  0
    36 P8_09                     69 IN  0
    37 P8_08                     67 IN  0
    38 P8_07                     66 IN  0

Pin multiplexing is controled via files in /sys/devices/ocp.*/, where
each exported I/O pin has a pinmux control directory.  The directory is
named using the actual BeagleBone pin header number, so P8_ or P9_ 
followed by the pin number, the suffix _pinmux, and an instance number
(that is subject to change).  So a typical full path to the pinmux
control directory for P8 pin 7 might be:

    /sys/devices/ocp.3/P8_07_pinmux.13/

However since the instance numbers are subject to change, you are
advised to use shell wildcards for the instance values when referencing
these paths:

    /sys/devices/ocp.*/P8_07_pinmux.*/

Each pinmux directory contains a state file, which you can read to
determine the current pinmux setting of the pin:

    root@arm:~# cat /sys/devices/ocp.*/P8_07_pinmux.*/state
    default

Or you can write to change the pinmux setting for the pin:

    root@arm:~# echo timer > /sys/devices/ocp.*/P8_07_pinmux.*/state
    root@arm:~# cat /sys/devices/ocp.*/P8_07_pinmux.*/state
    timer

Each pin has a default state and a gpio state.  Currently the default
state for all pins is gpio, but that could change.  If the BeagleBone
begins shipping with a default I/O setup that enables some special
functions, this overlay will likely change to match.  Most pins have
other functions available besides gpio, see the list below for valid
settings.

The valid pinmux states for each pin are listed below:

    # P8 3-6 Reserved for eMMC
    P8_07_pinmux : default gpio timer 
    P8_08_pinmux : default gpio timer 
    P8_09_pinmux : default gpio timer 
    P8_10_pinmux : default gpio timer 
    P8_11_pinmux : default gpio pruout qep 
    P8_12_pinmux : default gpio pruout qep 
    P8_13_pinmux : default gpio pwm 
    P8_14_pinmux : default gpio pwm 
    P8_15_pinmux : default gpio pruin qep 
    P8_16_pinmux : default gpio pruin qep 
    P8_17_pinmux : default gpio pwm 
    P8_18_pinmux : default gpio 
    P8_19_pinmux : default gpio pwm 
    # P8 20-25 Reserved for eMMC
    P8_26_pinmux : default gpio 
    # P8 27-46 Reserved for HDMI

    P9_11_pinmux : default gpio uart 
    P9_12_pinmux : default gpio 
    P9_13_pinmux : default gpio uart 
    P9_14_pinmux : default gpio pwm 
    P9_15_pinmux : default gpio pwm 
    P9_16_pinmux : default gpio pwm 
    P9_17_pinmux : default gpio spi i2c pwm 
    P9_18_pinmux : default gpio spi i2c pwm 
    # P9_19 Reserved for cape I2C bus
    # P9_20 Reserved for cape I2C bus
    P9_21_pinmux : default gpio spi uart i2c pwm 
    P9_22_pinmux : default gpio spi uart i2c pwm 
    P9_23_pinmux : default gpio pwm 
    P9_24_pinmux : default gpio uart can i2c pruin 
    P9_25_pinmux : default gpio qep pruout pruin 
    P9_26_pinmux : default gpio uart can i2c pruin 
    P9_27_pinmux : default gpio qep pruout pruin 
    P9_28_pinmux : default gpio pwm spi pwm2 pruout pruin 
    P9_29_pinmux : default gpio pwm spi pruout pruin 
    P9_30_pinmux : default gpio pwm spi pruout pruin 
    P9_31_pinmux : default gpio pwm spi pruout pruin 
    P9_41_pinmux : default gpio timer pruin 
    P9_91_pinmux : default gpio qep pruout pruin 
    P9_42_pinmux : default gpio pwm uart spics spiclk 
    P9_92_pinmux : default gpio qep pruout pruin 

You will need to reference the AM335x data sheet and Technical Reference
Manual from TI to determine how to setup pin multiplexing for the
various special functions.  I find the following reference quite
helpful, particularly the spreadsheet file:

    https://github.com/selsinork/beaglebone-black-pinmux

Eventually, I hope to write a utility to handle setting up pin
multiplexing for the various functions that will translate BeagleBone
pin numbers to kernel gpio numbers for you and assist with multiplexing
all signals required for those functions with multiple I/O pins, such
as spi.

