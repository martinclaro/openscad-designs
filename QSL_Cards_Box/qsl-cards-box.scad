$fn = $preview ? 32 : 300;

/* [ Parameters ] */

// Callsign
callsign = "LU2EQD";
// Subtile
subtitle = "QSL CARDS";
// Text Line Separation
text_line_separation = 20;

// Object kind
object_kind = "box"; // [ box, top ]

// Gap between QSL card borders and box internal wall
qsl_to_box_gap = 5;

// Box walls thickness
box_wall_width = 2;

// Top internal width
box_top_internal_h = 20;

// Box top to base Gap
box_top_to_base_gap = 1;

// Inches to mm factor
inches_to_mm_factor = 25.4;

qsl_card_x = 5.5 * inches_to_mm_factor;
qsl_card_y = 3.5 * inches_to_mm_factor;

box_base_w = qsl_card_x + (2 * qsl_to_box_gap) + (2 * box_wall_width);
box_base_d = qsl_card_y + (2 * qsl_to_box_gap) + (2 * box_wall_width);
box_base_h = qsl_card_y + (1 * qsl_to_box_gap) + (1 * box_wall_width);

box_top_w = box_base_w + (2 * box_top_to_base_gap) + (2 * box_wall_width);
box_top_d = box_base_d + (2 * box_top_to_base_gap) + (2 * box_wall_width);
box_top_h = box_top_internal_h + box_wall_width + box_wall_width;

module
box_base()
{
    // Box internal size
    box_internal_w = qsl_card_x + (2 * qsl_to_box_gap);
    box_internal_d = qsl_card_y + (2 * qsl_to_box_gap);
    box_internal_h = box_base_h;

    difference()
    {
        difference()
        {
            cube([ box_base_w, box_base_d, box_base_h ], center = false);

            translate(v = [ box_wall_width, box_wall_width, box_wall_width ])
                cube([ box_internal_w, box_internal_d, box_internal_h ],
                     center = false);
        };

        make_text(t = callsign,
                  t2 = subtitle,
                  v =
                      [
                          box_base_w / 2,
                          box_wall_width / 2,
                          (box_base_h - box_top_internal_h) / 2
                      ],
                  r = [ 90, 0, 0 ]);
    };
};

module
box_top()
{
    difference()
    {
        cube([ box_top_w, box_top_d, box_top_h ], center = false);

        translate(v = [ box_wall_width, box_wall_width, box_wall_width ]) cube(
            [
                box_base_w + (2 * box_top_to_base_gap),
                box_base_d + (2 * box_top_to_base_gap),
                box_base_h +
                box_top_to_base_gap
            ],
            center = false);
    };
};

module
make_text(t, t2 = "", v = [ 0, 0, 0 ], r = [ 0, 0, 0 ])
{
    font = "Ubuntu:style=bold";
    font_size = 20;
    font_spacing = 0.85;
    separation = (t2 != "") ? text_line_separation : 0;
    d = box_wall_width;
    z = 0;

    color("darkgray") translate(v = v) rotate(a = r) union()
    {
        translate(v = [ 0, 0, z ]) linear_extrude(height = d)
            text(t,
                 size = font_size,
                 font = font,
                 halign = "center",
                 valign = "center",
                 spacing = font_spacing);

        if (t2 != "") {
            translate(v = [ 0, -separation, z ]) linear_extrude(height = d)
                text(t2,
                     size = font_size * 0.5,
                     font = font,
                     halign = "center",
                     valign = "center",
                     spacing = font_spacing);
        };
    };
};

module
main()
{
    if (object_kind == "box") {
        box_base();
    }

    if (object_kind == "top")
        box_top();
}

main();