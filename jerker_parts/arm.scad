// speaker seat parameters
w_speaker_seat = 180;
l_speaker_seat = 150;
h_speaker_seat = 15;
r_plate_corner = 2;

// support arm parameters
l_arm = 

module speaker_seat() {
    
    minkowski() {
        w_offset = w_speaker_seat-2*r_plate_corner;
        l_offset = l_speaker_seat-2*r_plate_corner;
        // create square plate
        cube([w_offset, l_offset, h_speaker_seat], center=true);
        // add rounded corners
        for (i=[-1:1]) {
            for (j=[-1:1]) {
                translate([i*w_offset/2, j*l_offset/2, 0])
                cylinder(h=h_speaker_seat, r=r_plate_corner);
            }
        }
    }
}

module speaker_arm_bottom() {
    
}

speaker_seat();
speaker_arm_bottom();