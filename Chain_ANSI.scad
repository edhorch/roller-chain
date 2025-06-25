// OpenSCAD's editor doesn't show column numbers. This is the 80th column ---> |                        And this is the 132nd ---> |

// Chain_ANSI.scad: Create ANSI-sized roller chains
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

// A roller chain is a connected set of link assemblies, each of which
// has the following components:
// * Two outer plates connected by pins
// * Two inner plates connected by "bushes", which rotate freely about
//   the pins
// * Two rollers that rotate freely about the bushes, and engage the
//   sprocket teeth
//
// ANSI chain sizes are specified as a pound sign, followed by a decimal
// number, a dash, and a decimal number representing the number of
// "strands", i.e., the number of these connected horizontally, which
// can be 1 through 6, plus 8, 10, and 12.
// The following table just lists the size number.

/* [Hidden] */
$fn = 96;

//               Size  PITCH  ROLLER_WID ROLLER_OD  WID   LINK_HGT  PLATE_TH PIN_OD
ANSI_SIZES = [ [  25,  0.250,   0.125,    0.130,   0.306,  0.228,    0.029,  0.091 ],
               [  35,  0.375,   0.188,    0.200,   0.456,  0.356,    0.050,  0.141 ],
               [  40,  0.500,   0.312,    0.312,   0.642,  0.475,    0.058,  0.156 ],
               [  41,  0.500,   0.250,    0.306,   0.522,  0.390,    0.050,  0.141 ],
               [  50,  0.625,   0.375,    0.400,   0.794,  0.594,    0.079,  0.200 ],
               [  60,  0.750,   0.500,    0.469,   0.994,  0.712,    0.093,  0.234 ],
               [  80,  1.000,   0.625,    0.625,   1.290,  0.950,    0.125,  0.312 ],
               [ 100,  1.250,   0.750,    0.750,   1.578,  1.188,    0.157,  0.375 ],
               [ 120,  1.500,   1.000,    0.875,   1.966,  1.425,    0.189,  0.437 ],
               [ 140,  1.750,   1.000,    1.000,   2.132,  1.663,    0.219,  0.500 ],
               [ 160,  2.000,   1.250,    1.125,   2.564,  1.901,    0.255,  0.563 ],
               [ 180,  2.250,   1.406,    1.406,   2.808,  2.130,    0.283,  0.687 ],
               [ 200,  2.500,   1.500,    1.562,   3.160,  2.376,    0.312,  0.782 ],
               [ 240,  3.000,   1.875,    1.875,   3.772,  2.850,    0.375,  0.937 ],
             ];

/* [ANSI Chain Size (Pitch)] */
ANSI_SIZE = 120; // [ 60:" 60 (3/4)", 80:" 80 (1)", 100:"100 (1 1/4)", 120:"120 (1 1/2)", 140:"140 (1 3/4)" ]

/* [Number of links] */
NUM_LINKS = 1; // [1:5]

/* [Arrangement] */
ARRANGEMENT = "Flat"; // ["Flat", "Exploded", "Assembled", "Outer+Pin", "Inner+Bush", "Roller"]

/* [Color] */
// Only render in the default color, for better illustration
ONE_COLOR = false;

ansi_parms = ANSI_SIZES[search(ANSI_SIZE, ANSI_SIZES)[0]];
echo(ansi_parms);

// Grab the rest of the parameters from the table
CH_PITCH =      ansi_parms[1];
CH_ROLLER_WID = ansi_parms[2];
CH_ROLLER_OD =  ansi_parms[3];
CH_WID =        ansi_parms[4];
CH_PLATE_HGT =  ansi_parms[5];
CH_PLATE_TH =   ansi_parms[6];
CH_PIN_OD =     ansi_parms[7];

// These parameters are not in the ANSI specification, so we calculate
// them. The other parameters do not increase linearly with pitch, which
// is why we need the table in the first place.

// Gaps between roller and inner plate, inner plate and outer plate, pin
// and bush, bush and roller
GAP = (CH_WID - CH_ROLLER_WID - CH_PLATE_TH*4) / 4;

pin_to_roller = CH_ROLLER_OD - CH_PIN_OD;
cyl_thick = (pin_to_roller - GAP*2) / 2;

CH_BUSH_ID = CH_PIN_OD + GAP;
CH_BUSH_OD = CH_BUSH_ID + cyl_thick;
CH_ROLLER_ID = CH_BUSH_OD + GAP;

include <Utils.scad>


// Everything is specified in inches;
// Rendering is as fast as preview now
scale([25.4, 25.4, 25.4]) render() {
    if (ARRANGEMENT == "Flat" || ARRANGEMENT=="Outer+Pin") {
        make_outer_plate(pin=true);
        ty(CH_PLATE_HGT+.25) make_outer_plate(pin=false);
    }

    if (ARRANGEMENT == "Flat" || ARRANGEMENT=="Inner+Bush") {
        tx(2*CH_PITCH) {
            make_inner_plate(bush=true);
            ty(CH_PLATE_HGT+.25) make_inner_plate(bush=false);
        }
    }

    if(ARRANGEMENT == "Flat" || ARRANGEMENT=="Roller") {
        tx(3.5*CH_PITCH+.25) make_axle(CH_ROLLER_ID, CH_ROLLER_OD, CH_ROLLER_WID, false);
        tx(4.5*CH_PITCH+.25) make_axle(CH_ROLLER_ID, CH_ROLLER_OD, CH_ROLLER_WID, false);
    }
}

module make_outer_plate(pin=true, hue=300, a=1) {
    difference() {
        union() {
            make_plate(pitch=CH_PITCH, height=CH_PLATE_HGT, thick=CH_PLATE_TH, hue=270, a=1);
            if (pin) {
                for (x = [CH_PITCH/2, -CH_PITCH/2] ) {
                    tx(x)
                        dhsv(h=hue, s=0.25, v=1.0, a=a)
                        make_axle(id=0, od=CH_PIN_OD, hgt=CH_WID, hue=hue, fit=false, a=a);
                }
            }
        }

        if (!pin) {
            for (x = [CH_PITCH/2, -CH_PITCH/2 ]) {
                tx(x)
                    color("white")
                    cylinder(d=CH_PIN_OD-GAP, h=CH_PLATE_TH);
            }
        }
    }
}


module make_inner_plate(bush=true, hue=300, a=1) {
    difference() {
        union() {
            make_plate(pitch=CH_PITCH, height=CH_PLATE_HGT, thick=CH_PLATE_TH, hue=270, a=1);
            if (bush) {
                for (x = [CH_PITCH/2, -CH_PITCH/2] ) {
                    tx(x)
                        dhsv(h=hue, s=0.25, v=1.0, a=a)
                        make_axle(id=CH_BUSH_ID, od=CH_BUSH_OD, hgt=CH_WID-2*(CH_PLATE_TH+GAP), hue=hue, fit=false, a=a);
                }
            }
        }

        for (x = [CH_PITCH/2, -CH_PITCH/2 ]) {
            tx(x)
                color("white")
                cylinder(d=(bush)?CH_BUSH_ID:CH_BUSH_OD-GAP, h=CH_PLATE_TH);
        }
    }
}


// "Axle" could refer to with the pins between the outside plates, the
// bushes between the inside plates, or the rollers.
module make_axle(id=0, od=0.1, hgt=.25, hue=10, fit=true, a=1) {
    difference() {
        union() {
            if (!fit) {
                tz(hgt-CH_PLATE_TH) {
                    dhsv(h=hue, s=.5, v=.75, a)
                    cylinder(d=od-GAP, h=CH_PLATE_TH);
                }

                /*tx(-2.5*CH_PITCH)*/ {
                    dhsv(h=hue+30, s=.25, v=1.0, a=.1)
                    cylinder(d=od, h=hgt-CH_PLATE_TH);
                }
            } else {
                cylinder(d=od, h=hgt);
            }
        }

        color("white")
            cylinder(d=id, h=hgt);
    }
}

module make_plate(pitch=CH_PITCH, height=CH_PLATE_HGT, thick=CH_PLATE_TH, hue=210, a=1) {
    translate([-pitch/2, -height/2, 0])
        dhsv(hue, 1.0, 0.5, a)
        cube(size = [pitch, height, thick]);

    tx(pitch/2)
        dhsv(hue, .75, .75, a)
        cylinder(d=height, h=thick);

    tx(-pitch/2)
        dhsv(hue, 0.5, 1.0, a)
        cylinder(d=height, h=thick);
}

// -- END OF PROGRAM --
