Report an error on a negative circle radius:

  $ printf '%s\n' 'canvas 500 300 navy' 'circle 250 150 -10 gold' > bad_radius.pic
  $ dune exec ../bin/main.exe -- bad_radius.pic bad.svg
  Line 2: circle radius must be a positive number
  [1]

Report an error on an unknown shape color:

  $ printf '%s\n' 'canvas 500 300 navy' 'rectangle 0 0 100 100 neonpink' > bad_color.pic
  $ dune exec ../bin/main.exe -- bad_color.pic bad.svg
  Line 2: unknown color 'neonpink'
  [1]
