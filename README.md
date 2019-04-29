# Elm Starter Project

# Notes

TODO:

# Install

## Base

- Install NVM: https://github.com/creationix/nvm
- Install Elm: `npm install -g elm`

## Visual Studio Code

- Install `elm-format`: `npm install -g elm-format`
- Install VS Code from https://code.visualstudio.com/
- Add `code` command to `PATH` for command line usage
  - `Cmd-P` (Mac) or `Ctrl-P` (Linux): Launch Command Palette
  - Type `> Shell Command: Install code command in PATH`
- Install Elm Extension
  - From Command Line: `code --install-extension sbrink.elm`
  - From Web: `https://marketplace.visualstudio.com/items?itemName=sbrink.elm`
- Restart VS Code

# Use

## Start Project

```bash
elm init
```

## Develop

### `elm reactor`

Note: `elm reactor` doesn't work if you have HTML or JavaScript code. See https://github.com/rtfeldman/elm-spa-example#building for that.

- + can click through source files
- + no dependencies
- + shows compilation errors in browser
- - no complex args (like `--debug`)
- - requires page reload on file change

```
./dev_env.sh
```

### `elm-live`

- + live-reloading on file change
- + works with more complex builds (like `--debug`)
- - doesn't show compilation errors in browser
- - extra dependency

- Install: `npm install -g elm-live`

```bash
elm-live src/Main.elm --open -- --debug
```

# Useful Learning Links

- Guide: https://guide.elm-lang.org/
- Guide Code: https://github.com/evancz/elm-architecture-tutorial/
- Basic Project instructions: https://elm-lang.org/0.19.0/init
- Adding Packages, etc: https://guide.elm-lang.org/install.html
- HTML -> ELM: https://mbylstra.github.io/html-to-elm/
- JSON -> ELM: https://app.quicktype.io/
- https://github.com/evancz/elm-todomvc
- https://github.com/rtfeldman/elm-spa-example

