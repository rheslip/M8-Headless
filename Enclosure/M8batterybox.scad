
// M8 battery holder for 2x 18650 Feb 1 2024
// intended to be glued to the bottom inside of the base

width=18.25;  // inside width for one battery
length= 67; // inside length
wall_thickness=1.5;

depth=20;





module rounded_cube(x,y,z,r) {
    linear_extrude(height=z) translate([r,r,0]) offset(r=r) square([x-2*r,y-2*r]);
}

module hollow_cube(width,length,cutx,cuty,cutwidth,cutlength,depth,r) {
    difference () {
        rounded_cube(width,length,depth,r);
        translate([cutx,cuty,-1]) rounded_cube(cutwidth,cutlength,depth+2,0);

    }
}

difference () {
    union() {

        hollow_cube (width+wall_thickness*2,length+wall_thickness*2,wall_thickness      ,wall_thickness,width,length,depth,0);  //
       translate([width+wall_thickness,0,0]) hollow_cube (width+wall_thickness*2,length+wall_thickness*2,wall_thickness      ,wall_thickness,width,length,depth,0);  //  
      
    };
   translate([width,0-wall_thickness,depth-5]) rounded_cube(5,10,6,0); // endcutout for wires
   translate([width,length/2-2.5,depth-5]) rounded_cube(5,10,6,0); // center cutout for wires
}
