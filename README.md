# M8 Headless
 M8 Headless recipe using Raspberry Pi Zero 2 W
 Jan 2024
 
 short demo https://youtu.be/lyha2_3JbOE 
 
 ![Alt text](https://github.com/rheslip/M8-Headless/blob/main/Images/IMG_2594.jpg "DIY M8 Headless")
 ![Alt text](https://github.com/rheslip/M8-Headless/blob/main/Images/IMG_2592.JPG "DIY M8 Headless")
 
 UPDATE Aug 9 2024 - M8 headless firmware 4.0 is out with some cool new features but the audio no longer works with a direct connection to the DAC as documented below. I probably should have kept my mouth shut...
 
 Why?

I wanted to try the Dirtywave M8 tracker without spending $$$ on the real deal. I have seen other similar projects using Raspberry Pi 4 but I figured it could be done with a Raspberry Pi Zero 2 W. This build is smaller, cheaper, consumes less power and if I do say so myself is more elegant than the other standalone M8 Headless projects I've seen.
 
 Its relatively cheap to build ~ $150 but it requires serious electronic building skills and experience configuring Linux. 
 
 Why Not? 
 
The headless M8 firmware does not support audio input, MIDI, or touchscreen. If you want the full functions of an M8, buy an M8. If you don't like fiddling with electronics and Linux for days on end, buy an M8.
 
 I have spent at least 60 hours on the project and its still not really finished. Most of that time was researching and configuring Linux to boot into M8C, installing the TFT driver, configuring the GPIOs etc. The actual electronics build was fairly straightforward. The 3D printed enclosure is still in progress but usable.
 

 
 Hardware
 
 You will need:
 
 Teensy 4.1 with the M8 headless code installed
 
 Raspberry Pi Zero 2W
 
 Short USB OTG cable to connect the two: I used this one https://www.amazon.ca/dp/B07FBZ963D?psc=1&ref=ppx_yo2ov_dt_b_product_details
 
 8 key switches with caps - I used the same Kailh 1350 low profile switches that are used on the M8. You can find these on Amazon or Aliexpress
 
 Display - one with an ILI9341 controller chip will make things easier. I used this one https://www.amazon.ca/gp/product/B0B1M9S9V6?tag=elfster04-20&th=1
 
 Battery pack and charger. I used a 2S Lipoly 1500mah pack which gives around 4 hrs usage. I used this charger module https://www.aliexpress.com/item/1005006042283437.html?spm=a2g0o.order_list.order_list_main.40.38ee18029ofbrc
 
 5V Step down regulator - I used a cheap one from Aliexpress. You could use a 1S Lipoly with a 5V stepup regulator instead.
 
 Audio DAC - UDA1334 module https://www.adafruit.com/product/3678. I used a cheap knockoff from Aliexpress
 
 SD cards for the Teensy and Pi - see the M8 site for recommended cards for the Teensy
 
 I wired mine on a Vector #8015 protoboard which is 4" x 6". Slightly larger than the M8 but I'm also using a 3.2" display vs the M8's 2.8"
 
 Misc other stuff - wire, on/off switch, tact switch for shutting down the Pi
 
 Power Consumption
 
 I measure about 320ma for the whole shebang (Pi and Teensy) at 7.6V when idle. This jumps up to around 400ma when the screen gets very busy as when a song is playing.
 
 
 Wiring
 
There is no wiring diagram. If you can't figure it out from the code and config files then you don't have the skills to complete this project. 

Wire the display to the PI's SPI port, the keyswitches to the GPIO pins specified in /boot/config.txt. I made a drilling template to mount the Kailh switches on the .1" grid protoboard - the leads more or less fit on .1" grid but the plastic mounting pins do not.

There is a tact switch from Pi physical pin 5 to GND as a shutdown switch. This is enabled in /boot/config.txt.

You can wire the DAC directly to the Teensy's I2S pins for audio. Other M8 headless projects seem to loop USB audio from the Teensy to the PI to a DAC attached to the Pi which is not very elegant and chews needless CPU cycles. The UDA1334 module works with its default settings - connect Teensy LRCLK (pin 20), BLCK (pin 21) and OUT1A (pin 7) to the module. The headphone out is very loud so you will probably have to turn down the master level in the M8 mixer screen.

The battery is wired to a 2.1mm power jack so it can be charged with an external charger. I plan to embed the USB C charging module (linked above) in the enclosure at some point.

I wired up a battery gauge using two MIC803-30, a MIC803-31 (what I had) and a resistor divider chain. These pull PI gpio pins 17,27 and 22 low in sequence as the battery voltage drops. I modded the TFT driver low battery code to draw four different battery icons based on the GPIO inputs. The modded code is here as an example of tweeking the TFT driver but its pretty specific to the circuit I used.


Enclosure

There is 3D printable enclosure in OpenSCAD for this project. Its still a work in progress. Its a bit taller, wider and thicker than the M8. The enclosure needs lots of ventilation - heatsinks were added to the Teensy and the Pi. The Pi overheat icon appears on the display sometimes when there is a lot of screen activity and CPU use.


TFT driver

This is the magic that allows 25-45 fps on a PI Zero 2W. It copies the 640x480 X frame buffer to the TFT over the PI's SPI bus. https://github.com/juj/fbcp-ili9341.git 

Very helpful wiring diagrams and installation instructions: https://bytesnbits.co.uk/retropie-raspberry-pi-0-spi-lcd/

You will want to configure your Pi display for 640x480 so it downscales nicely to 320x240 on the TFT. If the TFT display looks fuzzy check LXDE altialiasing may be turned on - see the O/S configuration notes below.


GPIO Keys

I used GPIO keys to generate keypress events which are read by the M8C display software - see /boot/config.txt. It uses the default keycodes for M8C to keep things simple. The other M8 headless implementations I've seen use a Python app running in the background to scan the keys and send keycodes. Why not use the device tree overlay intended for that purpose ?


Linux

There is no prebuilt image for the PI - building it from scratch is educational. This took days of research and testing to get a recipe that works!

Started with Raspberry Pi Bullseye Desktop (32 bit) but the response to the keys was very laggy at times. Switched to DietPi (another couple days work) and the lag issue was greatly reduced. There are still short delays now and then from a keypress until you see the response on the display - Linux swapping, a background task kicking in? Possible performance improvements: R/O filesystem, log to ramdisk etc

My notes on how to build the image - NOT a shell script, its just my way of making notes:

download the Raspberry Pi 32 bit Bullseye (ARMv7) image from https://dietpi.com/downloads/images/

image with Raspberry Pi imager - enable SSH so you can remote login. you could also do the config with a keyboard and screen attached to the Pi

login via SSH: root dietpi (default user/password for this image. don't need sudo because you are root)

when you login via ssh, it runs an update script and then runs the config tool dietpi-launcher. Make these changes:

	disable UART login
	
	set screen rez 640x480
	
	install LXDE desktop. I also changed the ssh server to OpenSSH which works well with WinSCP for remote file management
	
	you have to "exit with install" - it finishes the final installation which takes a while
	
- changes to /boot/config.txt:
 
set to vga mode by uncommenting hdmi_group=1 and hdmi_mode=1
 
uncomment the hdmi_force-hotplug line so it always starts the display code

uncomment the two hdmi_resolution lines

comment the #dtoverlay=vc4-kms-v3d line if present
 
comment the audio, SPI, I2C etc if enabled - the display driver uses its own SPI implementation

add the gpio-key mappings for the keys:
 
	dtoverlay=gpio-key,gpio=5,active_low=1,gpio_pull=up,label=down,keycode=108
	dtoverlay=gpio-key,gpio=6,active_low=1,gpio_pull=up,label=up,keycode=103
	dtoverlay=gpio-key,gpio=13,active_low=1,gpio_pull=up,label=left,keycode=105
	dtoverlay=gpio-key,gpio=19,active_low=1,gpio_pull=up,label=right,keycode=106
	dtoverlay=gpio-key,gpio=26,active_low=1,gpio_pull=up,label=shift,keycode=42
	dtoverlay=gpio-key,gpio=16,active_low=1,gpio_pull=up,label=enter,keycode=31
	dtoverlay=gpio-key,gpio=20,active_low=1,gpio_pull=up,label=option,keycode=30
	dtoverlay=gpio-key,gpio=21,active_low=1,gpio_pull=up,label=play,keycode=57
	dtoverlay=gpio-shutdown    # for the shutdown button on default pin 5
	gpio=17=ip,pu    # set gpio 17 (pin 11) as the low battery input
	gpio=27=ip,pu   # half battery level input
	gpio=22=ip,pu # 3/4 battery level

thats it for changes to /boot/config.txt

- install tools we need to build the TFT driver

apt-get install git 

apt-get install cmake

apt install build-essential  # not even a c compiler in this distro!

apt-get install libraspberrypi-dev raspberrypi-kernel-headers # need these to build the driver

cd /root

git clone https://github.com/juj/fbcp-ili9341.git # get the TFT driver source

cd fbcp-ili9341

- at this point make any source changes to the driver code e.g. if you want a low battery display, battery gauge etc you may want to change config.h and lowbattery.c

mkdir build

cd build

- build line below assumes IlI9341 display driver chip and low battery input on GPIO 17. I had to rotate my display as well

cmake -DILI9341=ON -DGPIO_TFT_DATA_CONTROL=24 -DGPIO_TFT_RESET_PIN=25 -DSPI_BUS_CLOCK_DIVISOR=6 -DDISPLAY_ROTATE_180_DEGREES=ON -DSTATISTICS=0 -DLOW_BATTERY_PIN=17 ..

make -j    #this builds the TFT display code. 

- create a systemd file to start up the TFT service - its not a linux driver, it just runs in the background

nano /etc/systemd/system/fbcp.service  # with contents:

	[Unit]
	Description=Start up FBCP driver
	[Service]
	Type=oneshot
	ExecStart=/root/fbcp-ili9341/build/fbcp-ili9341
	[Install]
	WantedBy=multi-user.target

#start the TFT driver service - will start on next boot:

systemctl enable fbcp.service

- build the M8C display software which runs in the LXDE desktop environment

cd /root

apt install -y git gcc pkg-config make libsdl2-dev libserialport-dev  

mkdir code 

cd code

git clone https://github.com/laamaa/m8c.git   #get the M8C display code

cd m8c

make    # build M8C

- create LXDE autostart file to launch M8C /root/.config/dietpi-desktop_setup.desktop/m8c.desktop with this in it:

	[Desktop Entry]
	Type=Application
	Name=M8C
	Exec=/root/code/m8c/m8c

I didn't have to change the Teensy USB serial port, M8C seemed to find it. YMMV

- tweeks needed to get LXDE to run M8C full screen:

nano /root/.config/openbox/lxde-rc.xml  #add the fragment of xml below. it goes near the bottom of the file in the applications section. this removes the decoration (bar above the app window)

	<application name="*">
        <decor>no</decor>	
        </application>
		
- to remove the LXDE menus comment (with a #) the line @lxpanel --profile LXDE  in the file:

/etc/xdg/lxsession/LXDE/autostart

- to remove the mouse cursor in LXDE add the -nocursor option to the x command in

/etc/X11/xinit/xserverrc 

 - to turn off font antialiasing change iXft/Antialias=1 to iXft/Antialias=0 in the file:

/etc/xdg/lxsession/LXDE/desktop.conf   


