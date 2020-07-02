<h1 align="center">                                                              
    <img src="https://i.imgur.com/CO9KojZ.png" width="280">                            
</h1>

# Slick, elegant, fast, and minimal ZSH prompt in Nim.



### Why?
I’ve always wanted to minimize my reliance on frameworks like [oh-my-zsh](https://github.com/robbyrussell/oh-my-zsh), so I figured, why not write my own ZSH prompt in my new favourite language? Turned out to be a really fun exercise.

### Highlights
- Written in Nim 👑
- Fast (in theory, since Nim compiles to C)
- Pretty defaults.
- Plugin-like system for prompt customization, in case you didn’t like the pretty defaults.
- Fun, I guess.

## Installation
**Note**: It’s probably a good idea to uninstall `oh-my-zsh`, or any other plugin framework you’re using
altogether. It may cause conflicts.

```console
$ nimble install nzsh
```

Don’t know what that is? New to Nim? Check out the Nim [docs](https://nim-lang.org/documentation.html). `nimble` is packaged with Nim by default.  

## Quick start
Add this to your `~/.zshrc`. If you installed via `nimble`, set `PROMPT` to `$(~/.nimble/bin/nzsh)`.

```zsh
autoload -Uz add-zsh-hook
_nzsh_prompt() {
	PROMPT=$("/path/to/nzsh")
}
add-zsh-hook precmd _nzsh_prompt
```
Make sure you disable all other themes.

## Configuration
If you want to configure `nzsh` as it is, you’ll have to edit the `src/nzsh.nim` file and recompile. Messy, I know.

### Build your own prompt
Alternatively, you can just as easily write your own prompt in Nim using `nzsh`’s built-in API. Refer to the [Examples](#Examples) section for some insight.

Once you’re done, compile it and add a similar function to your `.zshrc` as above, replacing `PROMPT` with the path to your own binary.

### Examples

```nim
# ‘user@host $’ prompt

import nzsh, strformat

let
  user = color(user(), "green")
  host = color(host(), "red")
  prompt = color("$ ", "cyan")
  at = color("@", "yellow")

echo fmt"{user}{at}{host} {prompt}"
```

```nim
# fish’s default prompt '~>'

import nzsh, strformat

let
  prompt = color("> ", "green")
  tilde = tilde(getCwd())

echo fmt"{tilde}{prompt}"
```

```nim
# pure by @sindresorhus (kinda)

import nzsh, strformat

let
  prompt = color("❯ ", "magenta")
  tilde = color(tilde(getCwd()), "cyan")
  git = color(gitBranch() & gitStatus("*", ""), "red")
  nl = "\n"

echo fmt"{tilde}{git}{nl}{prompt}"
```

```nim
# switching by return code

import nzsh, strformat

let
  prompt = returnCondition(ok = "👍", ng = "👎") & " "
  tilde = color(tilde(getCwd()), "cyan")
  git = color(gitBranch() & gitStatus("*", ""), "red")
  nl = "\n"

echo fmt"{tilde}{git}{nl}{prompt}"
# ~ master
# 👍 
```

### API

**`zeroWidth(s: string): string`**  
Returns the given string wrapped in zsh zero-width codes. Useful for prompt alignment and cursor positioning.  
All procs below return strings wrapped by this.

**`foreground(s, color: string): string`**  
Returns the given string, colorized.  
Possible colors are `"black"`, `"red"`, `"green"` `"blue"`, `"cyan"`, `"yellow"`, `"magenta"`, `"white"`.

**`background(s, color: string): string`**  
Returns the given string with its background colorized.  
Same possible colors as above.

**`bold(s: string): string`**  
Makes the given string bold.

**`underline(s: string): string`**  
Adds an underline to the given string.

**`italics(s: string): string`**  
Italicizes the given text. **May not work on all terminals!**

**`reverse(s: string): string`**  
Swaps the foreground/background colors for the given string.

**`reset(s: string): string`**  
Resets all attributes. Useful for disabling all styling.

**`color(s: string, fg: string = "", bg: string = "",  b: bool = false, u: bool = false, r = false): string`**  
Convenience proc that sets all attributes to a given string.  
`fg`: foreground, `bg`: background, `b`: bold, `u`: underline, `r`: reverse

**`horizontalRule(c: char): string`**  
Returns a string of characters `c`, having the length of the current terminal width. Useful for positioning right-side prompts.

**`tilde(path: string): string`**  
If `path` starts with `/home/user`, it is replaced by a `~/`.

**`getCwd(): string`**  
Returns the full path of the current working directory, or returns the string `[not found]` if current path doesn’t exist. (eg: `rm -rf ../curpath`)

**`virtualenv(): string`**  
Returns the current virtualenv name if in one.

**`gitBranch(): string`**  
Returns the current git branch, if in a git directory.

**`gitStatus(dirty, clean: string): string`**  
Returns either `dirty` or `clean` if in a git repository. For example, return `•` if clean and `×` if dirty.

**`user(): string`**  
Returns the current username.

**`host(): string`**  
Returns the current hostname.

**`returnCondition*(ok: string, ng: string, delimiter = "."): string`**  
Returns `ok` string or `ng` string.
if the return code is `0` then `ok` else `ng`.

**`returnCondition*(ok: proc(): string, ng: proc(): string, delimiter = "."): string`**  
Returns result of `ok` proc or `ng` proc.
if the return code is `0` then this proc calls `ok` proc else this proc calls `ng` proc.

**`echoc*(s: cstring) {.importc: "printf", header: "<stdio.h>".}`**  
Fast, pure C alternative to `echo`. Uses `cstring`.

## Contributing
Bad code? New feature in mind? Open an issue. Better still, learn [Nim](https://nim-lang.org/documentation.html) and shoot a PR :sparkles:

## License
MIT © [Anirudh Oppiliappan](https://icyphox.sh)
