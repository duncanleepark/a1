Generate a line.

  $ printf '%s\n' 'canvas 500 300 navy' 'line 100 200 500 200 white 4' > line_test.pic
  $ dune exec ../bin/main.exe -- line_test.pic line.svg
  $ cat line.svg
  <svg width="500.000000" height="300.000000" viewBox="0 0 500.000000 300.000000" xmlns="http://www.w3.org/2000/svg">
    <rect width="500.00" height="300.00" fill="#091226" />
    <line x1="100.000000" y1="200.000000" x2="500.000000" y2="200.000000" stroke="#ffffff" stroke-width="4.000000" />
  </svg>
