module Pages.List exposing (Model, Msg, init, subscriptions, update, view)

import Html exposing (..)
import Html.Attributes as Html exposing (class, href)
import Http
import Json.Decode as Decode
import Markdown
import Material
import Material.Button as Button
import Material.Drawer.Dismissible as Drawer
import Material.LayoutGrid as LayoutGrid exposing (cell, span1Phone, span2Phone)
import Material.List as Lists
import Material.Options as Options exposing (cs, css, styled, when)
import Material.Snackbar as Snackbar
import Material.TopAppBar as TopAppBar
import Player exposing (Player)
import Routes
import Shared exposing (..)


type alias Model =
    { players : RemoteData (List Player)
    , mdc : Material.Model Msg
    , drawer_open : Bool
    }


type Msg
    = OnFetchPlayers (Result Http.Error (List Player))
    | Mdc (Material.Msg Msg)
    | Click
    | ToggleDrawer


defaultModel : Model
defaultModel =
    { players = Loading
    , mdc = Material.defaultModel
    , drawer_open = False
    }


init : Flags -> ( Model, Cmd Msg )
init flags =
    ( defaultModel
    , Cmd.batch
        [ fetchPlayers flags
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

        Click ->
            ( model, Cmd.none )

        OnFetchPlayers (Ok players) ->
            ( { model | players = Loaded players }, Cmd.none )

        OnFetchPlayers (Err err) ->
            ( { model | players = Failure }, Cmd.none )

        ToggleDrawer ->
            ( { model | drawer_open = not model.drawer_open }, Cmd.none )



-- DATA


fetchPlayers : Flags -> Cmd Msg
fetchPlayers flags =
    Http.get (flags.api ++ "/players") (Decode.list Player.decoder)
        |> Http.send OnFetchPlayers



-- VIEWS


view : Model -> Html Msg
view model =
    viewMDC model



--section [ class "p-4" ]
--    [  ]


viewList : Model -> Html Msg
viewList model =
    case model.players of
        NotAsked ->
            text ""

        Loading ->
            text "Loading ..."

        Loaded players ->
            viewWithData model players

        Failure ->
            text "Error"


mdcontent : Html msg
mdcontent =
    Markdown.toHtml [ class "content" ] """

# Apple Pie Recipe

  1. Invent the universe.
  2. Bake an apple pie.

"""


viewMDC : Model -> Html Msg
viewMDC model =
    styled Html.div
        [ cs "drawer-frame-root"
        , cs "mdc-typography"
        , css "display" "flex"
        , css "height" "100vh"
        ]
        [ viewDrawer model

        --, Drawer.scrim [ Options.onClick CloseDrawer ] []
        , styled Html.div
            [ Drawer.appContent ]
            [ viewList model
            , viewTopAppBar model
            ]
        ]


viewTopAppBar : Model -> Html Msg
viewTopAppBar model =
    TopAppBar.view Mdc
        "my-top-app-bar"
        model.mdc
        []
        [ TopAppBar.section
            [ TopAppBar.alignStart ]
            [ TopAppBar.navigationIcon Mdc
                "my-top-app-bar--menu"
                model.mdc
                [ Options.onClick ToggleDrawer ]
                "menu"
            , TopAppBar.title [] [ text "Basic App Example" ]
            ]
        ]


viewDrawer : Model -> Html Msg
viewDrawer model =
    Drawer.view Mdc
        "my-drawer"
        model.mdc
        [ Drawer.open |> when model.drawer_open
        , Drawer.onClose ToggleDrawer
        ]
        [ Drawer.header
            []
            [ styled h3 [ Drawer.title ] [ text "A Header" ]
            ]
        , Drawer.content []
            [ Lists.nav Mdc
                "my-drawer-list"
                model.mdc
                []
                [ drawerLink "Dashboard"
                , drawerLink "My account"
                , Lists.hr [] []
                , drawerLink "Logout"
                ]
            ]
        ]


drawerLink : String -> Lists.ListItem Msg
drawerLink linkContent =
    Lists.a
        [ Options.attribute (href "#")
        , Lists.activated |> when isActive
        ]
        [ text linkContent ]


isActive : Bool
isActive =
    False


viewContent =
    div []
        [ h1 [] [ text "My content" ]
        , p [] [ text "My body text goes here." ]
        ]


viewSnackbar : Model -> Html Msg
viewSnackbar model =
    Snackbar.view Mdc "my-snackbar" model.mdc [] []


viewWithData : Model -> List Player -> Html Msg
viewWithData model players =
    table []
        [ thead []
            [ tr []
                [ th [ class "p-2" ] [ text "Id" ]
                , th [ class "p-2" ] [ text "Name" ]
                , th [ class "p-2" ] [ text "Level" ]
                , th [ class "p-2" ] [ text "Actions" ]
                ]
            ]
        , tbody [] (List.map (\p -> playerRow model p) players)
        ]


playerRow : Model -> Player -> Html Msg
playerRow model player =
    tr []
        [ td [ class "p-2" ] [ text player.id ]
        , td [ class "p-2" ] [ text player.name ]
        , td [ class "p-2" ] [ text (String.fromInt player.level) ]
        , td [ class "p-2" ]
            [ editBtn player ]
        , td [ class "p-2" ]
            [ mdcBtn model player ]
        ]


editBtn : Player -> Html.Html Msg
editBtn player =
    let
        path =
            Routes.playerPath player.id
    in
    a
        [ class "btn regular"
        , href path
        ]
        [ i [ class "fa fa-edit mr-1" ] [], text "Edit" ]


mdcBtn : Model -> Player -> Html.Html Msg
mdcBtn model player =
    Button.view Mdc
        ("my-button" ++ player.id)
        model.mdc
        [ Button.ripple
        , Options.onClick Click
        ]
        [ text "Click me!" ]
