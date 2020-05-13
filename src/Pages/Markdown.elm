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
    , api : String
    , markdownName : String
    }


type Msg
    = OnFetchMarkdown (Result Http.Error String)
    | Mdc (Material.Msg Msg)


defaultModel : String -> String -> Model
defaultModel api markdownName =
    { mdc = Material.defaultModel
    , markdown = ""
    , api = api
    , markdownName = markdownName
    }


init : Flags -> String -> ( Model, Cmd Msg )
init flags markdownName =
    ( defaultModel flags.api markdownName
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
    Http.getString (flags.api ++ "/api/markdown/" ++ markdownName ++ "?v=" ++ flags.version)
        |> Http.send OnFetchMarkdown



-- VIEWS


injectLinks : String -> Model -> String
injectLinks markdown model =
    -- this is dirty! fix it later!
    String.replace "](./" ("](" ++ model.api ++ "/api/markdown/" ++ model.markdownName ++ "/../") markdown
        |> String.replace "(/demo/" ("(" ++ model.api ++ "/demo/")
        |> String.replace "href=\"/demo/" ("href=\"" ++ model.api ++ "/demo/")

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
