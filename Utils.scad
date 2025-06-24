// Utils.scad: Dumb little utility functions
//
// Copyright (C) 2025, Edward B. Horch
//
// This program is free software: you can redistribute it and/or modify
// it under the terms of the GNU General Public License as published by
// the Free Software Foundation, either version 3 of the License, or
// (at your option) any later version.
//
//  This program is distributed in the hope that it will be useful,
//  but WITHOUT ANY WARRANTY; without even the implied warranty of
//  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
//  GNU General Public License for more details.
//
//  You should have received a copy of the GNU General Public License
//  along with this program.  If not, see <https://www.gnu.org/licenses/>.

// Shorthand
module tx(x, m=1) translate([x*m,0,0]) children();
module ty(y, m=1) translate([0,y*m,0]) children();
module tz(z, m=1) translate([0,0,z*m]) children();

module hsv(h=0, s=1, v=1, a=1) {
    color(hsv2rgb(h=h, s=s, v=v), alpha=a) children();
}

module dhsv(h=15, s=1, v=1, a=1) {
    dcolor(hsv2rgb(h=h, s=s, v=v), alpha=a) children();
}

// Function to convert HSV color input to RGB output, from Reddit user
// u/NikoKun, who had ChatGPT convert a Python function to OpenSCAD
function hsv2rgb(h=15, s=1, v=1) =
    let( h = h / 360,
         i = floor(h * 6),
         f = h * 6 - i,
         p = v * (1 - s),
         q = v * (1 - f * s),
         t = v * (1 - (1 - f) * s)
       ) i % 6 == 0 ? [v, t, p] :
         i == 1 ? [q, v, p] :
         i == 2 ? [p, v, t] :
         i == 3 ? [p, q, v] :
         i == 4 ? [t, p, v] :
         [v, p, q];

// Just like color(), except if ONE_COLOR is set, in which case
// specified color is ignored, and the default color is used.
module dcolor(c="green", alpha=1) {
  if (ONE_COLOR)
    children();
  else
    color(c, alpha=alpha) children();
}

// Take something defined in the first quadrant, and mirror
// it in the other three.
module quadrant() {
    children();
    mirror([1,0,0])
      color("red")
      children();
    mirror([0,1,0]) {
        color("blue")
        children();
        mirror([1,0,0])
          color("yellow")
          children();
    }
}

// Show a grid on the X-Y plane that is not rendered
module grid( s=100, r=5, b=20, c="skyblue") {
  for (i = [-s : r : s]) {
    w = (i % b == 0) ? .2 : .1;
    ty(i) tz(-w/2)
      color(c, alpha=.5)
      %cube([s*2,w,w], center=true);
    tx(i) tz(-w/2)
      color(c, alpha=.5)
      %cube([w,s*2,w], center=true);
  }
}
