Transform block tests. Change "a1" below to the name of your executable.

run writes each argument as one line of a .pic file, then runs the generator
and prints the SVG (or the error, followed by the exit code).

  $ run() { rm -f out.svg; printf '%s\n' "$@" > in.pic; a1 in.pic out.svg && cat out.svg; }

Each transformation by itself: translate

  $ run "canvas 100 100 none" "transform translate 10 20" "  circle 0 0 1 red" "end"
  <svg width="100.000000" height="100.000000" viewBox="0 0 100.000000 100.000000" xmlns="http://www.w3.org/2000/svg">
    <g transform="translate(10.000000 20.000000)">
    <circle cx="0.000000" cy="0.000000" r="1.000000" fill="#c1121f" />
    </g>
  </svg>

Each transformation by itself: rotate

  $ run "canvas 100 100 none" "transform rotate 45" "  line 0 0 0 -50 cream 4" "end"
  <svg width="100.000000" height="100.000000" viewBox="0 0 100.000000 100.000000" xmlns="http://www.w3.org/2000/svg">
    <g transform="rotate(45.000000)">
    <line x1="0.000000" y1="0.000000" x2="0.000000" y2="-50.000000" stroke="#fff1b0" stroke-width="4.000000" />
    </g>
  </svg>

Each transformation by itself: scale (positive fraction)

  $ run "canvas 100 100 none" "transform scale 0.5" "  rectangle 0 0 10 10 blue" "end"
  <svg width="100.000000" height="100.000000" viewBox="0 0 100.000000 100.000000" xmlns="http://www.w3.org/2000/svg">
    <g transform="scale(0.500000)">
    <rect x="0.000000" y="0.000000" width="10.000000" height="10.000000" fill="#277da1" />
    </g>
  </svg>

Negative translation

  $ run "canvas 100 100 none" "transform translate -5 -7.5" "  circle 0 0 1 red" "end"
  <svg width="100.000000" height="100.000000" viewBox="0 0 100.000000 100.000000" xmlns="http://www.w3.org/2000/svg">
    <g transform="translate(-5.000000 -7.500000)">
    <circle cx="0.000000" cy="0.000000" r="1.000000" fill="#c1121f" />
    </g>
  </svg>

Negative rotation

  $ run "canvas 100 100 none" "transform rotate -90" "  circle 0 0 1 red" "end"
  <svg width="100.000000" height="100.000000" viewBox="0 0 100.000000 100.000000" xmlns="http://www.w3.org/2000/svg">
    <g transform="rotate(-90.000000)">
    <circle cx="0.000000" cy="0.000000" r="1.000000" fill="#c1121f" />
    </g>
  </svg>

Empty block

  $ run "canvas 100 100 none" "transform translate 1 2" "end"
  <svg width="100.000000" height="100.000000" viewBox="0 0 100.000000 100.000000" xmlns="http://www.w3.org/2000/svg">
    <g transform="translate(1.000000 2.000000)">
    </g>
  </svg>

Sibling blocks, with shapes before, between, and after (source order preserved)

  $ run "canvas 100 100 none" "circle 0 0 1 red" "transform translate 1 1" "circle 0 0 2 green" "end" "transform rotate 5" "circle 0 0 3 blue" "end" "circle 0 0 4 gold"
  <svg width="100.000000" height="100.000000" viewBox="0 0 100.000000 100.000000" xmlns="http://www.w3.org/2000/svg">
    <circle cx="0.000000" cy="0.000000" r="1.000000" fill="#c1121f" />
    <g transform="translate(1.000000 1.000000)">
    <circle cx="0.000000" cy="0.000000" r="2.000000" fill="#2a9d8f" />
    </g>
    <g transform="rotate(5.000000)">
    <circle cx="0.000000" cy="0.000000" r="3.000000" fill="#277da1" />
    </g>
    <circle cx="0.000000" cy="0.000000" r="4.000000" fill="#d9a441" />
  </svg>

Nested three levels deep, with shapes before and after each inner block

  $ run "canvas 100 100 none" \
  >   "circle 0 0 1 red" \
  >   "transform translate 10 10" \
  >   "  circle 0 0 2 orange" \
  >   "  transform rotate 30" \
  >   "    circle 0 0 3 yellow" \
  >   "    transform scale 2" \
  >   "      circle 0 0 4 green" \
  >   "    end" \
  >   "    circle 0 0 5 teal" \
  >   "  end" \
  >   "  circle 0 0 6 blue" \
  >   "end" \
  >   "circle 0 0 7 purple"
  <svg width="100.000000" height="100.000000" viewBox="0 0 100.000000 100.000000" xmlns="http://www.w3.org/2000/svg">
    <circle cx="0.000000" cy="0.000000" r="1.000000" fill="#c1121f" />
    <g transform="translate(10.000000 10.000000)">
    <circle cx="0.000000" cy="0.000000" r="2.000000" fill="#f77f00" />
    <g transform="rotate(30.000000)">
    <circle cx="0.000000" cy="0.000000" r="3.000000" fill="#fcbf49" />
    <g transform="scale(2.000000)">
    <circle cx="0.000000" cy="0.000000" r="4.000000" fill="#2a9d8f" />
    </g>
    <circle cx="0.000000" cy="0.000000" r="5.000000" fill="#008080" />
    </g>
    <circle cx="0.000000" cy="0.000000" r="6.000000" fill="#277da1" />
    </g>
    <circle cx="0.000000" cy="0.000000" r="7.000000" fill="#7b2cbf" />
  </svg>

Complete source-to-SVG test with a background and nesting

  $ run "canvas 900 700 navy" "transform translate 450 350" "  circle 0 0 100 gold" "  transform rotate 45" "    line 0 0 0 -200 cream 4" "  end" "end"
  <svg width="900.000000" height="700.000000" viewBox="0 0 900.000000 700.000000" xmlns="http://www.w3.org/2000/svg">
    <rect width="900.00" height="700.00" fill="#091226" />
    <g transform="translate(450.000000 350.000000)">
    <circle cx="0.000000" cy="0.000000" r="100.000000" fill="#d9a441" />
    <g transform="rotate(45.000000)">
    <line x1="0.000000" y1="0.000000" x2="0.000000" y2="-200.000000" stroke="#fff1b0" stroke-width="4.000000" />
    </g>
    </g>
  </svg>

Unexpected end at top level

  $ run "canvas 100 100 none" "circle 0 0 1 red" "end"
  Line 3: unexpected 'end' outside of a block
  [1]

Extra end after a balanced block

  $ run "canvas 100 100 none" "transform rotate 5" "circle 0 0 1 red" "end" "end"
  Line 5: unexpected 'end' outside of a block
  [1]

Missing end: the error names the unclosed block, and no SVG is written

  $ run "canvas 100 100 none" "transform translate 1 1" "circle 0 0 1 red"
  Line 2: transform block is never closed; expected a matching 'end'
  [1]
  $ test -e out.svg || echo "no svg written"
  no svg written

Missing end when nested: the inner block is closed by the only end, so the outer one is reported

  $ run "canvas 100 100 none" "transform translate 1 1" "transform rotate 5" "circle 0 0 1 red" "end"
  Line 2: transform block is never closed; expected a matching 'end'
  [1]

End with extra words

  $ run "canvas 100 100 none" "transform rotate 5" "end now"
  Line 3: 'end' takes no parameters
  [1]

Malformed headers

  $ run "canvas 100 100 none" "transform" "end"
  Line 2: transform must be followed by translate, rotate, or scale
  [1]

  $ run "canvas 100 100 none" "transform spin 3" "end"
  Line 2: unknown transformation 'spin'; expected translate, rotate, or scale
  [1]

  $ run "canvas 100 100 none" "transform translate 1" "end"
  Line 2: wrong number of parameters for 'translate' transformation
  [1]

  $ run "canvas 100 100 none" "transform translate 1 2 3" "end"
  Line 2: wrong number of parameters for 'translate' transformation
  [1]

  $ run "canvas 100 100 none" "transform rotate" "end"
  Line 2: wrong number of parameters for 'rotate' transformation
  [1]

  $ run "canvas 100 100 none" "transform scale 1 2" "end"
  Line 2: wrong number of parameters for 'scale' transformation
  [1]

Non-numeric parameters

  $ run "canvas 100 100 none" "transform translate a 2" "end"
  Line 2: translate dx must be a number
  [1]

  $ run "canvas 100 100 none" "transform translate 1 b" "end"
  Line 2: translate dy must be a number
  [1]

  $ run "canvas 100 100 none" "transform rotate abc" "end"
  Line 2: rotate degrees must be a number
  [1]

  $ run "canvas 100 100 none" "transform scale abc" "end"
  Line 2: scale factor must be a number
  [1]

Nonsensical scale factors

  $ run "canvas 100 100 none" "transform scale 0" "end"
  Line 2: scale factor must be a positive number
  [1]

  $ run "canvas 100 100 none" "transform scale -2" "end"
  Line 2: scale factor must be a positive number
  [1]

  $ run "canvas 100 100 none" "transform scale -0.5" "end"
  Line 2: scale factor must be a positive number
  [1]

An error inside a block reports the line of the bad shape

  $ run "canvas 100 100 none" "transform translate 1 1" "circle 0 0 x red" "end"
  Line 3: circle radius must be a number
  [1]
