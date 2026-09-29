Generate a poster with all primitives.

  $ printf '%s\n' 'canvas 600 400 navy' 'circle 180 150 90 gold' 'rectangle 260 120 150 110 cream' 'line 60 320 540 320 white 4' 'text 300 80 32 cream PICTURE THIS' > poster.pic
  $ dune exec ../bin/main.exe -- poster.pic poster.svg
  $ cat poster.svg
  <svg width="600.000000" height="400.000000" viewBox="0 0 600.000000 400.000000" xmlns="http://www.w3.org/2000/svg">
    <rect width="600.00" height="400.00" fill="#091226" />
    <circle cx="180.000000" cy="150.000000" r="90.000000" fill="#d9a441" />
    <rect x="260.000000" y="120.000000" width="150.000000" height="110.000000" fill="#fff1b0" />
    <line x1="60.000000" y1="320.000000" x2="540.000000" y2="320.000000" stroke="#ffffff" stroke-width="4.000000" />
    <text x="300.000000" y="80.000000" font-size="32.000000" fill="#fff1b0" text-anchor="middle">PICTURE THIS</text>
  </svg>
