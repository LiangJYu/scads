// mounting plate parameters
w_plate = 66.1;
l_plate = 82.4;
h_plate = 5;
r_plate_corner = 2;

// bracket mounting hole parameters
d_bolt = 6.4;
x_hole_space = 37+d_bolt;
y_hole_space = 57+d_bolt;

// bracket opening parameters
w_opening = 30;
l_opening = 40.5;

w_bracket = 30;
l_bracket = 22;
bracket_thickness = 4;
l_bracket_support = (l_plate-l_opening-2*bracket_thickness)/2; // length of piece above & below bracket
d_bracket_bolt = 6.4;

r_fillet = 2;
$fn=50;


module fillet(length, r=r_fillet) {
    linear_extrude(height=length) {
    difference() {
        square(r);
        translate([r,r,0])
        circle(r);
    }
}
}

// subpart that goes on the post
module mounting_plate() {
    difference() {
        // extrude to spec'd height
        linear_extrude(height=h_plate) {
            // add corners
            offset(r=r_plate_corner)
            // create square plate w/o corners
            square([w_plate-r_plate_corner*2, l_plate-r_plate_corner*2], center=true);
        }
        // create 4 holes based on spacing parameters to be subtracted
        for (i=[-1:2:1]) {
            for (j=[-1:2:1]) {
                translate([i*x_hole_space/2, j*y_hole_space/2,h_plate/2])
                cylinder(h=2*h_plate, d=d_bolt, center=true);
            }
        }
        // create opening in middle of mounting plate
        translate([0,0,-h_plate/2])
            linear_extrude(height=2*h_plate)        
                offset(r=r_plate_corner)
                    square([w_opening-r_plate_corner*2, l_opening-r_plate_corner*2],center=true);
    }
}

// subpart the holds the arm
module mounting_bracket() {
    difference() {
        // plate perpindicular to mounting plate
        cube([w_bracket,bracket_thickness,l_bracket]);
        // hole for mounting bolt
        translate([w_bracket/2,bracket_thickness/2,l_bracket/2])
        rotate([90,0,0])
        cylinder(h=2*bracket_thickness, r=d_bolt/2, center=true);        
    }
    // fillet bracket to base plate    
    translate([w_bracket-bracket_thickness,0,0])
    rotate([0,0,-90])
    rotate([90,0,0])
    fillet(w_bracket-2*bracket_thickness);    
    // create 2 bracket supports
    for (i=[0,1]) {
        difference() {
            union() {
                 // translate to edge
                translate([bracket_thickness+i*(w_bracket-bracket_thickness),0,0]) {
                    rotate([0,0,-90])
                    rotate([90,0,0])
                    linear_extrude(height=bracket_thickness)
                    square([l_bracket_support,l_bracket]);
                    // fillet 1 bracket support to base plate
                    translate([0,bracket_thickness,0])
                    rotate([90,0,0])
                    fillet(l_bracket_support+bracket_thickness);
                    // fillet 2 bracket support to base plate
                    translate([-bracket_thickness,bracket_thickness,0])
                    rotate([90,0,0]) 
                    rotate([0,0,90])
                    // fillet 3 bracket support to bracket
                    fillet(l_bracket_support+bracket_thickness);
                    translate([-i*bracket_thickness,0,0])
                    rotate([0,0,-90+i*270])
                    fillet(l_bracket);
                }
            }
            h_extrude = 2*(bracket_thickness+2*r_fillet);
            h_diff = h_extrude/4;
            buffer = 1.1;
            translate([-h_diff+i*(w_bracket-bracket_thickness),(buffer-1)*l_bracket_support/2,-(buffer-1)*l_bracket/2])
            rotate([0,0,180])
            rotate([0,-90,0])
            linear_extrude(height=h_extrude)
            polygon([[l_bracket*buffer,l_bracket_support*buffer],[l_bracket*buffer,0],[0,l_bracket_support*buffer]]);
        }
    }
}

union() {
    mounting_plate();
    for (i=[0:1]) {
        translate([0,-l_opening/2-bracket_thickness+i*(l_opening+2*bracket_thickness),h_plate]) // translate to either side of bracket opening
        rotate([0,0,i*180])             // rotate 2nd bracket only
        translate([-w_bracket/2,0,0])   // move bracket corner from orgin so it's center aligned with hole
        mounting_bracket();
    }
}