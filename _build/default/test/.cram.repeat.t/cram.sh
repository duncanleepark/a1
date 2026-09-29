  $ run() { rm -f out.svg; printf '%s\n' "$@" > in.pic; a1 in.pic out.svg && { printf 'groups: '; grep -c '  <g transform' out.svg || true; grep '  <g transform' out.svg || true; }; }
  $ run_full() { rm -f out.svg; printf '%s\n' "$@" > in.pic; a1 in.pic out.svg && cat out.svg; }
  $ run "canvas 100 100 none" "repeat 0 translate 10 5" "circle 1 1 1 red" "end"
  $ grep -c '  <circle' out.svg || true
  $ run "canvas 100 100 none" "repeat 0 rotate 15" "circle 1 1 1 red" "end"
  $ grep -c '  <circle' out.svg || true
  $ run "canvas 100 100 none" "repeat 0 scale 2" "circle 1 1 1 red" "end"
  $ grep -c '  <circle' out.svg || true
  $ run "canvas 100 100 none" "repeat 1 translate 10 5" "circle 1 1 1 red" "end"
  $ run "canvas 100 100 none" "repeat 1 rotate 15" "circle 1 1 1 red" "end"
  $ run "canvas 100 100 none" "repeat 1 scale 2" "circle 1 1 1 red" "end"
  $ run "canvas 100 100 none" "repeat 3 translate 10 -5" "circle 1 1 1 red" "end"
  $ run "canvas 100 100 none" "repeat 4 rotate 30" "circle 1 1 1 red" "end"
  $ run "canvas 100 100 none" "repeat 4 scale 0.5" "circle 1 1 1 red" "end"
  $ run "canvas 100 100 none" "repeat 2 translate 10 0" "repeat 2 translate 0 5" "circle 1 1 1 blue" "end" "end"
  $ run_full "canvas 30 30 none" "repeat 2 translate 10 0" "repeat 2 translate 0 5" "circle 1 1 1 blue" "end" "end"
  $ run "canvas 100 100 none" "repeat nope translate 1 2" "circle 1 1 1 red" "end"
  $ run "canvas 100 100 none" "repeat" "circle 1 1 1 red" "end"
  $ run "canvas 100 100 none" "repeat 1.5 translate 1 2" "circle 1 1 1 red" "end"
  $ run "canvas 100 100 none" "repeat -2 translate 1 2" "circle 1 1 1 red" "end"
  $ run "canvas 100 100 none" "repeat 2" "circle 1 1 1 red" "end"
  $ run "canvas 100 100 none" "repeat 2 translate 1" "circle 1 1 1 red" "end"
  $ run "canvas 100 100 none" "repeat 2 spin 15" "circle 1 1 1 red" "end"
  $ run_full "canvas 80 80 white" "transform translate 40 40" "repeat 4 rotate 90" "line 0 0 0 -20 teal 2" "end" "circle 0 0 3 gold" "end"
