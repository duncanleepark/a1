Report an error on a negative circle radius:

  $ cat > bad_radius.pic <<EOF

  $ dune exec ../bin/main.exe -- bad_radius.pic bad.svg
  No nonblank lines found in the input.
  [1]

Report an error on an unknown shape color:

  $ cat > bad_color.pic <<EOF

  $ dune exec ../bin/main.exe -- bad_color.pic bad.svg
  No nonblank lines found in the input.
  [1]
