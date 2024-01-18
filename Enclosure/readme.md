OpenSCAD files for M8 Headless - Jan 2024

The main enclosure and the top use YAPPBox which is a parametric enclosure designing script:
https://github.com/mrWheel/YAPP_Box

I think I used a slightly older version of the script V19? and I may have modded the Yappbox script a bit

The bottom of the M8 case is actually what Yappbox calls the top. The PCB dimensions and mounting holes are for a 4x6" Vector board #8015. I fudged the space around the PCB so the PCB sits on the enclosure inner edge which is normally where the other half of the enclosure fits.
I may change this so its a normal top/bottom with the PCB clamped between but this will push the dimensions of the enclosure out a bit.

The top is just a flat sheet with mounting holes that sits on top of the PCB with cutouts for the keys and the shutdown button. It sits on top of the PCB and held to the base part wih 2-56 screws threaded into the bosses in the base. Its not great but it looks better than the raw PCB. Note that you will have to trim any wires etc that poke thru the top side of the PCB so the top will sit flush.

The bezel is still a work in progress. Plan is to print it in two parts and glue them together - printing with supports for the overhangs did not work well. Bezel mounts on top of the top sheet with 2-56 screws into the same bosses in the base.

If you change the display, the location of the keys etc the files will have to be adjusted accordingly. I had to drill approx 100 holes in the bottom part and andother 20 or so on the top edge for ventilation because both the Teensy and the Pi run quite hot. There are some side vents in the CAD files but I have not added the holes yet.

