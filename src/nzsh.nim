import 
  nzshpkg/functions,
  strformat,
  strutils

export functions

when isMainModule:
  let
    gitBranch = color(gitBranch(), "yellow")
    cwd = color(tilde(getCwd()), "cyan")
    dirty = color("✗", "red")
    clean = color("✓", "green")
    git = gitBranch & gitStatus(dirty, clean)
  var 
    rc = returnCondition("ok", "ng")
    prompt:string 

  if rc.strip() == "ng":
    prompt = color("❯ ", "red")
  else:
    prompt = color("❯ ", "green")
  if virtualenv() == "":
    if git == "": 
      echo &"{cwd.strip()}{prompt}"
    else:
      echo &"{cwd.strip()}[{git}] {prompt}"
  else: 
    if git == "":
      echo "(" & color(virtualenv().strip(), "blue") & &") {cwd.strip()}{prompt}"
    else: 
      echo "(" & color(virtualenv().strip(), "blue") & &") {cwd.strip()}[{git}] {prompt}"

