use <hull.scad>;

$fn = 120;

// Outer Diameter - Upper Ring (mm)
outer_diamerter_upper = 80; // [::non-negative integer]

// Outer Diameter - Lower Ringv
outer_diamerter_lower = 140; // [::non-negative integer]

// Shade Wall Height (mm)
shade_wall_height = 100; // [::non-negative integer]

// Shade Wall Thickness (mm)
shade_wall_thickness = 1; // [::non-negative float]

// Light Ring Type Closed
light_ring_is_closed = false; // [::boolean]

// Light Ring Height (mm)
light_ring_height = 50; // [::non-negative integer]

// Separarion between upper links and wall (mm)
link_ring_radial_separation_upper = 0.5; // [::float]

// Calculated measures.
inner_diameter_lower = outer_diamerter_lower - (2 * shade_wall_thickness);
inner_diameter_upper = outer_diamerter_upper - (2 * shade_wall_thickness);
link_ring_diameter_upper = (inner_diameter_upper - link_ring_radial_separation_upper);
link_ring_diameter_lower = (45.57 - 2); // Standard Socket Adapter for E27 lamp
link_ring_z_upper = 5;
link_ring_z_lower = 51;

module bottom_ring(d, h) {
    cylinder(d=d, h=h);
}

module shade_wall(d1, d2, h, t) {
    difference() {
        cylinder(r1=outer_diamerter_upper/2, r2=outer_diamerter_lower/2, h=h);
        translate([0, 0, -0.5]) {
            cylinder(r1=inner_diameter_upper/2, r2=inner_diameter_lower/2, h=(h+1));
        }
    }
}

module sector(radius, angles, fn=24) {
    r = radius / cos(180 / fn);
    step = -360 / fn;

    points = concat([[0, 0]],
        [for(a = [angles[0] : step : angles[1] - 360])
            [r * cos(a), r * sin(a)]
        ],
        [[r * cos(angles[1]), r * sin(angles[1])]]
    );

    difference() {
        circle(radius, $fn=fn);
        polygon(points);
    }
}

module arc(radius, angles, width=1, fn=24) {
    difference() {
        sector(radius, angles, fn);
        sector(radius - width, angles, fn);
    }
}

module light_ring_arc(d, h, z=50) {
    radius = d / 2;
    opening_angle = 35;
    angles = [0, (360-opening_angle)];
    width = 1;

    translate([0, 0, z]) {
        rotate([0, 0, opening_angle*1.5]) {
                linear_extrude(h) {
                arc(radius, angles, width, 360);
            }
        }
    }
}

module light_ring_closed(d, h, z=50) {
    radius = d / 2;

    translate([0, 0, z]) {
        difference() {
            cylinder(d=d, h=h);
            translate([0, 0, -0.5]) {
                cylinder(d=(d-2), h=(h+1));
            }
        }
    }
}

module puntos_soporte(d, sectors=3, z=0, id=0) {
    radius = d / 2;
    sector_degrees = 360 / sectors;

    for(sector = [1 : sectors]) {
        angle = sector_degrees * sector;
        x_pos = radius * sin(angle);
        y_pos = radius * cos(angle);

        if(id == 0 || sector == id) {
            echo(str("--- Angle:", angle));
            translate([x_pos, y_pos, z]){
                sphere(r=2);
            }
        }
    }
}

// Shade Wall
shade_wall(d1=outer_diamerter_upper, d2=outer_diamerter_lower, h=shade_wall_height);

// Links
multiHull() {
    puntos_soporte(d=link_ring_diameter_lower, z=link_ring_z_lower, id=1);
    puntos_soporte(d=link_ring_diameter_upper, z=link_ring_z_upper, id=1);
}
multiHull() {
    puntos_soporte(d=link_ring_diameter_lower, z=link_ring_z_lower, id=2);
    puntos_soporte(d=link_ring_diameter_upper, z=link_ring_z_upper, id=2);
}
multiHull() {
    puntos_soporte(d=link_ring_diameter_lower, z=link_ring_z_lower, id=3);
    puntos_soporte(d=link_ring_diameter_upper, z=link_ring_z_upper, id=3);
}

// Lamp Socket Adapter Ring
if(light_ring_is_closed) {
    light_ring_closed(d=link_ring_diameter_lower, h=10, z=50);
} else {
    light_ring_arc(d=link_ring_diameter_lower, h=10, z=50);
}
