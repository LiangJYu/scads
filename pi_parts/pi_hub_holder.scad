$fn=50;

// all units in mm
edge_thick = 2;
mid_thick = 5;
hub_thick = 12.1;
pi_thick = 13.4;
top_height = 10;
mid_height = 20;
bottom_height = 30;
depth = 7;

linear_extrude(height=depth) {
    difference() {
        square([edge_thick+hub_thick, top_height]);
        translate([edge_thick,edge_thick])
            square([hub_thick, top_height]);
    }
    translate([edge_thick+hub_thick, 0]) {
        difference() {
            square([mid_thick+pi_thick, mid_height]);
            translate([mid_thick, edge_thick])
                square([pi_thick, mid_height]);
        }
    }
    translate([edge_thick+hub_thick+mid_thick+pi_thick, 0]) {
        square([edge_thick, bottom_height]);
    }
    translate([edge_thick/2,top_height]) {
        circle(d=edge_thick);
    }
    translate([edge_thick+hub_thick+mid_thick/2,mid_height]) {
        circle(d=mid_thick);
    }
    translate([1.5*edge_thick+hub_thick+mid_thick+pi_thick,bottom_height]) {
        circle(d=edge_thick);
    }
}