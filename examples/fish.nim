# fish’s default prompt '~>'

import nzsh, strformat

let
  prompt = color("> ", "green")
  tilde = tilde(getCwd())

echo fmt"{tilde}{prompt}"

