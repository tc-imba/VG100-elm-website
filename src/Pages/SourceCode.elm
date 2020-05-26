module Pages.SourceCode exposing (..)

import Html exposing (..)
import Html.Attributes exposing (class, href)
import Http
import Markdown
import Material
import Regex exposing (..)
import Shared exposing (..)


type alias Model =
    { mdc : Material.Model Msg
    , src : String
    , flags : Flags
    , srcPath : String
    }


type Msg
    = OnFetchSourceCode (Result Http.Error String)
    | Mdc (Material.Msg Msg)


defaultModel : Flags -> String -> Model
defaultModel flags srcPath =
    { mdc = Material.defaultModel
    , src = ""
    , flags = flags
    , srcPath = srcPath
    }


init : Flags -> List String -> ( Model, Cmd Msg )
init flags srcArray =
    let
        srcPath =
            String.join "/" srcArray
    in
    ( defaultModel flags srcPath
    , Cmd.batch
        [ fetchSourceCode flags srcPath
        , Material.init Mdc
        ]
    )


subscriptions : Model -> Sub Msg
subscriptions model =
    Material.subscriptions Mdc model


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        Mdc msg_ ->
            Material.update Mdc msg_ model

        OnFetchSourceCode (Ok src) ->
            ( { model | src = src }, Cmd.none )

        OnFetchSourceCode (Err err) ->
            ( { model | src = "Sorry, Source Code not Found!" }, Cmd.none )



-- DATA


fetchSourceCode : Flags -> String -> Cmd Msg
fetchSourceCode flags srcPath =
    Http.getString (flags.api ++ flags.prefix ++ "/api/markdown/" ++ srcPath ++ "?v=" ++ flags.version.git)
        |> Http.send OnFetchSourceCode



-- VIEWS


extension : Regex
extension =
    Maybe.withDefault Regex.never <| Regex.fromString "\\.(\\w+)$"


getExtension : String -> String
getExtension filename =
    let
        match =
            Regex.find extension filename

        firstMatch =
            Maybe.withDefault (Regex.Match "" 0 0 []) <| List.head match

        firstSubMatch =
            Maybe.withDefault (Just "txt") <| List.head firstMatch.submatches

        result =
            Maybe.withDefault "txt" firstSubMatch
    in
    result


injectEnv : String -> Model -> String
injectEnv src model =
    "# " ++ model.srcPath ++ "\n```" ++ getExtension model.srcPath ++ "\n" ++ src ++ "\n```"


myOptions : Markdown.Options
myOptions =
    { githubFlavored = Just { tables = True, breaks = True }
    , defaultHighlighting = Nothing
    , sanitize = False
    , smartypants = True
    }


view : Model -> Html Msg
view model =
    Html.div
        [ class "content" ]
        [ Markdown.toHtmlWith
            myOptions
            [ class "markdown-body" ]
            (injectEnv model.src model)
        ]
