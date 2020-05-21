module Basic exposing (main)

import Playground exposing (..)


main =
    game view update { x = 0, y = 200, angle = 90 }


lshape color1 color2 =
    group
        [ rectangle color1 10 20
        , rectangle color2 20 10
            |> move 5 15
        ]


view computer shapes =
    [ lshape red green
        |> move shapes.x shapes.y
        |> rotate shapes.angle
        |> scale 3
    ]


update computer shapes =
    let
        x =
            shapes.x + toX computer.keyboard

        y =
            if shapes.y <= -100 then
                shapes.y

            else if computer.keyboard.down then
                shapes.y + 2 * toY computer.keyboard

            else
                shapes.y - 0.5

        angle =
            if computer.keyboard.up then
                shapes.angle + pi

            else
                shapes.angle
    in
    { x = x
    , y = y
    , angle = angle
    }
