// speaker seat parameters
w_speaker_seat = 180;
l_speaker_seat = 150;
h_speaker_seat = 15;
r_plate_corner = 2;

// support arm parameters
l_arm = 130;
h_arm = 40.2;
w_arm = 20.25;

module speaker_seat() {
    
    minkowski() {
        w_offset = w_speaker_seat-2*r_plate_corner;
        l_offset = l_speaker_seat-2*r_plate_corner;
        // create square plate
        cube([w_offset, l_offset, h_speaker_seat], center=true);
        // add rounded corners
        for (i=[-1:2:1]) {
            for (j=[-1:2:1]) {
                translate([i*w_offset/2, j*l_offset/2, 0])
                cylinder(h=h_speaker_seat, r=r_plate_corner);
            }
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
}

//speaker_seat();
speaker_arm_bottom();
speaker_support();
