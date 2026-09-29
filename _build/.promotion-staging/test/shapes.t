Generate a canvas with multiple sibling shapes, decimal coordinates, and layering order:

  $ printf '%s\n' 'canvas 500 300 navy' 'circle 250.5 150.2 90.0 gold' 'rectangle 250 150 120 60 cream' > test_shapes.pic
  $ dune exec ../bin/main.exe -- test_shapes.pic shapes.svg
  $ cat shapes.svg
  <svg width="500.000000" height="300.000000" viewBox="0 0 500.000000 300.000000" xmlns="http://www.w3.org/2000/svg">
    <rect width="500.00" height="300.00" fill="#091226" />
    <circle cx="250.500000" cy="150.200000" r="90.000000" fill="#d9a441" />
    <rect x="250.000000" y="150.000000" width="120.000000" height="60.000000" fill="#fff1b0" />
  </svg>
