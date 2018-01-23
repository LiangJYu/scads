// mounting plate parameters
w_plate = 66.1;
l_plate = 82.4;
h_plate = 1;
r_plate_corner = 2;

// bracket mounting hole parameters
d_plate_bolt = 6;
x_hole_space = 38.76+d_plate_bolt;
y_hole_space = 59.45+d_plate_bolt;

// bracket opening parameters
w_opening = 30;
l_opening = 40.5;

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

mounting_plate();