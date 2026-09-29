  $ printf '%s\n' 'canvas 500 300 navy' 'line 100 200 500 200 white 4' > line_test.pic
  $ dune exec ../bin/main.exe -- line_test.pic line.svg
  $ cat line.svg
