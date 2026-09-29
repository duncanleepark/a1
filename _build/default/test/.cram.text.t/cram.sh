  $ printf '%s\n' 'canvas 500 300 navy' 'text 250 150 32 cream PICTURE THIS' > text_test.pic
  $ dune exec ../bin/main.exe -- text_test.pic text.svg
  $ cat text.svg
  $ printf '%s\n' 'canvas 100 100 none' 'text 50 50 12 white A & B < C > "quoted"' > xml_text.pic
  $ dune exec ../bin/main.exe -- xml_text.pic xml_text.svg
  $ grep '<text' xml_text.svg
