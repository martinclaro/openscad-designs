$fn = $preview ? 32 : 100;

filament_type = "PLA"; // [PLA, PLA ART, PLA MAX, HYPER PLA, ABS, ASA, PETG]
filament_brand = "Prusa"; // [CHE3D, Creality, GST3D, PaL, Prusa]
filament_color = "Verde Ninja";

chip_width = 100;
chip_height = 50;
chip_depth = 3;

module rounded_rect(l, w, h, r, center = false) {
  color("silver")
    linear_extrude(height=h)
      offset(r=r, $fn=60)
        square([l - (2 * r), w - (2 * r)], center=center);
}
;

module make_text(t, b, c) {
  font = "Ubuntu:style=bold";
  font_size = 10;
  font_spacing = 0.85;
  separation = 12;
  d = chip_depth;
  z = chip_depth / 2;

  color("black") {
    translate(v=[0, separation * 2, z])
      linear_extrude(height=d)
        text(t, size=font_size, font=font, halign="left", valign="baseline", spacing=font_spacing);

    translate(v=[0, separation, z])
      linear_extrude(height=d)
        text(b, size=font_size, font=font, halign="left", valign="baseline", spacing=font_spacing);

    translate(v=[0, 0, z])
      linear_extrude(height=d)
        text(c, size=font_size, font=font, halign="left", valign="baseline", spacing=font_spacing);
  }
  ;
}
;

module hole() {
  hole_radius = 5;

  color("black")
    translate(v=[chip_width - 3 * hole_radius, chip_height - 3 * hole_radius, -chip_depth / 2])
      cylinder(h=chip_depth * 2, r=hole_radius, center=false);
}
;

module main() {
  difference() {
    difference() {
      rounded_rect(l=chip_width, w=chip_height, h=chip_depth, r=5, center=false);
      make_text(t=filament_type, b=filament_brand, c=filament_color);
    }
    ;
    hole();
  }
  ;
}
;

main();
