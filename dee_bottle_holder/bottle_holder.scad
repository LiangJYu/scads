$fn=50;
thickness = 1.5;
d_cup = 34.5;
r_cup = d_cup/2;
r_cup_hole = r_cup/2;
h_cup = 30;
r_fillet = 1;
n_rows = 4;
n_cols = 2;
cup_spacing = d_cup+thickness;

// TODO add slope to from sidewall to hole opening
// TODO add balls as feet bottom of holder every row tangent intersetction

x_fillet = r_cup-r_fillet;
slope_angle = atan2(thickness,r_cup-r_cup_hole);
y_fillet0 = r_fillet*cos(slope_angle);
y_fillet1 = thickness*(1-r_fillet/(r_cup-r_cup_hole));
y_fillet = thickness+y_fillet0+y_fillet1;
circle_fillet_center = [x_fillet, y_fillet];
square_fillet_corner = [x_fillet, y_fillet-r_fillet];
// array of bottle holders
for (row = [0:cup_spacing:(n_rows-1)*cup_spacing]) {
    for (col = [0:cup_spacing:(n_cols-1)*cup_spacing]) {
        translate([col,row,0]) {
            rotate_extrude() {
                difference() {
                    translate([r_cup,0,0])
                        square([thickness,h_cup+2*thickness]);
                    difference() {
                        translate([r_cup+thickness-r_fillet,0,0])
                            square(r_fillet);
                        translate([r_cup+thickness-r_fillet,r_fillet,0])
                            circle(r_fillet);
                    }
                }
                polygon([[r_cup_hole,0],[r_cup,0],[r_cup,2*thickness],[r_cup_hole,thickness]]);
                difference() {
                    translate(square_fillet_corner)
                        square(r_fillet);
                    translate(circle_fillet_center)
                        circle(r_fillet);
                }
                translate([r_cup+thickness/2,h_cup+2*thickness])
                                    circle(thickness/2);
                translate([r_cup_hole,thickness/2])
                                    circle(thickness/2);
            }
        }
    }
}

angle = acos((r_cup+thickness/2)/(r_cup+thickness));
y = 2*(r_cup+thickness/2)*sin(angle);

module feet(col, n_row_ints, rot, row_offset) {
    for (row = [0:n_row_ints]) {
        translate([col*cup_spacing/2,row*cup_spacing+row_offset,0]){
            rotate(rot) {
                foot();
            }
        }
    }
}

module foot() {
    union() {
    rotate([0,90,0])
        scale([1,thickness,y-thickness])
            cylinder(d=1,h=1,center=true);
    for (k=[-1:2:1]) {
        scale([1,thickness,1])
            translate([k*(y/2-thickness/2),0,0])
                sphere(d=1,center=true);
    }}
}

//color("Gold")
for (col = [0:n_cols]) {
    if (col%2==1) {
        n_row_ints = 3;
        rot = [0,0,90];        
        row_offset=0;
        feet(col, n_row_ints, rot, row_offset);
    } else {
        n_row_ints = 2;
        rot = [0,0,0];
        row_offset=cup_spacing/2;
        feet(col, n_row_ints, rot, row_offset);
    }
}