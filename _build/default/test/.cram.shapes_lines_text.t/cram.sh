  $ printf '%s\n' 'canvas 600 400 navy' 'circle 180 150 90 gold' 'rectangle 260 120 150 110 cream' 'line 60 320 540 320 white 4' 'text 300 80 32 cream PICTURE THIS' > poster.pic
  $ dune exec ../bin/main.exe -- poster.pic poster.svg
  $ cat poster.svg
