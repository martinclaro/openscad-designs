/* Parametric power-supply enclosure, dimensions in mm.
   Source drawing: PSU body 215 x 115 x 30, 4 M4 mounting holes
   on 150 x 133 centres, 32.5 mm from the left datum.
   The drawing does NOT dimension the switch, banana sockets or fan
   precisely: edit their parameters to match your purchased hardware.

   part = "assembly" / "base" / "lid" / "din_rail"
   Assembly: base + lid + reference PSU (if show_psu=true).
   Print base and lid separately; DIN rail may be printed or replaced
   with a metal 35 mm top-hat DIN rail.

   Mains cable entry: use mains_cable_hole_d for hole diameter,
   mains_cable_hole_y for lateral position on left (-X) end wall,
   and mains_cable_hole_z for height above the bottom. Use a rated
   cable gland/strain relief, not an unsupported bare cable.

   Bottom cooling vents: set bottom_vent_sides to front/rear/both/none;
   tune count, pitch, length, width, x, edge_offset and corner_r.
*/
$fn = $preview ? 48 : 300;

part = "assembly"; // [ "assembly", "base", "lid", "din_rail" ]

show_psu = true; // [ true, false ]

/* [PSU blueprint] */
psu_length = 215;
psu_width = 115;
psu_height = 30;

psu_hole_x_spacing = 150;
psu_hole_y_spacing = 50;
psu_first_hole_x = 32.5;
psu_first_hole_y = 32.5;
psu_hole_d = 4.5; // M4 L=5

psu_x = -psu_length / 2;
psu_y = -psu_width / 2;

/* [PSU fan] */
psu_fan_x = psu_length - 47.45;
psu_fan_y = psu_width / 2 - 36.7;
psu_fan_d = 52;

/* [Enclosure] */
wall = 3;
floor_thickness = 4;
clearance_x = 15;     // space each end of PSU body
clearance_y = 24;     // space each side of PSU body (incl. tabs)
internal_height = 74; // above enclosure floor
lid_thickness = 4;
lid_lip_depth = 7;
lid_lip_thickness = 2;
corner_r = 5;
psu_standoff_height = 7;
psu_standoff_d = 11;
psu_z = floor_thickness + psu_standoff_height;

/* [Input Switch] */

// Dimmensions from psu_switch_ac2.webp

switch_cutout_w = 22;
switch_cutout_h = 30;
switch_x = psu_x + 16;
switch_z = 54;

/* [Input Switches] */

// Dimmensions from psu_switch_dc1.webp

output_switch_enabled = true;
output_switch_cutout_d = 20.2;
output_switch_cutout_box_w = 0.9;
output_switch_cutout_box_h = 2.2;
output_switch_z = 54;

/* [Banana Plug Holes] */
banana_hole_d = 5.5; // panel mount female banana sockets
banana_pair_pitch = 18;
banana_group_pitch = 45;
banana_start_x = -60;
banana_z = 20 + banana_hole_d / 2;

/* [Lid screws and airflow] */
lid_screw_d = 3.2;
lid_screw_pilot_d = 2.7;
lid_post_d = 10;

fan_opening_d = 60;
fan_grille_hole_d = 6;
fan_grille_pitch = 9;          // radial spacing between concentric rings (mm)
fan_grille_center_hole = true; // central ventilation hole
fan_grille_angle_offset = 0;   // rotate circular pattern (degrees)

/* [Bottom Cooling Vents] */
// Vent slots are cut through the FLOOR, parallel to the two long (X) sides.
// "rear" = +Y (opposite switch/banana panel); "front" = -Y.
// "both" places rows along both long edges; "none" disables vents.
bottom_vent_sides = "both"; // ["none", "front", "rear", "both"]
bottom_vent_count = 16;     // slots per selected side
bottom_vent_length = 6;     // slot dimension along X (mm)
bottom_vent_width = 20;     // slot dimension along Y (mm)
bottom_vent_pitch = 10;     // slot centre spacing along X (mm)
bottom_vent_x = 0;          // row centre offset along X (mm)
bottom_vent_edge_offset =
    15;                   // slot centre distance inward from outer +/-Y edge
bottom_vent_corner_r = 3; // rounded slot corners (mm); 0 = square

// Ensure slot ends remain inside the floor and clear the PSU mounting bosses.
// For each side, adjust edge_offset to move its row toward/away from the wall.
// Front slots may be under the connector panel; check internal wiring
// clearance.

/* [DIN Rail] */

// 35 mm DIN rail underneath lid, near the fan inlet

rail_length = 70;
rail_width = 35;
rail_height = 7.5;
rail_wall = 2;

/* [DIN Rail Location] */

// RELOCATION: rail_x and rail_y move rail AND lid holes together.
// rail_rotation rotates BOTH rail and lid hole pattern in XY plane:
// 0 = length along X; 90 = length along Y.

rail_x = psu_x / 2; // left side of lid
rail_y = 0;         // center aligned

// rail_rotation rotates BOTH rail and lid hole pattern in XY plane:
// 0 = length along X; 90 = length along Y.
rail_rotation = 90;

// rail_mount_d changes both screw-hole diameters.
rail_mount_d = 3.3;

// rail_mount_spacing changes both screw-hole centre spacing.
rail_mount_spacing = 50;

// rail_support_drop changes distance below the lid.
rail_support_drop = 10;

/* [Screws positions] */
outer_l = psu_length + 2 * clearance_x + 2 * wall;
outer_w = psu_width + 2 * clearance_y + 2 * wall;
outer_h = floor_thickness + internal_height + lid_thickness;

/* [Mains Cable Entry - Left End Wall] */
// Circular through-hole in the short wall at X = -outer_l/2.
// Diameter should match the selected cable gland or strain-relief fitting.
mains_cable_hole_d = 12; // [4:0.5:30] mm
mains_cable_hole_y =
    psu_y +
    (mains_cable_hole_d / 2); // offset across the left end wall; 0 = centered
mains_cable_hole_z =
    psu_z +
    (mains_cable_hole_d / 2); // height of hole center above enclosure bottom
mains_cable_hole_enabled = true;

module
rounded_rect(l, w, r)
{
    hull() for (x = [ -l / 2 + r, l / 2 - r ], y = [ -w / 2 + r, w / 2 - r ])
        translate([ x, y ]) circle(r = r);
};

module
rounded_prism(l, w, h, r)
{
    linear_extrude(height = h) rounded_rect(l, w, r);
};

module
screw_positions()
{
    for (x = [ -outer_l / 2 + wall + 8, outer_l / 2 - wall - 8 ],
        y = [ -outer_w / 2 + wall + 8, outer_w / 2 - wall - 8 ])
        translate([ x, y, 0 ]) children();
};

module
psu_holes()
{
    color("red") for (x =
                          [
                              psu_x + psu_first_hole_x,
                              psu_x + psu_first_hole_x +
                              psu_hole_x_spacing
                          ],
                      y = [
                          psu_y + psu_first_hole_y,
                          psu_y + psu_first_hole_y +
                          psu_hole_y_spacing
                      ]) translate([ x, y, 0 ]) children();
};

module
rail_placement()
{
    translate([ rail_x, rail_y, 0 ]) rotate([ 0, 0, rail_rotation ]) children();
};

module
rail_hole_positions()
{
    rail_placement() for (x = [
                              -rail_mount_spacing / 2,
                              rail_mount_spacing / 2
                          ]) translate([ x, 0, 0 ]) children();
};

module
banana_positions()
{
    for (g = [0:3], p = [0:1])
        translate([
            banana_start_x + g * banana_group_pitch + p * banana_pair_pitch,
            0,
            banana_z
        ]) children();
};

module
output_switch_positions()
{
    for (g = [0:3])
        translate([
            banana_start_x + g * banana_group_pitch + banana_pair_pitch / 2,
            0,
            output_switch_z
        ]) children();
};

module
output_switch_cutour(){
    union(){ cylinder(d = output_switch_cutout_d, h = wall + 2);

translate([
    (output_switch_cutout_d / 2 - output_switch_cutout_box_w / 2),
    0,
    wall / 2
])
    cube(
        [
            output_switch_cutout_box_w * 2,
            output_switch_cutout_box_h,
            wall + 2
        ],
        center = true);
}
}
;

// Cutouts in XY plane, extending completely through the enclosure floor.
module
bottom_cooling_vents()
{
    for (side = [ -1, 1 ])
        if (bottom_vent_sides == "both" ||
            (bottom_vent_sides == "front" && side == -1) ||
            (bottom_vent_sides == "rear" && side == 1))
            for (i = [0:bottom_vent_count - 1])
                translate([
                    bottom_vent_x +
                        (i - (bottom_vent_count - 1) / 2) * bottom_vent_pitch,
                    side * (outer_w / 2 - bottom_vent_edge_offset),
                    -0.5
                ]) linear_extrude(height =
                                      floor_thickness +
                                      1) offset(r = min(bottom_vent_corner_r,
                                                        bottom_vent_length / 2,
                                                        bottom_vent_width / 2))
                    square(
                        [
                            max(0.01,
                                bottom_vent_length - 2 * bottom_vent_corner_r),
                            max(0.01,
                                bottom_vent_width - 2 * bottom_vent_corner_r)
                        ],
                        center = true);
}

module
base()
{
    difference()
    {
        union()
        {
            difference()
            {
                rounded_prism(
                    outer_l, outer_w, outer_h - lid_thickness, corner_r);

                translate([ 0, 0, floor_thickness ])
                    rounded_prism(outer_l - 2 * wall,
                                  outer_w - 2 * wall,
                                  outer_h,
                                  max(0.1, corner_r - wall));
            };

            // Four raised mounting bosses at blueprint hole centres
            psu_holes() translate([ 0, 0, floor_thickness ])
                cylinder(d = psu_standoff_d, h = psu_standoff_height);

            // Lid screw pillars
            screw_positions() translate([ 0, 0, floor_thickness ])
                cylinder(d = lid_post_d, h = internal_height);
        };

        // PSU mounting screws through bosses and floor
        psu_holes() translate([ 0, 0, -0.5 ]) cylinder(
            d = psu_hole_d, h = floor_thickness + psu_standoff_height + 1);

        // Lid pilot holes
        screw_positions() translate([ 0, 0, outer_h - lid_thickness - 15 ])
            cylinder(d = lid_screw_pilot_d, h = 17);

        // Switch and 8 female banana sockets, front wall (-Y)
        translate([ switch_x, -outer_w / 2 + wall / 2, switch_z ])
            cube([ switch_cutout_w, wall + 2, switch_cutout_h ], center = true);

        banana_positions() translate([ 0, -outer_w / 2 - 0.5, 0 ])
            rotate([ -90, 0, 0 ]) cylinder(d = banana_hole_d, h = wall + 2);

        if (output_switch_enabled) {
            output_switch_positions() translate([ 0, -outer_w / 2 - 0.5, 0 ])
                rotate([ -90, 0, 0 ]) output_switch_cutour();
        };

        // Circular mains cable entry through LEFT (-X) short end wall.
        // Cylinder is oriented along X, and extends beyond both wall faces.
        if (mains_cable_hole_enabled)
            translate(
                [ -outer_l / 2 - 1, mains_cable_hole_y, mains_cable_hole_z ])
                rotate([ 0, 90, 0 ])
                    cylinder(d = mains_cable_hole_d, h = wall + 2);

        // Parametric floor ventilation along either/both long sides.
        bottom_cooling_vents();
    };
};

module
fan_vent()
{
    // Concentric circular rings, centred precisely on the PSU fan.
    // Hole count per ring is chosen for approximately equal arc spacing.
    // All holes remain inside fan_opening_d.
    max_radius = fan_opening_d / 2 - fan_grille_hole_d / 2;
    ring_count = floor(max_radius / fan_grille_pitch);
    translate([ psu_x + psu_fan_x, psu_fan_y, -0.5 ])
    {
        if (fan_grille_center_hole)
            cylinder(d = fan_grille_hole_d, h = lid_thickness + 1);
        for (ring = [1:ring_count]) {
            radius = ring * fan_grille_pitch;
            hole_count = max(1, floor(2 * PI * radius / fan_grille_pitch));
            for (i = [0:hole_count - 1])
                rotate([ 0, 0, fan_grille_angle_offset + i * 360 / hole_count ])
                    translate([ radius, 0, 0 ])
                        cylinder(d = fan_grille_hole_d, h = lid_thickness + 1);
        }
    }
}

module
lid()
{
    difference()
    {
        union()
        {
            rounded_prism(outer_l, outer_w, lid_thickness, corner_r);
            // Short centering skirt inside the enclosure
            translate([ 0, 0, -lid_lip_depth ]) difference()
            {
                rounded_prism(outer_l - 2 * wall - 0.6,
                              outer_w - 2 * wall - 0.6,
                              lid_lip_depth,
                              max(0.1, corner_r - wall));
                translate([ 0, 0, -0.1 ]) rounded_prism(
                    outer_l - 2 * wall - 2 * lid_lip_thickness - 0.6,
                    outer_w - 2 * wall - 2 * lid_lip_thickness - 0.6,
                    lid_lip_depth + 0.2,
                    1);
            };
            // DIN rail standoffs on lid underside, rail sits below vent
            rail_hole_positions() translate([ 0, 0, -rail_support_drop ])
                cylinder(d = 9, h = rail_support_drop);
        };

        fan_vent();

        screw_positions() translate([ 0, 0, -lid_lip_depth - 0.5 ])
            cylinder(d = lid_screw_d, h = lid_lip_depth + lid_thickness + 1);

        // Pilot holes for rail fixing screws
        rail_hole_positions() translate([ 0, 0, -rail_support_drop - 0.5 ])
            cylinder(d = rail_mount_d, h = rail_support_drop + 1);
    };
};
// Simplified printable 35 mm top-hat rail with mounting holes.
// Metal DIN rail is recommended for mechanical strength.
module
din_rail()
{
    // Cross section in YZ, extruded along X. The central web is at
    // Z=0..rail_wall.
    difference()
    {
        rotate([ 90, 0, 90 ])
            linear_extrude(height = rail_length, center = true)
                polygon(points = [
                    [ -rail_width / 2, rail_height ],
                    [ -rail_width / 2, rail_height - rail_wall ],
                    [ -rail_width / 2 + 5, rail_height - rail_wall ],
                    [ -rail_width / 2 + 8, 0 ],
                    [ rail_width / 2 - 8, 0 ],
                    [ rail_width / 2 - 5, rail_height - rail_wall ],
                    [ rail_width / 2, rail_height - rail_wall ],
                    [ rail_width / 2, rail_height ],
                    [ rail_width / 2 - 7, rail_height ],
                    [ rail_width / 2 - 10, rail_wall ],
                    [ -rail_width / 2 + 10, rail_wall ],
                    [ -rail_width / 2 + 7, rail_height ]
                ]);
        // Vertical through-holes in the rail's central mounting web.
        for (x = [ -rail_mount_spacing / 2, rail_mount_spacing / 2 ])
            translate([ x, 0, -0.5 ])
                cylinder(d = rail_mount_d, h = rail_height + 1);
    }
}
module
psu_preview()
{
    color([ 0.68, 0.70, 0.73, 0.8 ]) translate([ psu_x, 0, psu_z ])
        translate([ psu_length / 2, 0, psu_height / 2 ])
            cube([ psu_length, psu_width, psu_height ], center = true);
    color([ 0.4, 0.4, 0.4, 0.5 ])
        translate([ psu_x + psu_fan_x, psu_fan_y, psu_z + psu_height ])
            cylinder(d = psu_fan_d, h = 0.5);
};

if (part == "base")
    base();
else if (part == "lid")
    lid();
else if (part == "din_rail")
    din_rail();
else {
    color("lightgray") base();

    color("gainsboro") translate([ 0, 0, outer_h - lid_thickness ]) lid();

    color("slategray")
        translate([ 0, 0, outer_h - lid_thickness - rail_support_drop ])
            rail_placement() din_rail();
};

if (show_psu)
    psu_preview();
