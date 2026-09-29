Cumulative repetition tests.

  $ run() { rm -f out.svg; printf '%s\n' "$@" > in.pic; a1 in.pic out.svg && { printf 'groups: '; grep -c '  <g transform' out.svg || true; grep '  <g transform' out.svg || true; }; }
  $ run_full() { rm -f out.svg; printf '%s\n' "$@" > in.pic; a1 in.pic out.svg && cat out.svg; }

Zero copies for each transformation produce no groups.

  $ run "canvas 100 100 none" "repeat 0 translate 10 5" "circle 1 1 1 red" "end"
  groups: 0
  $ grep -c '  <circle' out.svg || true
  0
  $ run "canvas 100 100 none" "repeat 0 rotate 15" "circle 1 1 1 red" "end"
  groups: 0
  $ grep -c '  <circle' out.svg || true
  0
  $ run "canvas 100 100 none" "repeat 0 scale 2" "circle 1 1 1 red" "end"
  groups: 0
  $ grep -c '  <circle' out.svg || true
  0

One copy uses the identity transformation (copy zero).

  $ run "canvas 100 100 none" "repeat 1 translate 10 5" "circle 1 1 1 red" "end"
  groups: 1
    <g transform="translate(0.000000 0.000000)">
  $ run "canvas 100 100 none" "repeat 1 rotate 15" "circle 1 1 1 red" "end"
  groups: 1
    <g transform="rotate(0.000000)">
  $ run "canvas 100 100 none" "repeat 1 scale 2" "circle 1 1 1 red" "end"
  groups: 1
    <g transform="scale(1.000000)">

Several translations accumulate and render in copy order.

  $ run "canvas 100 100 none" "repeat 3 translate 10 -5" "circle 1 1 1 red" "end"
  groups: 3
    <g transform="translate(0.000000 0.000000)">
    <g transform="translate(10.000000 -5.000000)">
    <g transform="translate(20.000000 -10.000000)">

Several rotations accumulate and render in copy order.

  $ run "canvas 100 100 none" "repeat 4 rotate 30" "circle 1 1 1 red" "end"
  groups: 4
    <g transform="rotate(0.000000)">
    <g transform="rotate(30.000000)">
    <g transform="rotate(60.000000)">
    <g transform="rotate(90.000000)">

Several scales are raised to the copy number.

  $ run "canvas 100 100 none" "repeat 4 scale 0.5" "circle 1 1 1 red" "end"
  groups: 4
    <g transform="scale(1.000000)">
    <g transform="scale(0.500000)">
    <g transform="scale(0.250000)">
    <g transform="scale(0.125000)">

Nested repetitions render each inner sequence inside each outer copy.

  $ run "canvas 100 100 none" "repeat 2 translate 10 0" "repeat 2 translate 0 5" "circle 1 1 1 blue" "end" "end"
  groups: 6
    <g transform="translate(0.000000 0.000000)">
    <g transform="translate(0.000000 0.000000)">
    <g transform="translate(0.000000 5.000000)">
    <g transform="translate(10.000000 0.000000)">
    <g transform="translate(0.000000 0.000000)">
    <g transform="translate(0.000000 5.000000)">

Nested repeats preserve the exact group structure and render one body in each inner copy.

  $ run_full "canvas 30 30 none" "repeat 2 translate 10 0" "repeat 2 translate 0 5" "circle 1 1 1 blue" "end" "end"
  <svg width="30.000000" height="30.000000" viewBox="0 0 30.000000 30.000000" xmlns="http://www.w3.org/2000/svg">
    <g transform="translate(0.000000 0.000000)">
    <g transform="translate(0.000000 0.000000)">
    <circle cx="1.000000" cy="1.000000" r="1.000000" fill="#277da1" />
    </g>
    <g transform="translate(0.000000 5.000000)">
    <circle cx="1.000000" cy="1.000000" r="1.000000" fill="#277da1" />
    </g>
    </g>
    <g transform="translate(10.000000 0.000000)">
    <g transform="translate(0.000000 0.000000)">
    <circle cx="1.000000" cy="1.000000" r="1.000000" fill="#277da1" />
    </g>
    <g transform="translate(0.000000 5.000000)">
    <circle cx="1.000000" cy="1.000000" r="1.000000" fill="#277da1" />
    </g>
    </g>
  </svg>

Malformed and negative counts are rejected.

  $ run "canvas 100 100 none" "repeat nope translate 1 2" "circle 1 1 1 red" "end"
  Line 2: repeat count must be an integer
  [1]
  $ run "canvas 100 100 none" "repeat" "circle 1 1 1 red" "end"
  Line 2: repeat must be followed by a count and a transformation
  [1]
  $ run "canvas 100 100 none" "repeat 1.5 translate 1 2" "circle 1 1 1 red" "end"
  Line 2: repeat count must be an integer
  [1]
  $ run "canvas 100 100 none" "repeat -2 translate 1 2" "circle 1 1 1 red" "end"
  Line 2: repeat count must not be negative
  [1]
  $ run "canvas 100 100 none" "repeat 2" "circle 1 1 1 red" "end"
  Line 2: repeat requires a transformation after the count
  [1]
  $ run "canvas 100 100 none" "repeat 2 translate 1" "circle 1 1 1 red" "end"
  Line 2: wrong number of parameters for 'translate' transformation
  [1]
  $ run "canvas 100 100 none" "repeat 2 spin 15" "circle 1 1 1 red" "end"
  Line 2: unknown transformation 'spin'; expected translate, rotate, or scale
  [1]

Complete source-to-SVG radial repetition inside a translated local origin.

  $ run_full "canvas 80 80 white" "transform translate 40 40" "repeat 4 rotate 90" "line 0 0 0 -20 teal 2" "end" "circle 0 0 3 gold" "end"
  <svg width="80.000000" height="80.000000" viewBox="0 0 80.000000 80.000000" xmlns="http://www.w3.org/2000/svg">
    <rect width="80.00" height="80.00" fill="#ffffff" />
    <g transform="translate(40.000000 40.000000)">
    <g transform="rotate(0.000000)">
    <line x1="0.000000" y1="0.000000" x2="0.000000" y2="-20.000000" stroke="#008080" stroke-width="2.000000" />
    </g>
    <g transform="rotate(90.000000)">
    <line x1="0.000000" y1="0.000000" x2="0.000000" y2="-20.000000" stroke="#008080" stroke-width="2.000000" />
    </g>
    <g transform="rotate(180.000000)">
    <line x1="0.000000" y1="0.000000" x2="0.000000" y2="-20.000000" stroke="#008080" stroke-width="2.000000" />
    </g>
    <g transform="rotate(270.000000)">
    <line x1="0.000000" y1="0.000000" x2="0.000000" y2="-20.000000" stroke="#008080" stroke-width="2.000000" />
    </g>
    <circle cx="0.000000" cy="0.000000" r="3.000000" fill="#d9a441" />
    </g>
  </svg>
