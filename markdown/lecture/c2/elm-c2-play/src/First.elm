module First exposing (main)

import Playground exposing (Color, Screen, green, move, picture, rectangle, red)


main : Program () Screen ( Int, Int )
main =
    lshape red green


lshape : Color -> Color -> Program () Screen ( Int, Int )
lshape color1 color2 =
    picture
        [ rectangle color1 10 20
        , rectangle color2 20 10
            |> move 5 15
        ]
