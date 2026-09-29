Report an invalid line width.

  $ printf '%s\n' 'canvas 500 300 navy' 'line 100 200 500 200 white 0' > bad_line.pic
  $ ../bin/main.exe bad_line.pic bad_line.svg
  Line 2: line width must be a positive number
  [1]
