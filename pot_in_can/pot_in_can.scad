$fn = 150;
buffer = 20;

// adjustable parameters
d_can_upper = 73;
h_can = 100;
h_lip = 15;
thickness = 1.5;
gap = 1.5;
connect_angle = 50;
hole_width = 2;
hole_height = 6;

// calculate
d_can_lower = d_can_upper / 2;
percent_upper = 0.52;
percent_lower = 0.2;
h_can_upper = h_can * percent_upper;
h_can_lower = h_can * percent_lower;
r_can_upper = d_can_upper / 2;
r_can_lower = d_can_lower / 2;
    h_connect_lo = (1-percent_lower)*h_can;
    h_connect_up = percent_upper*h_can;

module connector_2d() {
    points = [[r_can_upper-thickness/2-gap,h_connect_up],
                [r_can_upper+thickness/2-gap,h_connect_up],
                [r_can_lower+thickness,h_connect_lo],
                [r_can_lower,h_connect_lo]];
    polygon(points);
}

module round_corners() {
    trans = [[r_can_upper-(thickness+gap)/2,0],
            [r_can_upper+(thickness+gap)/2,0],
            [r_can_upper+(thickness+gap)/2,h_lip],
            [r_can_lower+thickness/2,h_can]];
    for (i=[0:3])
        translate(trans[i])
            circle(d=thickness);
}

    
module soak_holes(n_holes,height,r) {    
    for (i=[0:n_holes]) {
        angle_offset = i*360/n_holes;
        translate([0,0,height])
            rotate([0,0,angle_offset]) scale([d_can_upper,1,1]) translate([0.5,0,0])
                union() {
                    cube([1, hole_width, hole_height], center=true);
                    for (i=[-1:2:1]) {
                        translate([0,0,i*hole_height/2])
                            rotate([0,90,0])
                                cylinder(d=hole_width,h=1,center=true);
                    }
                }
    }
}

module half_profile() {
    union() {
        // upper inner container
        translate([r_can_upper-thickness/2-gap,0])
            square([thickness, h_can_upper]);
        // upper lower  container connector
        connector_2d();
        // lower inner container side wall
        translate([r_can_lower,(1-percent_lower)*h_can])
            square([thickness, h_can_lower]);
        // lower inner container bottom
        translate([0,h_can-thickness/2])
            square([r_can_lower+thickness/2, thickness]);
        // lip
        translate([r_can_upper+gap/2,0])
            square([thickness, h_lip]);
        // container lip connector
        translate([r_can_upper-(gap+thickness)/2,-thickness/2])
            square([gap+thickness,thickness]);
        // round corners
        round_corners();
    }
}


module outer_ring_upper() {
    difference() {
        translate([0,0,(2*d_can_upper-thickness)/2])
            cube(2*d_can_upper, center=true);
        translate([0,0,(2*d_can_upper)/2])
            cylinder(d=d_can_upper-(thickness+gap/2),h=2*d_can_upper+buffer, center=true);
    }
}

module outer_ring_mid() {
    rotate_extrude() {
        points = [[r_can_upper+thickness/2-gap,h_connect_up],
                    [r_can_lower+thickness,h_connect_lo],
                    [r_can_upper+thickness/2-gap,h_connect_lo]];
        polygon(points);
    }
}

module watering_hole_shell() {
    r = 1.15*d_can_lower;
    angle = 30;
    h_water = (1-percent_lower)*h_can;
    difference() {
        // watering tube
        translate([r*cos(angle),r*sin(angle),-thickness/2])
            rotate([0,0,angle]) scale([1.15,0.7,1])
                difference() {
                    cylinder(d=d_can_lower, h=h_water);
                    translate([0,0,-buffer/2])
                        cylinder(d=d_can_lower-thickness, h=h_water+buffer);
                }
        // trim outside upper container
        translate([0,0,-buffer/2])
            outer_ring_upper();
        // trim outside mid container
        translate([0,0,0])
            outer_ring_mid();
    }
}

difference() {
    rotate_extrude()
        half_profile();
    soak_holes(8, h_can-h_can_lower/2);
    soak_holes(6, (h_can+h_can_upper-h_can_lower)/2);
}
watering_hole_shell();
//outer_ring_upper();