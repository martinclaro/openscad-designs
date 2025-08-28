/*
 * Argentina License Plates Generator.
 * @author Martín Claro <mc@0xff.ar>
 */
$fn = $preview ? 32 : 100;

use <fonts/Ubuntu-B.ttf>;
use <fonts/FE.TTF>;

/* [Text] */

// License Text
license = "AA 000 AA";

// Header
header = "REPÚBLICA ARGENTINA";

/* [Plate dimensions] */

// Plate Width
plate_w = 400; // [::non-negative integer]

// Plate Height
plate_h = 130; // [::non-negative integer]

// Header Height
header_h = 35; // [::non-negative integer]

// Plate Contour Width
plate_contour_w = 6;

/* [License text parameters] */

// Font Name
license_font_face = "FE\\-Font"; // [FE\-Font, Ubuntu, Arial]
// Font Style
license_font_style = "Normal"; // [Normal, Regular, Bold, Italic, Bold Italic]
// Font
license_font_name = str(license_font_face, ":style=", license_font_style);
// Font Size
license_font_size = 50; // [1:1:72]

// License Text Spacing
license_spacing = 0.95; // [0.5:0.05:2]

/* [Header text parameters] */

// Font Name
header_font_face = "Ubuntu"; // [FE\-Font, Ubuntu, Arial]
// Font Style
header_font_style = "Bold"; // [Normal, Regular, Bold, Italic, Bold Italic]
// Font
header_font_name = str(header_font_face, ":style=", header_font_style);
// Font Size
header_font_size = 12; // [1:1:72]

// Spacing
header_spacing = 1; // [0.5:0.05:2]

/* [Layer Heights] */

layer_0 = 2; // [1:0.5:10]
layer_1 = 3; // [1:0.5:10]
layer_2 = 4; // [1:0.5:10]

/* [Options] */

// Add Keychain Loop
add_keychain = false; // [true, false]
// Add bolt holes
add_holes = true; // [true, false]


module rounded_rect(l, w, r, center = false) {
  offset(r=r, $fn=60)
    square([l - (2 * r), w - (2 * r)], center=center);
}

module plate() {
  color("white")
    linear_extrude(layer_0)
      rounded_rect(l=plate_w, w=plate_h, r=5, center=true);
}
;

module draw_plate_contour() {
  color("black")
    linear_extrude(layer_2)
      difference() {
        rounded_rect(l=plate_w, w=plate_h, r=5, center=true);
        rounded_rect(l=plate_w - (2 * plate_contour_w), w=plate_h - (2 * plate_contour_w), r=4, center=true);
      }
  ;
}
;

module header() {
  color("blue")
    translate(v=[0, (plate_h / 2) - (header_h / 2), 0])
      linear_extrude(layer_1)
        rounded_rect(l=plate_w, w=header_h, r=5, center=true);
}
;

module draw_header_text() {
  color("white")
    translate(v=[0, (plate_h / 2) - (header_h / 2) - (plate_contour_w), 0])
      linear_extrude(layer_2)
        text(header, size=header_font_size, font=header_font_name, halign="center", valign="center", spacing=header_spacing);
}
;

module draw_license_text() {
  color("black")
    translate(v=[0, -(header_h / 2) + (plate_contour_w / 2), 0])
      linear_extrude(layer_2)
        text(license, size=license_font_size, font=license_font_name, halign="center", valign="center", spacing=license_spacing);
}
;

module draw_holes() {
  displacement_w = plate_w * 0.5 / 2;
  y = (plate_h / 2) - (header_h / 2) + (plate_contour_w);

  translate(v=[displacement_w, y, -layer_2 / 2])
    linear_extrude(layer_2 * 2)
      rounded_rect(l=22, w=6, r=2, center=true);

  translate(v=[-displacement_w, y, -layer_2 / 2])
    linear_extrude(layer_2 * 2)
      rounded_rect(l=22, w=6, r=2, center=true);
}
;

module draw_chain_link() {
  bore_size = plate_h/2;
  chain_link_length = bore_size * 2;

  color("black")
    translate([(2 * bore_size - chain_link_length) - plate_w / 2, 0, 0]) difference() {
        hull() {
          translate([-bore_size, 0, 0])
            cylinder(h=layer_2, r=bore_size, center=false);

          translate([-bore_size, -bore_size, 0])
            cube([chain_link_length-bore_size+plate_contour_w, bore_size * 2, layer_2], false);
        }
        translate([-bore_size, 0, 0])
          cylinder(h=layer_2 * 2, r=bore_size / 2, center=true);
      }
}

module license_plate() {
  plate();
  header();
  draw_header_text();
  draw_license_text();
  draw_plate_contour();
}
;

module main() {
  if (add_holes) {
    difference() {
      license_plate();
      draw_holes();
    }
    ;
  } else {
    if (add_keychain) {
      draw_chain_link();
    }

    license_plate();
  }
  ;
}
;

main();
