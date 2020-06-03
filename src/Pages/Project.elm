module Pages.Project exposing (..)

import Html exposing (..)
import Html.Attributes exposing (class, href)
import Http
import Json.Decode as Decode
import Markdown
import Material
import Material.Button as Button
import Material.Card as Card
import Material.Dialog as Dialog
import Material.IconButton as IconButton
import Material.LayoutGrid as LayoutGrid
import Material.Options as Options exposing (css, styled, when)
import Material.Theme as Theme
import Material.Typography as Typography
import Ports exposing (openWindow)
import Process
import Project exposing (Project)
import Shared exposing (..)
import Task


type alias Model =
    { mdc : Material.Model Msg
    , flags : Flags
    , projectName : String
    , projects : List Project
    , currentProject : Maybe Project
    , dialogOpen : Bool
    }


type Msg
    = OnFetchProjectList (Result Http.Error (List Project))
    | OnBuildProject (Result Http.Error Project)
    | OnFetchProjectLog (Result Http.Error Project)
    | Mdc (Material.Msg Msg)
    | OnClickBuild String
    | OnClickLog String
    | OnRefreshLog String
    | OnClickPlay String
    | OnCloseDialog


defaultModel : Flags -> String -> Model
defaultModel flags projectName =
    { mdc = Material.defaultModel
    , flags = flags
    , projectName = projectName
    , projects = []
    , currentProject = Nothing
    , dialogOpen = False
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

        OnBuildProject (Ok project) ->
            ( { model | projects = updateProjects model.projects project, currentProject = Nothing, dialogOpen = True }
            , fetchProjectLog model.flags project.name
            )

        OnBuildProject (Err err) ->
            ( model, Cmd.none )

        OnFetchProjectLog (Ok project) ->
            ( { model | projects = updateProjects model.projects project, currentProject = Just project }
            , refreshBuilding project
            )

        OnFetchProjectLog (Err err) ->
            ( model, Cmd.none )

        OnClickBuild name ->
            ( model, buildProject model.flags name )

        OnClickLog name ->
            ( { model | currentProject = Nothing, dialogOpen = True }, fetchProjectLog model.flags name )

        OnRefreshLog name ->
            if (Maybe.withDefault Project.defaultProject model.currentProject).name == name then
                ( model, fetchProjectLog model.flags name )

            else
                ( model, Cmd.none )

        OnClickPlay name ->
            ( model, openWindow (model.flags.api ++ model.flags.prefix ++ "/demo/" ++ name ++ "/") )

        OnCloseDialog ->
            ( { model | dialogOpen = False }, Cmd.none )


updateProjects : List Project -> Project -> List Project
updateProjects projects project =
    let
        replace p =
            if p.name == project.name then
                project

            else
                p
    in
    List.map replace projects


refreshBuilding : Project -> Cmd Msg
refreshBuilding project =
    if project.status == "building" then
        Process.sleep 5000
            |> Task.andThen (always <| Task.succeed (OnRefreshLog project.name))
            |> Task.perform identity

    else
        Cmd.none



-- DATA


buildProject : Flags -> String -> Cmd Msg
buildProject flags name =
    Http.get (flags.api ++ flags.prefix ++ "/api/project/build/" ++ name) Project.decoder
        |> Http.send OnBuildProject


fetchProjectLog : Flags -> String -> Cmd Msg
fetchProjectLog flags name =
    Http.get (flags.api ++ flags.prefix ++ "/api/project/log/" ++ name) Project.decoder
        |> Http.send OnFetchProjectLog


fetchProjectList : Flags -> String -> Cmd Msg
fetchProjectList flags projectName =
    Http.get (flags.api ++ flags.prefix ++ "/api/project/list/" ++ projectName) (Decode.list Project.decoder)
        |> Http.send OnFetchProjectList



-- VIEW


view : Model -> Html Msg
view model =
    Html.div
        [ class "content" ]
        [ Html.div [ class "project-body" ]
            [ LayoutGrid.view []
                (List.map (\p -> viewProject model p) model.projects)
            , scrollableDialog model
            ]
        ]


viewProject : Model -> Project -> Html Msg
viewProject model project =
    LayoutGrid.cell
        [ LayoutGrid.span4Desktop, LayoutGrid.span6Tablet, LayoutGrid.alignMiddle ]
        [ Card.view
            []
            [ viewProjectTitle model project
            , viewProjectBody model project
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
            , css "margin" "0.1rem"
            , css "min-height" "3rem"
            ]
            [ text ("by " ++ project.author)
            ]
        ]


getColorByStatus : String -> String
getColorByStatus status =
    case status of
        "success" ->
            "#4BB543"

        "building" ->
            "#F5C330"

        "fail" ->
            "#f50000"

        _ ->
            "#000000"


viewProjectBody : Model -> Project -> Html Msg
viewProjectBody model project =
    styled Html.div
        [ css "padding" "0 1rem 0.5rem 1rem"
        , Typography.body2
        , Theme.textSecondaryOnBackground
        ]
        [ text "status: "
        , styled Html.span [ css "color" (getColorByStatus project.status) ] [ text project.status ]
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
                , Options.onClick (OnClickBuild project.name)
                ]
                [ text "Build"
                ]
            , Button.view Mdc
                (project.name ++ "-action-button-log")
                model.mdc
                [ Card.actionButton
                , Button.ripple
                , Options.onClick (OnClickLog project.name)
                ]
                [ text "Log"
                ]
            ]
        , Card.actionIcons []
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


scrollableDialog : Model -> Html Msg
scrollableDialog model =
    Dialog.view Mdc
        "dialog-log"
        model.mdc
        [ Dialog.open |> when (model.dialogOpen && model.currentProject /= Nothing)
        , Dialog.onClose OnCloseDialog
        ]
        (scrollableDialogBody model (model.currentProject |> Maybe.withDefault Project.defaultProject))


wrapOutputMarkdown : Maybe String -> Html Msg
wrapOutputMarkdown data =
    Markdown.toHtml [ class "markdown-body" ] ("```\n" ++ (data |> Maybe.withDefault "") ++ "```\n")


scrollableDialogBody : Model -> Project -> List (Html Msg)
scrollableDialogBody model project =
    let
        titleBase =
            "Building log of " ++ project.name

        title =
            if project.status == "building" then
                titleBase ++ " (refresh every 5 seconds)"

            else
                titleBase
    in
    [ styled Html.h2
        [ Dialog.title ]
        [ text title ]
    , Dialog.content
        [ Dialog.scrollable ]
        [ Html.h3 [] [ text "status: ", styled Html.span [ css "color" (getColorByStatus project.status) ] [ text project.status ] ]
        , Html.h3 [] [ text ("return code: " ++ String.fromInt project.code) ]
        , Html.h3 [] [ text "stdout" ]
        , Html.p []
            [ wrapOutputMarkdown project.stdout ]
        , Html.h3 [] [ text "stderr" ]
        , Html.p []
            [ wrapOutputMarkdown project.stderr ]
        ]
    ]
