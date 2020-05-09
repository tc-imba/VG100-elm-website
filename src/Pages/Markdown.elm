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
    }


type Msg
    = OnFetchMarkdown (Result Http.Error String)
    | Mdc (Material.Msg Msg)


defaultModel : Model
defaultModel =
    { mdc = Material.defaultModel
    , markdown = ""
    }


init : Flags -> String -> ( Model, Cmd Msg )
init flags markdownName =
    ( defaultModel
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
    Http.getString (flags.api ++ "/api/markdown/" ++ markdownName ++ ".md")
        |> Http.send OnFetchMarkdown



-- VIEWS


view : Model -> Html Msg
view model =
    Html.div
        [ class "content" ]
        [ Markdown.toHtml [ class "markdown-body" ] model.markdown ]
