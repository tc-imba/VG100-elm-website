module Pages.Markdown exposing (..)

import Html exposing (..)
import Html.Attributes exposing (class, href)
import Http
import Markdown
import Material
import Shared exposing (..)


type alias Model =
    { mdc : Material.Model Msg
    , markdown : String
    , flags : Flags
    , markdownName : String
    }


type Msg
    = OnFetchMarkdown (Result Http.Error String)
    | Mdc (Material.Msg Msg)


defaultModel : Flags -> String -> Model
defaultModel flags markdownName =
    { mdc = Material.defaultModel
    , markdown = ""
    , flags = flags
    , markdownName = markdownName
    }


init : Flags -> String -> ( Model, Cmd Msg )
init flags markdownName =
    ( defaultModel flags markdownName
    , Cmd.batch
        [ fetchMarkdown flags markdownName
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

        OnFetchMarkdown (Ok markdown) ->
            ( { model | markdown = markdown }, Cmd.none )

        OnFetchMarkdown (Err err) ->
            ( { model | markdown = "# Sorry, Page not Exist!" }, Cmd.none )



-- DATA


fetchMarkdown : Flags -> String -> Cmd Msg
fetchMarkdown flags markdownName =
    Http.getString (flags.api ++ flags.prefix ++ "/api/markdown/" ++ markdownName ++ "?v=" ++ flags.version.git)
        |> Http.send OnFetchMarkdown



-- VIEWS


injectLinks : String -> Model -> String
injectLinks markdown model =
    -- this is dirty! fix it later!
    markdown
        |> String.replace "](./" ("](" ++ model.flags.api ++ model.flags.prefix ++ "/api/markdown/" ++ model.markdownName ++ "/../")
        --|> String.replace "href=\"./" ("href=\"" ++ model.api ++ "/api/markdown/" ++ model.markdownName ++ "/../")
        |> String.replace "(/demo/" ("(" ++ model.flags.api ++ model.flags.prefix ++ "/demo/")
        |> String.replace "(/src/" ("(" ++ model.flags.prefix ++ "/src/")


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
            (injectLinks model.markdown model)
        ]
