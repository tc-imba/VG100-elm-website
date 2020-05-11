# Elm Playground Reference Sheet

[Elm Playground](https://package.elm-lang.org/packages/evancz/elm-playground/latest/) is a third-party package, aiming to help elm beginners to develop their animations or games easily. In milestone 1 of project 1, we will develop a "break-out" game using Elm Playground.

## Install and Import

It's easy to install elm packages. In your project directory, type

```bash
elm install evancz/elm-playground
```

The elm package manager will automatically set up everything, and you should be able to find `"evancz/elm-playground": "1.0.3"`  in `elm.json` file in the project directory.

To import the playground into your project, add
```elm
import Playground exposing (..)
```
at the beginning of your source code.


## Notes

### About Elm Playground

Although this reference sheet is for you to easily look up the functions, you can still look at the source code of Elm Playground, which might be helpful for you to start milestone 2.

### About Coordinates

Elm Playground uses Cartesian coordinate system, the same as what we have learned in middle school, i.e.,

1. the origin is at the center of screen,
1. the positive x-axis points to the right,
1. the positive y-axis points to the top,

which differs from some other packages, e.g., `Svg`.

### About Project 1

Elm Playground provides 3 basic functions to achieve different goals. In milestone 1 of this project, you are encouraged to use `game` function. It will greatly reduce your workload and improve your collaboration if you understand the [playground examples](https://elm-lang.org/examples), and split the project into several parts (e.g., `Model`, `Update`, `View`, and `Objects`).


## Playground Functions

### Basics

| Name | Interface | Description |
| --- | --- | --- |
| `picture` | `List Shape -> Program () Screen (Int, Int)` | See [Elm Playground](https://package.elm-lang.org/packages/evancz/elm-playground/latest/) |
| `animation` | `(Time -> List Shape) -> Program () Animation Msg` | See [Elm Playground](https://package.elm-lang.org/packages/evancz/elm-playground/latest/) |
| `game` | `(Computer -> memory -> List Shape) -> (Computer -> memory -> memory) -> memory -> Program () (Game memory) Msg` | See [Elm Playground](https://package.elm-lang.org/packages/evancz/elm-playground/latest/) |

### Shape

| Name | Interface | Description |
| --- | --- | --- |
| `circle` | `Color -> Number -> Shape` | Given color and radius, draw a circle |
| `oval` | `Color -> Number -> Number -> Shape` | Given color, width and height, draw an oval |
| `square` | `Color -> Number -> Shape` | Given color and length of side, draw a square
| `rectangle` | `Color -> Number -> Number -> Shape` | Given color, width and height, draw a reactangle |
| `triangle` | `Color -> Number -> Shape` | Given color and radius*, draw a triangle |
| `pentagon` | `Color -> Number -> Shape` | Given color and radius*, draw a pentagon |
| `hexagon` | `Color -> Number -> Shape` | Given color and radius*, draw a hexagon |
| `octagon` | `Color -> Number -> Shape` | Given color and radius*, draw a octagon |
| `polygon` | `Color -> List (Number, Number) -> Shape` | Given color and a list of coordinates, draw a polygon |
| `image` | `Number -> Number -> String -> Shape` | Given width, height, and URL of the image, display an image |
| `words` | `Color -> String -> Shape` | Given color and text, display the text |

*radius: distance from the center to each vertex of the shape

### Shape Transformation

| Name | Interface | Description |
| --- | --- | --- |
| `move` | `Number -> Number -> Shape -> Shape` | Move the shape by some number of pixels |
| `moveUp` | `Number -> Shape -> Shape` | Move the shape up by some number of pixels |
| `moveDown` | `Number -> Shape -> Shape` | Move the shape down by some number of pixels |
| `moveLeft` | `Number -> Shape -> Shape` | Move the shape to the left by some number of pixels |
| `moveRight` | `Number -> Shape -> Shape` | Move the shape to the right by some number of pixels |
| `moveX` | `Number -> Shape -> Shape` | Same as `moveRight` |
| `moveY` | `Number -> Shape -> Shape` | Same as `moveUp` |
| `scale` | `Number -> Shape -> Shape` | Scale up/down the shape by a ratio |
| `rotate` | `Number -> Shape -> Shape` | Rotate the shape in degrees, in counter-clockwise direction |
| `fade` | `Number -> Shape -> Shape` | Fade the shape, and the number has to be between `0` and `1` |
| `group` | `List Shape -> Shape` | Put shapes together so you can `move` and `rotate` them as a group |


### Animation

| Name | Interface | Description |
| --- | --- | --- |
| `spin` | `Number -> Time -> Number` | Create an angle that cycles from 0 to 360 degrees over time, usually used together with `rotate` (see [Animation Example](https://elm-lang.org/examples/animation))
| `wave` | `Number -> Number -> Number -> Time -> Number` | Smoothly wave between two numbers |
| `zigzag` | `Number -> Number -> Number -> Time -> Number` | Zig zag between two numbers |

### Game

| Type Alias | Type |
| --- | --- |
| `Computer` | `{ mouse : Mouse`<br>`, keyboard : Keyboard`<br>`, screen : Screen`<br>` , time : Time`<br>`}` |
| `Number` | `Float` |
| `Mouse` | `{ x : Number`<br>`, y : Number`<br>`, down : Bool`<br>`, click : Bool`<br>`}`|
| `Keyboard` | `{ up : Bool`<br>`, down : Bool`<br>`, left : Bool`<br>`, right : Bool`<br>`, space : Bool`<br>`, enter : Bool`<br>`, shift : Bool`<br>`, backspace : Bool`<br>`, keys : Set.Set String`<br>`}` |

| Name | Interface | Description |
| --- | --- | --- |
| `toX` |` Keyboard -> Number` | Turn the `LEFT` and `RIGHT` arrows into `-1`, `0`, or `1` |
| `toX` |` Keyboard -> Number` | Turn the `UP` and `DOWN` arrows into `-1`, `0`, or `1` |
| `toXY` |` Keyboard -> (Number, Number)` | A combination of `toX` and `toY` |


### Color

Elm Playground provides a bunch of colors that you can directly use in creating a shape. They are:

1. `red`, `lightRed`, `darkRed`,
1. `orange`, `lightOrange`, `darkOrange`,
1. `yellow`, `lightYellow`, `darkYellow`,
1. `green`, `lightGreen`, `darkGreen`,
1. `blue`, `lightBlue`, `darkBlue`,
1. `purple`, `lightPurple`, `darkPurple`,
1. `brown`, `lightBrown`, `darkBrown`,
1. `grey` / `gray`, `lightGrey` / `lightGray`, `darkGrey` / `darkGray`,
1. `charcoal`, `lightCharcoal`, `darkCharcoal`,
1. `white`,
1. `black`

Meanwhile, you are allowed to custom the color in two ways:

1. `Hex String`, e.g., `Hex "#FFFFFF"`
1. `Rgb Int Int Int`, e.g., `Rgb 255 255 255`

<style>
table th:first-of-type {
    width: 15%;
}
table th:nth-of-type(2) {
    width: 35%;
}
table th:nth-of-type(3) {
    width: 50%;
}
</style>
