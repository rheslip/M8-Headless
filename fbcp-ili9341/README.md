fbcp-ili9341 modded source files

config.h - added the GPIO pins used for battery gauge

low_battery.c - added four new icons for the battery display and positioned so they are in the same spot as the M8 - under the VU meters. Displays battery full, 3/4, half, or low in red based on the GPIO inputs which are active low.

