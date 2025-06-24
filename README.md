# Chain_ANSI.scad
3D-print roller chain in ANSI-standard sizes

## What's here at the moment
These OpenSCAD files produce the different parts of roller (motorcycle, bicycle, etc.)
chain, in ANSI sizes #25-1 through #200-1, although sizes below #60-1 haven't been
tested, and would almost certainly require an 0.2mm or smaller hotend.


My prints so far have been purely ornamental; at some point I'll try printing with
some kind of CF or GF filament to see how much tensile strength I can get.

## Weird colors
I have a habit of specifying lots of different colors for the various shapes that go
into a design. This does not imply multicolor printing--that's between you and your
printer.

## The Customizer
When opened in OpenSCAD, the Customizer lets you specify the size, number of links,
and how they're arranged. You can also select "One Color", which ignores the weird
colors in the code, in favor of the default yellow.

One caveat is that the code does not try to figure out of the size and number of
like would be too much to fit on a build plate.

## Arrangements
There are six different pieces that make up a link: An outer plate with pins, the
opposite outer plate, an inner plate with bushings, the opposite inner plate, and
two rollers. The "Arrangement" parameter lets you choose from:
* Flat: Each piece is laid out on the X-Y plane for printing.
* Assembled: Each piece is located where it would be when the chain is assembled.
It is intended for creating illustrations, not for printing.
* Exploded: The pieces are located relative wo where they are in the assembly, but
spread out and with axis lines, to aid in creating an exploded view.
* Others: The other options render some subset of the pieces in a flat arrangement.

At the moment, only "flat" actually works.

## ANSI sizing
The table of ANSI-specified parameters is hard-coded. If the standard changes, the
code will have to be modified accordingly.

## Useful command lines
Basic STL creation:
```
openscad -o outfile.stl -D ANSI_SIZE=size Chain_ANSI.scad
```
where size is currently one of 25, 35, 40,41, 50, 60, 80, 100, 120, 140, 160, 180, 200, 240.
The tens and hundreds digits represent the chain pitch in eighths of an inch, e.g., size 60
has a pitch of 6 * 1/8" = 3/4".

> [!NOTE]
> More to come
