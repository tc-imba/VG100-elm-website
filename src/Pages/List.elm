module Pages.List exposing (Model, Msg, init, subscriptions, update, view)

import Html exposing (..)
import Html.Attributes exposing (class, href)
import Http
import Json.Decode as Decode
import Material
import Material.Button as Button
import Material.Options as Options
import Player exposing (Player)
import Routes
import Shared exposing (..)


type alias Model =
    { players : RemoteData (List Player)
    , mdc : Material.Model Msg
    }


type Msg
    = OnFetchPlayers (Result Http.Error (List Player))
    | Mdc (Material.Msg Msg)
    | Click


init : Flags -> ( Model, Cmd Msg )
init flags =
    ( { players = Loading, mdc = Material.defaultModel }, fetchPlayers flags )


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



-- DATA


fetchPlayers : Flags -> Cmd Msg
fetchPlayers flags =
    Http.get (flags.api ++ "/players") (Decode.list Player.decoder)
        |> Http.send OnFetchPlayers



-- VIEWS


view : Model -> Html Msg
view model =
    let
        content =
            case model.players of
                NotAsked ->
                    text ""

                Loading ->
                    text "Loading ..."

                Loaded players ->
                    viewWithData model players

                Failure ->
                    text "Error"
    in
    section [ class "p-4" ]
        [ content ]


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
