Reject non-finite numeric values.

  $ run() { printf '%s\n' "$@" > input.pic; ../bin/main.exe input.pic output.svg; }

  $ run "canvas infinity 100 navy"
  Line 1: canvas width must be a number
  [1]

  $ run "canvas 100 100 none" "circle nan 0 10 red"
  Line 2: circle x must be a number
  [1]

  $ run "canvas 100 100 none" "rectangle 0 infinity 10 10 blue"
  Line 2: rectangle y must be a number
  [1]

  $ run "canvas 100 100 none" "line 0 0 10 -infinity teal 2"
  Line 2: line y2 must be a number
  [1]

  $ run "canvas 100 100 none" "text 50 50 infinity cream hello"
  Line 2: text size must be a number
  [1]

  $ run "canvas 100 100 none" "transform rotate nan" "end"
  Line 2: rotate degrees must be a number
  [1]
