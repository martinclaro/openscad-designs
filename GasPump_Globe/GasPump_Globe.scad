use <hull.scad>

$fn = 100;

// Outer Globe Diameter - Upper Globe (mm)
globe_outer_diameter = 100; // [::non-negative integer]

// Outer Globe Depth - Upper Globe (mm)
globe_outer_depth = 50; // [::non-negative integer]

// Base Outer Diameter (mm)
base_outer_diameter = 35;

// Neck Outer Diameter (mm)
neck_outer_diameter = 35;

// Wall Thicknesz (mm)
skin_thickness = 2; // [::non-negative integer]

globe_inner_diameter = (globe_outer_diameter - (2 * skin_thickness));
globe_inner_depth = (globe_outer_depth - (2 * skin_thickness));

base_outer_radius = (base_outer_diameter / 2);
base_inner_radius = ((base_outer_diameter / 2) - skin_thickness);

neck_outer_radius = (neck_outer_diameter / 2);
neck_inner_radius = ((neck_outer_diameter / 2) - skin_thickness);

base_outer_ring = ((base_outer_diameter / 2) + (2 * skin_thickness));

module
shape1(h, d)
{
    resize(newsize = [ h, h, d ]) sphere(d = h);
};

module
cyl1(h, r1, r2, angle = 90)
{
    rotate(a = [ angle, 0, 0 ])
        cylinder(h = h, r1 = r1, r2 = r2, center = false);
};

difference()
{
    union()
    {
        // Globe
        difference()
        {
            // Outer Globe
            shape1(h = globe_outer_diameter, d = globe_outer_depth);
            // Inner Globe
            translate([ 0, 0, skin_thickness / 2 ])
                shape1(h = globe_inner_diameter, d = globe_inner_depth);
        };

        // Base Cylinder
        translate([ 0, 54, 0 ]) difference()
        {
            cyl1(
                h = 25, r1 = base_outer_radius, r2 = neck_outer_radius, a = 90);
            cyl1(
                h = 25, r1 = base_inner_radius, r2 = neck_inner_radius, a = 90);
        };

        // Base Ring Cylinder
        translate([ 0, 54, 0 ])
            cyl1(h = 4, r1 = base_outer_ring, r2 = base_outer_ring, a = 90);
    };

    union()
    {
        // Inner Globe
        translate([ 0, 0, skin_thickness / 2 ])
            shape1(h = globe_inner_diameter, d = globe_inner_depth);
        // Inner Base Cylinder
        translate([ 0, 130, 0 ]) cyl1(
            h = 150, r1 = base_inner_radius, r2 = base_inner_radius, a = 90);
    };
};
