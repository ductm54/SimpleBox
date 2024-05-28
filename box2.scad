// Parameters
length = 135;  // Length of the box
width = 85;    // Width of the box
height = 80;   // Height of the box
radius = 10;    // Radius of the rounded corners
thickness = 1; // Wall thickness
hole_type = "hex"; // hex, cirle, diamond
// hole_size: parameter depend on type
// hex - 2 parameter: radius of hex, space between hex
// cirle - 2 parameter: radius of circle, space between circle
// diamond - 3 parameter: width of diamond, height of diamond
hole_size = [5, 2];

epsilon = 0.01;

// Main function
module rounded_box_with_holes(l, w, h, r, t, type, size) {
    difference() {
        rounded_box(l,w,h,r,t);
        // Pattern on 4 side of the wall, use thick = 2*t to ensure the cut, too lazy to find exact cut point, try to use t but sometime it does not work
        translate([0, (w-t)/2, 0]) rotate ([90, 0, 0]) hole_pattern(l-2*r, h, 2*t, type, size);
        translate([0, -(w-t)/2, 0]) rotate ([90, 0, 0]) hole_pattern(l-2*r, h, 2*t, type, size);
        translate([(l-t)/2, 0, 0]) rotate ([0, 90, 0]) rotate([0, 0, 90]) hole_pattern(w-2*r, h, 2*t, type, size);
        translate([-(l-t)/2, 0, 0]) rotate ([0, 90, 0]) rotate([0, 0, 90]) hole_pattern(w-2*r, h, 2*t, type, size);
    }
}

// Module to create round box
module rounded_box(l,w,h,r,t) {
    difference() {
        // Box with rounded corners
        minkowski() {
            cube([l - 2*r, w - 2*r, h-epsilon], center = true);
            cylinder(r=r,h=epsilon);
        }
        
        // Inner box for hollow part
        translate([0, 0, t])
            minkowski() {
                cube([l - 2*r - 2*t, w - 2*r - 2*t, h - epsilon], center = true);
                cylinder(r=r,h=epsilon);
            }
    }
}

// Module to create hole pattern
module hole_pattern(l, h, t, type, size, spacing) {
    if (type == "hex") hex_hole_pattern(l,h,t, size[0], size[1]);
    else if (type == "circle") circle_hole_pattern(l,h,t, size[0], size[1]);
    else if (type == "diamond") diamond_hole_pattern(l,h,t, size[0], size[1], size[2]);

}

// Module to create a hexagonal pattern
module hex_hole_pattern(l, h, t, hex_r, hex_spacing) {
    dy=2*(hex_r+hex_spacing)*(1+sqrt(3)/2);
    dx=2*(hex_r+hex_spacing);
    length = floor(l/dx)*dx;
    height = floor(h/dy)*dy;
    difference () {
        cube([length, height, t],center=true);
        difference(){
            cube([length, height, t],center=true);
            for (x =[-length/2 : dx : length/2]) {
                for (y =[-height/2 : dy : height/2]) {
                    if (abs(x) < l/2 - hex_r*sqrt(3)/2 && abs(y) < h/2 - hex_r*sqrt(3)/2) {
                        translate([x, y, 0]) hex_hole(hex_r, t+epsilon);
                    }
                    if (abs(x+dx/2) < l/2 - hex_r*sqrt(3)/2 && abs(y+dy/2) < h/2 - hex_r*sqrt(3)/2) {
                        translate([x+dx/2, y+dy/2, 0]) hex_hole(hex_r, t+epsilon);
                    }
                }
            }

        }
    }
}

// Module to create a circle pattern
module circle_hole_pattern(l, h, t, radius, spacing) {
    dx = 4*radius + spacing;
    dy = 4*radius + spacing;
    length = floor(l/dx)*dx;
    height = floor(h/dy)*dy;
    for (x =[-length/2 : dx : length/2]) {
        for (y =[-height/2 : dy : height/2]) {
            if (abs(x) < l/2 - radius && abs(y) < h/2 -radius) {
                translate([x, y, 0])
                    circle_hole(radius, t+epsilon);
            }
            if (abs(x+dx/2) < l/2 - radius && abs(y+dy/2) < h/2 -radius) {
                translate([x+dx/2, y+dy/2, 0])
                    circle_hole(radius, t+epsilon);
            }
            
        }
    }
}

// Module to create a diamond pattern
module diamond_hole_pattern(l, h, t, dw, dh, spacing) {
    echo(dw, dh, spacing);
    dx = 2*dw + spacing;
    dy = 2*dh + spacing;
    length = floor(l/dx)*dx;
    height = floor(h/dy)*dy;

    for (x =[-length/2 : dx : length/2]) {
        for (y =[-height/2 : dy : height/2]) {
            if (abs(x) < l/2 - dw && abs(y) < h/2 -dh) {
                translate([x, y, 0]) diamond_hole(dw, dh, t+epsilon);
            }
            if (abs(x + dx/2) < l/2 - dw && abs(y + dy/2) < h/2 -dh) {
                translate([x+dx/2, y+dy/2, 0]) diamond_hole(dw, dh, t+epsilon);
            }
        }
    }
}



// Module to create a single circle hole
module circle_hole(radius, t) rotate([0, 0, 90]) cylinder(r = radius, h = t, center = true);

// Module to create a single hexagonal hole
module hex_hole(hex_r, t) rotate([0, 0, 90]) cylinder(r = hex_r, h = t, $fn = 6, center = true);

// Module to create a single diamond hole
module diamond_hole(dw, dh, t) rotate([0, 0, 90]) scale([dh, dw, 1]) cylinder(r = 1,  $fn = 4, h = t, center = true);

// Call the function
rounded_box_with_holes(length, width, height, radius, thickness, hole_type, hole_size);
