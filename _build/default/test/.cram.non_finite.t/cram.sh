  $ run() { printf '%s\n' "$@" > input.pic; ../bin/main.exe input.pic output.svg; }
  $ run "canvas infinity 100 navy"
  $ run "canvas 100 100 none" "circle nan 0 10 red"
  $ run "canvas 100 100 none" "rectangle 0 infinity 10 10 blue"
  $ run "canvas 100 100 none" "line 0 0 10 -infinity teal 2"
  $ run "canvas 100 100 none" "text 50 50 infinity cream hello"
  $ run "canvas 100 100 none" "transform rotate nan" "end"
