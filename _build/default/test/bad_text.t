Report an invalid text size.

  $ printf '%s\n' 'canvas 500 300 navy' 'text 250 150 0 cream hello' > bad_text.pic
  $ ../bin/main.exe bad_text.pic bad_text.svg
  Line 2: text size must be a positive number
  [1]
