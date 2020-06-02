module Project exposing (Project, decoder, encode)

import Http
import Json.Decode as Decode
import Json.Encode as Encode
import Shared exposing (..)


type alias Project =
    { name: String
    , code: Int
    , author: String
    , stdout: Maybe String
    , stderr: Maybe String
    }


-- JSON


decoder : Decode.Decoder Project
decoder =
    Decode.map5 Project
        (Decode.field "name" Decode.string)
        (Decode.field "code" Decode.int)
        (Decode.field "author" Decode.string)
        (Decode.maybe (Decode.field "stdout" Decode.string))
        (Decode.maybe (Decode.field "stderr" Decode.string))


encode : Project -> Encode.Value
encode player =
    let
        attributes =
            [ ( "name", Encode.string player.name )
            , ( "code", Encode.int player.code )
            , ( "author", Encode.string player.author )
            , ( "stdout", Encode.string (player.stdout |> Maybe.withDefault "" ) )
            , ( "stderr", Encode.string (player.stderr |> Maybe.withDefault "" ) )
            ]
    in
    Encode.object attributes
