// speaker seat parameters
w_speaker_seat = 180;
l_speaker_seat = 150;
h_speaker_seat = 10;
r_plate_corner = 2;
angle_arm = 30; // deg: measured from plane normal to arm direction

// support arm parameters
l_arm = 130;
h_arm = 40.2;
w_arm = 20.25;
d_arm_under_seat = 100;
d_holes = 6.35;
support_thickness = 4;
$fn=50;

module speaker_arm() {
    translate([0,-w_arm/2,0])
    difference() {
        linear_extrude(height=h_arm) {
            union() {
                translate([w_arm/2,0,0])
                square([l_arm-w_arm,w_arm]);
                for (i=[0,1]) {
                    translate([w_arm/2+i*(l_arm-w_arm),w_arm/2])
                        circle(d=w_arm);
                }
            }
        }
        // hole for attaching to bracket
        translate([d_arm_under_seat+19,w_arm/2,-h_arm/2]) 
        cylinder(r=d_holes/2, h=2*h_arm);
        // hole for attaching in direction of arm
        translate([d_arm_under_seat-19,w_arm/2,-h_arm/2])
        cylinder(r=d_holes/2, h=2*h_arm);
    }
}

module speaker_support() {
    d_projected = l_speaker_seat/cos(angle_arm);
    echo(d_projected);
    difference() {
        translate([0,-d_projected/2,0])
        cube([h_speaker_seat,d_projected,4]);
        // holes perpindicular to direction of arm
        for (i=[-1:2:1]) {
            translate([h_speaker_seat/2,i*(d_projected/2-d_holes),4/2])
            cylinder(r=d_holes/2, h=2*support_thickness, center=true);
        }
    }
    //
    translate([(h_speaker_seat-support_thickness)/2,0,support_thickness])
    rotate([0,90,0])
    rotate([0,0,90])
    linear_extrude(height=support_thickness)
    polygon([[-d_projected/2+15,0],[d_projected/2-15,0],[0,h_arm-4]]);
}

union() {
    color("red")
    translate([-h_speaker_seat/2,0,0])
    speaker_arm();
    translate([w_arm/4,0,0])
    for (i=[-1:2:1]) {
        rotate([0,0,i*angle_arm])
        translate([-h_speaker_seat/2,0,0])
        speaker_support();
    }
}

//speaker_support();