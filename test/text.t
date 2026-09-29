Generate a text label.

  $ printf '%s\n' 'canvas 500 300 navy' 'text 250 150 32 cream PICTURE THIS' > text_test.pic
  $ dune exec ../bin/main.exe -- text_test.pic text.svg
  $ cat text.svg
  <svg width="500.000000" height="300.000000" viewBox="0 0 500.000000 300.000000" xmlns="http://www.w3.org/2000/svg">
    <rect width="500.00" height="300.00" fill="#091226" />
    <text x="250.000000" y="150.000000" font-size="32.000000" fill="#fff1b0" text-anchor="middle">PICTURE THIS</text>
  </svg>

XML-sensitive text characters are escaped in the generated SVG.

  $ printf '%s\n' 'canvas 100 100 none' 'text 50 50 12 white A & B < C > "quoted"' > xml_text.pic
  $ dune exec ../bin/main.exe -- xml_text.pic xml_text.svg
  $ grep '<text' xml_text.svg
    <text x="50.000000" y="50.000000" font-size="12.000000" fill="#ffffff" text-anchor="middle">A &amp; B &lt; C &gt; &quot;quoted&quot;</text>
