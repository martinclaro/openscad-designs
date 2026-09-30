// ==========================================
// PARAMETRIC SPLIT FILAMENT SPOOL CENTERING
// ==========================================
// This model generates a two-part, split-halves centering adapter
// to fit a spool snugly onto a smaller 3D printer spool holder shaft.
// It is split both horizontally (two mirroring halves) and vertically
// (interlocking halves) so it can print without supports and snap together.

/* [Spool Dimensions] */
// Inner diameter of the spool hole (mm)
spool_inner_di = 52.0;
// Width of the spool core where it touches the adapter (mm)
spool_width = 60.0;

/* [Shaft Dimensions] */
// Outer diameter of your printer's spool holder shaft (mm)
shaft_outer_di = 30.0;

/* [Adapter Features] */
// Diameter of the outer retention lip (mm)
lip_di = 62.0;
// Thickness of the outer retention lip (mm)
lip_thickness = 3.0;
// Tolerance clearance between the two interlocking halves (mm)
clearance = 0.2;

/* [Printer Settings] */
// Smoothness of the cylinders (higher = smoother)
$fn = $preview ? 64 :300;

// --- Calculated Hidden Parameters ---
// Render only one half. Print twice to get the full adapter.
half_width = spool_width / 2;
pin_width = (spool_inner_di - shaft_outer_di) / 4;
pin_height = 8;

module half_adapter() {
    difference() {
        union() {
            // Main cone/cylinder body
            cylinder(h = half_width, d = spool_inner_di);

            // Outer lip
            cylinder(h = lip_thickness, d = lip_di);

            // Alignment Pins (Male side)
            translate([0, (spool_inner_di + shaft_outer_di)/4, half_width])
                cylinder(h = pin_height, d = pin_width - clearance);
            translate([0, -(spool_inner_di + shaft_outer_di)/4, half_width])
                cylinder(h = pin_height, d = pin_width - clearance);
        }

        // Inner shaft cutout
        translate([0, 0, -1])
            cylinder(h = half_width + pin_height + 2, d = shaft_outer_di);

        // Alignment Holes (Female side, rotated 90 degrees)
        rotate([0, 0, 90]) {
            translate([0, (spool_inner_di + shaft_outer_di)/4, half_width - pin_height])
                cylinder(h = pin_height + 1, d = pin_width + clearance);
            translate([0, -(spool_inner_di + shaft_outer_di)/4, half_width - pin_height])
                cylinder(h = pin_height + 1, d = pin_width + clearance);
        }

        // Vertical Split (Removes the left X half to make it a split-ring style if needed)
        // Comment out this block if you only want a horizontal split!
        translate([-spool_inner_di, -spool_inner_di, -1])
            cube([spool_inner_di, spool_inner_di * 2, half_width + pin_height + 2]);
    }
}

// Render a single printable component
half_adapter();
