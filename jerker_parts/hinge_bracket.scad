w_plate = 66.1;
l_plate = 82.4;
h_plate = 5;
r_plate_corner = 2;

d_bolt = 5;
x_hole_space = 38.76+d_bolt;
y_hole_space = 59.45+d_bolt;

module mounting_plate() {
    difference() {
        linear_extrude(height=h_plate) {
            offset(r=r_plate_corner) 
            square([w_plate-r_plate_corner*2, l_plate-r_plate_corner*2], center=true);
        }
        for (i=[-1:2:1]) {
            for (j=[-1:2:1]) {
                translate([i*x_hole_space/2, j*y_hole_space/2,h_plate/2])
                cylinder(h=2*h_plate, r=d_bolt, center=true);
            }
        }
    }
}

module mounting_bracket() {
    difference() {
        cube([30,4,22]);
        translate([30/2,4/2,22/2])
        rotate([90,0,0])
        cylinder(h=2*4, r=6, center=true);
    }
    for (i=[0,1]) {
        translate([4++i*(30-4),0,0])
        rotate([90,0,0])
        rotate([0,-90,0])
        linear_extrude(height=4)    
        polygon([[0,0],[0,22],[20,0]]);
    }
    /*
    for (i=[0,1]) {
        translate([i*(30-4),-20,0])
        cube([4,20,22]);
    }
    */
    
}

union() {
    mounting_plate();
    for (i=[0:1]) {
    translate([0,-l_plate/4+i*l_plate/2,h_plate])
    rotate([0,0,i*180])
    translate([-15,0,0])
    mounting_bracket();
    }
}