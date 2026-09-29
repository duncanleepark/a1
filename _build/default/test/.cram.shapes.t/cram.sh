  $ printf '%s\n' 'canvas 500 300 navy' 'circle 250.5 150.2 90.0 gold' 'rectangle 250 150 120 60 cream' > test_shapes.pic
  $ dune exec ../bin/main.exe -- test_shapes.pic shapes.svg
  $ cat shapes.svg
