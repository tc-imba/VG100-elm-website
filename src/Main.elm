module Main exposing (init, main, subscriptions)

import Browser exposing (UrlRequest)
import Browser.Navigation as Nav exposing (Key)
import Debug
import Dict exposing (..)
import Html exposing (..)
import Html.Attributes exposing (class, href)
import Material
import Material.Button as Button
import Material.Drawer.Dismissible as Drawer
import Material.LayoutGrid as LayoutGrid exposing (cell, span1Phone, span2Phone)
import Material.List as Lists
import Material.Options as Options exposing (cs, css, styled, when)
import Material.TopAppBar as TopAppBar
import Material.Typography as Typography
import Pages.Edit as Edit
import Pages.List as List
import Pages.Markdown as Markdown
import Routes exposing (Route)
import Shared exposing (..)
import Url exposing (Url)


type alias Model =
    { flags : Flags
    , navKey : Key
    , route : Route
    , page : Page
    , pageId : PageID
    , drawerOpen : Bool
    , mdc : Material.Model Msg
    }


type Page
    = PageNone
    | PageList List.Model
    | PageEdit Edit.Model
    | PageMarkdown Markdown.Model


type alias PageID =
    String


type PageConfig
    = PageConfig
        { title : String
        , href : String
        , data : String
        , children : List ( PageID, PageConfig )
        }


initPageConfig : String -> String -> String -> List ( PageID, PageConfig ) -> PageConfig
initPageConfig title href data children =
    PageConfig
        { title = title
        , href = href
        , data = data
        , children = children
        }


pageConfigDefault : PageConfig
pageConfigDefault =
    initPageConfig "Home" "/vg100" "home/index.md" []


markdownPrefix : String -> String
markdownPrefix name =
    "/vg100/markdown/" ++ name


pageConfigList : List ( PageID, PageConfig )
pageConfigList =
    [ ( "md.home", pageConfigDefault )
    , ( "md.env"
      , initPageConfig "Environment Setup"
            (markdownPrefix "env")
            "/env/index.md"
            [ ( "md.env.elm", initPageConfig "Elm Installation" (markdownPrefix "env.elm") "env/elm/index.md" [] )
            , ( "md.env.git", initPageConfig "Git" (markdownPrefix "env.git") "env/git/index.md" [] )
            , ( "md.env.redmine", initPageConfig "Redmine" (markdownPrefix "env.redmine") "env/redmine/index.md" [] )
            ]
      )
    , ( "md.ref"
      , initPageConfig "References"
            (markdownPrefix "ref")
            "env/ref/index.md"
            [ ( "md.ref.playground", initPageConfig "Elm Playground" (markdownPrefix "ref.playground") "ref/playground.md" [] )
            ]
      )
    , ( "md.p1", initPageConfig "Project 1" (markdownPrefix "p1") "p1/index.md" [] )
    , ( "md.p2", initPageConfig "Project 2" (markdownPrefix "p2") "p2/index.md" [] )
    ]


pageConfigDict : Dict PageID PageConfig
pageConfigDict =
    Dict.fromList (List.concat (List.map initPageConfigDict pageConfigList))


initPageConfigDict : ( PageID, PageConfig ) -> List ( PageID, PageConfig )
initPageConfigDict ( pageId, pageConfig ) =
    let
        p_ =
            case pageConfig of
                PageConfig p ->
                    p
    in
    [ ( pageId, pageConfig ) ] ++ List.concat (List.map initPageConfigDict p_.children)


type Msg
    = OnUrlChange Url
    | OnUrlRequest UrlRequest
    | ListMsg List.Msg
    | EditMsg Edit.Msg
    | MarkdownMsg Markdown.Msg
    | Mdc (Material.Msg Msg)
    | ToggleDrawer


init : Flags -> Url -> Key -> ( Model, Cmd Msg )
init flags url navKey =
    let
        model =
            { flags = flags
            , navKey = navKey
            , route = Routes.parseUrl url
            , page = PageNone
            , pageId = "none"
            , mdc = Material.defaultModel
            , drawerOpen = True
            }
    in
    ( model, Cmd.none )
        |> loadCurrentPage


loadCurrentPage : ( Model, Cmd Msg ) -> ( Model, Cmd Msg )
loadCurrentPage ( model, cmd ) =
    let
        ( page, pageId, newCmd ) =
            case model.route of
                Routes.PlayersRoute ->
                    let
                        ( pageModel, pageCmd ) =
                            List.init model.flags
                    in
                    ( PageList pageModel, "list", Cmd.map ListMsg pageCmd )

                Routes.PlayerRoute playerId ->
                    let
                        ( pageModel, pageCmd ) =
                            Edit.init model.flags playerId
                    in
                    ( PageEdit pageModel, "view", Cmd.map EditMsg pageCmd )

                Routes.MarkdownHomeRoute ->
                    let
                        pageId_ =
                            "md.home"

                        p_ =
                            case pageConfigDefault of
                                PageConfig p ->
                                    p

                        ( pageModel, pageCmd ) =
                            Markdown.init model.flags p_.data
                    in
                    ( PageMarkdown pageModel, pageId_, Cmd.map MarkdownMsg pageCmd )

                Routes.MarkdownRoute markdownName ->
                    let
                        pageId_ =
                            "md." ++ markdownName

                        pageConfig =
                            Maybe.withDefault pageConfigDefault (Dict.get pageId_ pageConfigDict)

                        p_ =
                            case pageConfig of
                                PageConfig p ->
                                    p

                        ( pageModel, pageCmd ) =
                            Markdown.init model.flags p_.data
                    in
                    ( PageMarkdown pageModel, pageId_, Cmd.map MarkdownMsg pageCmd )

                Routes.NotFoundRoute ->
                    ( PageNone, "none", Cmd.none )
    in
    ( { model | page = page, pageId = pageId }, Cmd.batch [ cmd, newCmd ] )


subscriptions : Model -> Sub Msg
subscriptions model =
    let
        pageSub =
            case model.page of
                PageList pageModel ->
                    Sub.map ListMsg (List.subscriptions pageModel)

                PageEdit pageModel ->
                    Sub.map EditMsg (Edit.subscriptions pageModel)

                PageMarkdown pageModel ->
                    Sub.map MarkdownMsg (Markdown.subscriptions pageModel)

                PageNone ->
                    Sub.none
    in
    Sub.batch [ Material.subscriptions Mdc model, pageSub ]


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case ( msg, model.page ) of
        ( Mdc msg_, _ ) ->
            Material.update Mdc msg_ model

        ( ToggleDrawer, _ ) ->
            ( { model | drawerOpen = not model.drawerOpen }, Cmd.none )

        ( OnUrlRequest urlRequest, _ ) ->
            case urlRequest of
                Browser.Internal url ->
                    ( model
                    , Nav.pushUrl model.navKey (Url.toString url)
                    )

                Browser.External url ->
                    ( model
                    , Nav.load url
                    )

        ( OnUrlChange url, _ ) ->
            let
                newRoute =
                    Routes.parseUrl url
            in
            ( { model | route = newRoute }, Cmd.none )
                |> loadCurrentPage

        ( ListMsg subMsg, PageList pageModel ) ->
            let
                ( newPageModel, newCmd ) =
                    List.update subMsg pageModel
            in
            ( { model | page = PageList newPageModel }
            , Cmd.map ListMsg newCmd
            )

        ( ListMsg subMsg, _ ) ->
            ( model, Cmd.none )

        ( EditMsg subMsg, PageEdit pageModel ) ->
            let
                ( newPageModel, newCmd ) =
                    Edit.update model.flags subMsg pageModel
            in
            ( { model | page = PageEdit newPageModel }
            , Cmd.map EditMsg newCmd
            )

        ( EditMsg subMsg, _ ) ->
            ( model, Cmd.none )

        ( MarkdownMsg subMsg, PageMarkdown pageModel ) ->
            let
                ( newPageModel, newCmd ) =
                    Markdown.update subMsg pageModel
            in
            ( { model | page = PageMarkdown newPageModel }
            , Cmd.map MarkdownMsg newCmd
            )

        ( MarkdownMsg subMsg, _ ) ->
            ( model, Cmd.none )


main : Program Flags Model Msg
main =
    Browser.application
        { init = init
        , view = view
        , update = update
        , subscriptions = subscriptions
        , onUrlRequest = OnUrlRequest
        , onUrlChange = OnUrlChange
        }



-- VIEWS


view : Model -> Browser.Document Msg
view model =
    { title = "App"
    , body = [ viewSkeleton model (currentPage model) ]
    }


currentPage : Model -> Html Msg
currentPage model =
    let
        page =
            case model.page of
                PageList pageModel ->
                    List.view pageModel
                        |> Html.map ListMsg

                PageEdit pageModel ->
                    Edit.view pageModel
                        |> Html.map EditMsg

                PageMarkdown pageModel ->
                    Markdown.view pageModel
                        |> Html.map MarkdownMsg

                PageNone ->
                    notFoundView
    in
    page


notFoundView : Html msg
notFoundView =
    div []
        [ text "Not found"
        ]


viewSkeleton : Model -> Html Msg -> Html Msg
viewSkeleton model html =
    styled Html.div
        [ cs "drawer-frame-root"
        , cs "mdc-typography"
        , css "display" "flex"
        , css "height" "100vh"
        ]
        [ viewDrawer model
        , styled Html.div
            [ Drawer.appContent
            , TopAppBar.fixedAdjust
            , Typography.typography
            , css "width" "100%"
            ]
            [ viewTopAppBar model, html ]
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
            , TopAppBar.title [] [ text "VG100 Elm Website" ]
            ]
        ]


viewDrawer : Model -> Html Msg
viewDrawer model =
    Drawer.view Mdc
        "my-drawer"
        model.mdc
        [ Drawer.open |> when model.drawerOpen
        , Drawer.onClose ToggleDrawer
        ]
        [ Drawer.header
            []
            [ styled h3 [ Drawer.title ] [ text "Contents" ]
            ]
        , Drawer.content []
            [ Lists.nav Mdc
                "my-drawer-list"
                model.mdc
                [ Lists.singleSelection, Lists.useActivated ]
                (List.concat (List.map (\p -> drawerLink model.pageId p 0) pageConfigList))
            ]
        ]


drawerLink : PageID -> ( PageID, PageConfig ) -> Int -> List (Lists.ListItem Msg)
drawerLink currentPageId ( pageId, pageConfig ) level =
    let
        p_ =
            case pageConfig of
                PageConfig p ->
                    p

        parent =
            Lists.a
                [ Options.attribute (href p_.href)
                , Lists.activated |> when (pageId == currentPageId)
                ]
                [ text p_.title ]

        hr =
            if level == 0 then
                [ Lists.hr [] [] ]

            else
                []

        children =
            List.concat (List.map (\p -> drawerLink currentPageId p (level + 1)) p_.children)
    in
    [ parent ] ++ children ++ hr
