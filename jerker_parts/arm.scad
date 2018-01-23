// speaker seat parameters
w_speaker_seat = 180;
l_speaker_seat = 150;
h_speaker_seat = 10;
r_plate_corner = 2;

// support arm parameters
l_arm = 130;
h_arm = 40.2;
w_arm = 20.25;

$fn=50;

module speaker_seat() {
    w_offset = w_speaker_seat-2*r_plate_corner;
    l_offset = l_speaker_seat-2*r_plate_corner;
    difference() {
        translate([100,-w_offset/2,-0.5*h_speaker_seat]) {
            rotate([0,0,90])
            minkowski() {        
                // create square plate
                cube([w_offset, l_offset, h_speaker_seat/2], center=true);
                // add rounded corners
                translate([w_offset/2, l_offset/2, 0])
                cylinder(h=h_speaker_seat/2, r=r_plate_corner,center=true);
            }
        }
        for (i=[-1:2:1]) {
            translate([10/2,i*(100/2-5),-10/2])
            cylinder(r=5/2, h=2*10, center=true);
        }
    }
}

module speaker_arm_bottom() {
    translate([0,-w_arm/2,0])
    difference() {
        cube([l_arm, w_arm, h_arm]/*, center=true*/);
        translate([119,w_arm/2,-h_arm/2]) 
        cylinder(r=5/2, h=2*h_arm);
    }
}

module speaker_support() {
    difference() {
        translate([0,-50,0])
        cube([10,100,4]);
        for (i=[-1:2:1]) {
            translate([10/2,i*(100/2-5),4/2])
            cylinder(r=5/2, h=2*4, center=true);
        }
    }
    //
    translate([10/2-4/2,0,4])
    rotate([0,90,0])
    rotate([0,0,90])
    linear_extrude(height=4)
    polygon([[-100/2+10,0],[100/2-10,0],[0,h_arm-4]]);
}

speaker_seat();
speaker_arm_bottom();
speaker_support();
