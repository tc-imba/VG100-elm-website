# Elm Tetris
A [Flatris](https://github.com/skidding/flatris) clone in Elm adjusted to VG100 needs.

![Screenshot](elm-tetris.png)

## Features

* works on both desktop and mobile
* renders the grid with `elm/svg`
* preserves the game state in `localStorage` using ports, just try to reload the page while playing!

## Instructions to run

1. Install elm [elm-lang.org/install](http://elm-lang.org/install)
2. Clone this repo and `cd` into it
3. Run `elm make src/Main.elm --output elm.js`
4. Open `index.html` in the browser
