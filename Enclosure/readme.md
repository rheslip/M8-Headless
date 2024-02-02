OpenSCAD files for M8 Headless - Jan 2024

The main enclosure and the top use YAPPBox which is a parametric enclosure designing script:
https://github.com/mrWheel/YAPP_Box

I used a slightly older version of the script (V19) with some small tweeks that I don't remember now (modified connectors?). My modded Yappbox script is included.

The bottom of the M8 case is actually what Yappbox calls the top. The PCB dimensions and mounting holes are for a 4x6" Vector board #8015. I fudged the space around the PCB so the PCB sits on the enclosure inner edge which is normally where the other half of the enclosure fits.
I may change this so its a normal top/bottom with the PCB clamped between but this will push the dimensions of the enclosure out a bit.

M8box_04 - revised version of bottom case for USB-C charger module and added a lot more ventilation. Hopefully this prevents the overheat indicator on the Pi desktop. Also added larger heatsinks to both processors.

M8box_05 - even more vents and a cutout for an 18x18mm heatsink I added to the Pi Zero 2 W. Pi desktop still shows an overheat icon if there is a lot of screen activity for ~30 minutes. Not much more I can do to cool it passively.

M8batterybox - I swapped out the 1500mah Lipoly pack for 2x 18650 LIon batteries for more capacity. This box is designed to be glued into the bottom of the case to secure the 18650s.

The top is just a flat sheet with mounting holes that sits on top of the PCB with cutouts for the keys and the shutdown button. It sits on top of the PCB and held to the base part wih 2-56 screws threaded into the bosses in the base. Its not great but it looks better than the raw Vector perfboard PCB. Note that you will have to trim any wires etc that poke thru the top side of the PCB so the top will sit flush.

Print the bezel in two parts (m8bezelbase and m8bezeltop) and glue them together. The first bezel design with supports did not work well - supports were virtually impossible to remove after 3D printing. Bezel mounts on top of the top sheet with 2-56 screws into the same bosses in the base.

If you change the display, the location of the keyswitches etc the files will have to be adjusted accordingly.

