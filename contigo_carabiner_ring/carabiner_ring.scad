cup_circumference = 221;
//cup_diameter = 71.5;
cup_diameter = cup_circumference/ PI;
cup_radius = cup_diameter/2;
little_pad = 1.5;
loop_diameter = 15;
loop_radius = loop_diameter/2;

ring_minor_r = 5;
ring_major_r = 10;
arc_opening = 40;
arc = arc_opening/cup_radius*180/PI;
arc_chord = 2*cup_radius*sin(arc/2);
ring_opening = 40;

// cup holding ring
module big_ring() {
    difference() {
        rotate_extrude(convexity = 10, $fn=100)
            // translate ring so that wraps around lip of cup
            translate([cup_radius+ring_minor_r/2, 0, 0]) 
                resize([ring_minor_r,ring_major_r]) circle(r = 1, $fn=100);
        translate([0,0,-ring_major_r]) {
            linear_extrude(height=2*ring_major_r)
                polygon([[0,0],[-cup_radius*1.5,arc_chord*0.75],[-cup_radius*1.5,-arc_chord*0.75]]);
        }
    }
}

module under_button_ring() {
    arc_slim = (arc_opening+little_pad)/cup_radius*180/PI;
    slim_chord = 2*cup_radius*sin(arc_slim/2);
    difference() {
        difference() {
            cylinder(h=ring_major_r,r=cup_radius+little_pad,center=true, $fn=100);
            cylinder(h=4*ring_major_r,r=cup_radius,center=true, $fn=100);
        }
        translate([0,0,-ring_major_r]) {
            linear_extrude(height=2*ring_major_r)
                polygon([[0,0],[-cup_radius*1.5,slim_chord*0.75],[0,2*cup_radius],[2*cup_radius,0],[0,-2*cup_radius],[-cup_radius*1.5,-slim_chord*0.75]]);
        }
    }
}

// carabiner ring
module carabiner_loop() {
    difference() {
        // translate loop to center of ring
        translate([0,cup_radius+ring_minor_r/2,0])
            rotate_extrude(convexity = 10, $fn=100)
                // 
                translate([loop_radius+ring_minor_r, 0, 0]) 
                    resize([ring_minor_r,ring_major_r]) circle(r = 1, $fn=100);
        cylinder(h=2*ring_major_r, r=cup_radius+ring_minor_r/2, center=true);
    }
}

union() {
    big_ring();
    carabiner_loop();
    under_button_ring();
}

//color("MistyRose", 0.5) { 
//    difference() {
//        cylinder(r=cup_radius, h=20, center=true, $fn=100);
//        translate([0,0,-15]) cube(2*cup_diameter);
//    }
//}

//difference() {
//    rotate_extrude(convexity = 10, $fn=100)
//        // translate ring so that wraps around lip of cup
//        translate([cup_radius+ring_minor_r/2, 0, 0]) 
//            resize([ring_minor_r,ring_major_r]) circle(r = 1, $fn=100);
//    translate([0,0,-ring_major_r]) {
//        linear_extrude(height=2*ring_major_r)
//            polygon([[0,0],[-75,20],[-75,-20]]);
//    }
//}
//
//// carabiner ring
//difference() {
//    // translate loop to center of ring
//    translate([cup_radius+ring_minor_r/2,0,0])
//        rotate_extrude(convexity = 10, $fn=100)
//            // 
//            translate([loop_radius+ring_minor_r, 0, 0]) 
//                resize([ring_minor_r,ring_major_r]) circle(r = 1, $fn=100);
//    cylinder(h=2*ring_thickness, r=cup_radius+ring_minor_r/2, center=true);
//}
