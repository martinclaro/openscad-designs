use <hull.scad>

$fn = 100;

// Window Handle Width (mm)
handle_hand_width = 35; // [::non-negative integer]

// Window Handle Height (mm)
handle_hand_height = 75; // [::non-negative integer]

// Window Handle Depth (mm)
handle_hand_depth = 50; // [::non-negative integer]

// Window Handle Base Width (mm)
handle_base_width = 100; // [::non-negative integer]

// Wall Thickness (mm)
walls_thickness = 5; // [::non-negative integer]

// Edges Roundness (mm)
edges_roundness = 5; // [::non-negative integer]

globe_inner_diameter = (globe_outer_diameter - (2 * skin_thickness));
globe_inner_depth = (globe_outer_depth - (2 * skin_thickness));

base_outer_radius = (base_outer_diameter / 2);
base_inner_radius = ((base_outer_diameter / 2) - skin_thickness);

neck_outer_radius = (neck_outer_diameter / 2);
neck_inner_radius = ((neck_outer_diameter / 2) - skin_thickness);

base_outer_ring = ((base_outer_diameter / 2) + (2 * skin_thickness));

module
roundedcube(x, y, z, r)
{
    translate([ 0, 0, z / 2 ]) intersection()
    {

        color("SteelBlue") hull()
        {
            translate([ r, r, 0 ]) cylinder(r = r, h = z, center = true);
            translate([ x - r, r, 0 ]) cylinder(r = r, h = z, center = true);

            translate([ r, y - r, 0 ]) cylinder(r = r, h = z, center = true);
            translate([ x - r, y - r, 0 ])
                cylinder(r = r, h = z, center = true);
        };

        color("Lime") translate([ 0, y / 2, -z / 2 ]) rotate(a = [ 90, 0, 0 ])
            hull()
        {
            translate([ r, r, 0 ]) cylinder(r = r, h = y, center = true);
            translate([ x - r, r, 0 ]) cylinder(r = r, h = y, center = true);

            translate([ r, z - r, 0 ]) cylinder(r = r, h = y, center = true);
            translate([ x - r, z - r, 0 ])
                cylinder(r = r, h = y, center = true);
        };

        color("Red") translate([ x / 2, 0, z / 2 ]) rotate(a = [ 0, 90, 0 ])
            hull()
        {
            translate([ r, r, 0 ]) cylinder(r = r, h = x, center = true);
            translate([ z - r, r, 0 ]) cylinder(r = r, h = x, center = true);

            translate([ r, y - r, 0 ]) cylinder(r = r, h = x, center = true);
            translate([ z - r, y - r, 0 ])
                cylinder(r = r, h = x, center = true);
        };
    };
};

module
empty_box(w, h, d, r, t)
{
    difference()
    {
        roundedcube(w, d, h, r);

        roundedcube(w - (t * 2), d - (t * 2), h - (t * 2), r - (t * 2));
    };
};

/**
difference() {
    empty_box(
        handle_hand_width,
        handle_hand_height,
        handle_hand_depth,
        edges_roundness,
        walls_thickness
    );

    translate([-5, -5, -5]) {
        cube(
            size=[
                handle_hand_width+10,
                20,
                handle_hand_height+10
            ],
            center=false
        );
    };
};
**/
empty_box(handle_hand_width,
          handle_hand_height,
          handle_hand_depth,
          edges_roundness,
          walls_thickness);