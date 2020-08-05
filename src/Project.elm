module Project exposing (Project, decoder, encode, defaultProject)

import Http
import Json.Decode as Decode
import Json.Encode as Encode
import Shared exposing (..)


type alias Project =
    { name: String
    , code: Int
    , status: String
    , author: String
    , title: String
    , stdout: Maybe String
    , stderr: Maybe String
    }

defaultProject : Project
defaultProject =
    { name = "unknown"
    , code = -1
    , status = "fail"
    , author = "unknown"
    , title = "unknown"
    , stdout = Nothing
    , stderr = Nothing
    }

-- JSON


decoder : Decode.Decoder Project
decoder =
    Decode.map7 Project
        (Decode.field "name" Decode.string)
        (Decode.field "code" Decode.int)
        (Decode.field "status" Decode.string)
        (Decode.field "author" Decode.string)
        (Decode.field "title" Decode.string)
        (Decode.maybe (Decode.field "stdout" Decode.string))
        (Decode.maybe (Decode.field "stderr" Decode.string))


encode : Project -> Encode.Value
encode player =
    let
        attributes =
            [ ( "name", Encode.string player.name )
            , ( "code", Encode.int player.code )
            , ( "status", Encode.string player.status )
            , ( "author", Encode.string player.author )
            , ( "title", Encode.string player.title )
            , ( "stdout", Encode.string (player.stdout |> Maybe.withDefault "" ) )
            , ( "stderr", Encode.string (player.stderr |> Maybe.withDefault "" ) )
            ]
    in
    Encode.object attributes
