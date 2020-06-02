module Pages.Project exposing (..)

import Html exposing (..)
import Html.Attributes exposing (class, href)
import Http
import Json.Decode as Decode
import Material
import Material.Button as Button
import Material.Card as Card
import Material.IconButton as IconButton
import Material.LayoutGrid as LayoutGrid
import Material.Options as Options exposing (css, styled)
import Material.Theme as Theme
import Material.Typography as Typography
import Project exposing (Project)
import Shared exposing (..)
import Ports exposing (openWindow)


type alias Model =
    { mdc : Material.Model Msg
    , flags : Flags
    , projectName : String
    , projects : List Project
    }


type Msg
    = OnFetchProjectList (Result Http.Error (List Project))
    | Mdc (Material.Msg Msg)
    | OnClickPlay String


defaultModel : Flags -> String -> Model
defaultModel flags projectName =
    { mdc = Material.defaultModel
    , flags = flags
    , projectName = projectName
    , projects = []
    }


init : Flags -> String -> ( Model, Cmd Msg )
init flags projectName =
    ( defaultModel flags projectName
    , Cmd.batch
        [ fetchProjectList flags projectName
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

        OnFetchProjectList (Ok projects) ->
            ( { model | projects = projects }, Cmd.none )

        OnFetchProjectList (Err err) ->
            ( { model | projects = [] }, Cmd.none )

        OnClickPlay name ->
            ( model , openWindow (model.flags.api ++ model.flags.prefix ++ "/demo/" ++ name ++ "/") )


-- DATA


fetchProjectList : Flags -> String -> Cmd Msg
fetchProjectList flags projectName =
    Http.get (flags.api ++ flags.prefix ++ "/api/project/list/" ++ projectName) (Decode.list Project.decoder)
        |> Http.send OnFetchProjectList


view : Model -> Html Msg
view model =
    Html.div
        [ class "content" ]
        [ LayoutGrid.view []
            (List.map (\p -> viewProject model p) model.projects)
        ]


viewProject : Model -> Project -> Html Msg
viewProject model project =
    LayoutGrid.cell
        [ LayoutGrid.span4Desktop, LayoutGrid.span6Tablet ]
        [ Card.view
            []
            [ viewProjectTitle model project
            , viewProjectButtons model project
            ]
        ]


viewProjectTitle : Model -> Project -> Html Msg
viewProjectTitle model project =
    styled Html.div
        [ css "padding" "1rem"
        ]
        [ styled Html.h2
            [ Typography.headline6
            , css "margin" "0"
            ]
            [ text project.name
            ]
        , styled Html.h3
            [ Typography.subtitle2
            , Theme.textSecondaryOnBackground
            , css "margin" "0"
            ]
            [ text ("by " ++ project.author)
            ]
        ]


viewProjectButtons : Model -> Project -> Html Msg
viewProjectButtons model project =
    Card.actions []
        [ Card.actionButtons []
            [ Button.view Mdc
                (project.name ++ "-action-button-build")
                model.mdc
                [ Card.actionButton
                , Button.ripple
                ]
                [ text "Build"
                ]
            , Button.view Mdc
                (project.name ++ "-action-button-log")
                model.mdc
                [ Card.actionButton
                , Button.ripple
                ]
                [ text "Log"
                ]
            ]
        , Card.actionIcons [ ]
            [ IconButton.view Mdc
                (project.name ++ "-action-icon-play")
                model.mdc
                [ Card.actionIcon
                , IconButton.icon { on = "sports_esports", off = "sports_esports" }
                , IconButton.label { on = "Play", off = "Play" }
                , Options.onClick (OnClickPlay project.name)
                ]
                []
            ]
        ]
