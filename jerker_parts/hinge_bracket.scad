// mounting plate parameters
w_plate = 66.1;
l_plate = 82.4;
h_plate = 5;
r_plate_corner = 2;

// bracket mounting hole parameters
d_plate_bolt = 5;
x_hole_space = 38.76+d_plate_bolt;
y_hole_space = 59.45+d_plate_bolt;

// bracket opening parameters
w_opening = 30;
l_opening = 40.5;

w_bracket = 30;
l_bracket = 22;
bracket_thickness = 4;
l_bracket_support = (l_plate-l_opening-2*bracket_thickness)/2; // length of piece above & below bracket
d_bracket_bolt = 5;
$fn=50;


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
                cylinder(h=2*h_plate, r=d_plate_bolt/2, center=true);
            }
        }
        translate([0,0,h_plate/2])
            cube([w_opening,l_opening,2*h_plate],center=true);
    }
}

module mounting_bracket() {
    difference() {
        // plate perpindicular to mounting plate
        cube([w_bracket,bracket_thickness,l_bracket]);
        // hole for mounting bolt
        translate([w_bracket/2,bracket_thickness/2,l_bracket/2])
        rotate([90,0,0])
        cylinder(h=2*bracket_thickness, r=d_bracket_bolt/2, center=true);
    }
    // create 2 bracket supports
    for (i=[0,1]) {
        translate([bracket_thickness+i*(w_bracket-bracket_thickness),0,0])  // translate to edge
        rotate([90,0,0])    // rotate in x 2nd
        rotate([0,-90,0])   // rotate in y 1st
        linear_extrude(height=bracket_thickness)    // extrude to spec'd thickness
        polygon([[0,0],[0,l_bracket],[l_bracket_support,0]]);   // create triangle to spec
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

