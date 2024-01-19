
// M8 bezel Jan 18 2024
// split into base and top part that is glued
// supports are impossible to remove when printed in one go

width=104;
wall_thickness=1;
top_thickness=1.0; // top layer over glass
base_height=4;
layer2_height=2.5;
post_height=10;

module screwhole(hole=3,height=10) {

        cylinder(h=height,r1=hole/2,r2=hole/2,center=true);
}

module rounded_cube(x,y,z,r) {
    linear_extrude(height=z) translate([r,r,0]) offset(r=r) square([x-2*r,y-2*r]);
}

module hollow_cube(height,length,cutx,cuty,cutheight,cutlength,depth,r) {
    difference () {
        rounded_cube(height,length,depth,r);
        translate([cutx,cuty,0]) rounded_cube(cutheight,cutlength,depth,0);

    }
}

difference () {
    union() {
    //    hollow_cube (72, 104,10,7,56,91,base_height,1); // bottom
       hollow_cube (60,90+wall_thickness*2,wall_thickness,wall_thickness,60-wall_thickness*2,90,layer2_height,1);  // layer over display PCB
        translate([0,0,layer2_height]) hollow_cube (60,90+wall_thickness*2,4,10,51,72,top_thickness,1);  // top layer over glass       
    };
 //   translate([25.5,3.5,0]) screwhole(1.5,post_height); // BL
//    translate([25.5,width-3.5,0]) screwhole(1.5,post_height); 
//    translate([3.5,26.5,0]) screwhole(1.5,post_height); 
//    translate([3.5,width-26.5,0]) screwhole(1.5,post_height); 
}
