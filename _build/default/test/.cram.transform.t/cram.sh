  $ run() { rm -f out.svg; printf '%s\n' "$@" > in.pic; a1 in.pic out.svg && cat out.svg; }
  $ run "canvas 100 100 none" "transform translate 10 20" "  circle 0 0 1 red" "end"
  $ run "canvas 100 100 none" "transform rotate 45" "  line 0 0 0 -50 cream 4" "end"
  $ run "canvas 100 100 none" "transform scale 0.5" "  rectangle 0 0 10 10 blue" "end"
  $ run "canvas 100 100 none" "transform translate -5 -7.5" "  circle 0 0 1 red" "end"
  $ run "canvas 100 100 none" "transform rotate -90" "  circle 0 0 1 red" "end"
  $ run "canvas 100 100 none" "transform translate 1 2" "end"
  $ run "canvas 100 100 none" "circle 0 0 1 red" "transform translate 1 1" "circle 0 0 2 green" "end" "transform rotate 5" "circle 0 0 3 blue" "end" "circle 0 0 4 gold"
  $ run "canvas 100 100 none" \
  >   "circle 0 0 1 red" \
  >   "transform translate 10 10" \
  >   "  circle 0 0 2 orange" \
  >   "  transform rotate 30" \
  >   "    circle 0 0 3 yellow" \
  >   "    transform scale 2" \
  >   "      circle 0 0 4 green" \
  >   "    end" \
  >   "    circle 0 0 5 teal" \
  >   "  end" \
  >   "  circle 0 0 6 blue" \
  >   "end" \
  >   "circle 0 0 7 purple"
  $ run "canvas 900 700 navy" "transform translate 450 350" "  circle 0 0 100 gold" "  transform rotate 45" "    line 0 0 0 -200 cream 4" "  end" "end"
  $ run "canvas 100 100 none" "circle 0 0 1 red" "end"
  $ run "canvas 100 100 none" "transform rotate 5" "circle 0 0 1 red" "end" "end"
  $ run "canvas 100 100 none" "transform translate 1 1" "circle 0 0 1 red"
  $ test -e out.svg || echo "no svg written"
  $ run "canvas 100 100 none" "transform translate 1 1" "transform rotate 5" "circle 0 0 1 red" "end"
  $ run "canvas 100 100 none" "transform rotate 5" "end now"
  $ run "canvas 100 100 none" "transform" "end"
  $ run "canvas 100 100 none" "transform spin 3" "end"
  $ run "canvas 100 100 none" "transform translate 1" "end"
  $ run "canvas 100 100 none" "transform translate 1 2 3" "end"
  $ run "canvas 100 100 none" "transform rotate" "end"
  $ run "canvas 100 100 none" "transform scale 1 2" "end"
  $ run "canvas 100 100 none" "transform translate a 2" "end"
  $ run "canvas 100 100 none" "transform translate 1 b" "end"
  $ run "canvas 100 100 none" "transform rotate abc" "end"
  $ run "canvas 100 100 none" "transform scale abc" "end"
  $ run "canvas 100 100 none" "transform scale 0" "end"
  $ run "canvas 100 100 none" "transform scale -2" "end"
  $ run "canvas 100 100 none" "transform scale -0.5" "end"
  $ run "canvas 100 100 none" "transform translate 1 1" "circle 0 0 x red" "end"
