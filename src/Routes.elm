module Routes exposing (Route(..), parseUrl, playerPath, playersPath, markdownPath)

import Url exposing (Url)
import Url.Parser exposing (..)


type Route
    = PlayersRoute
    | PlayerRoute String
    | MarkdownHomeRoute
    | MarkdownRoute String
    | NotFoundRoute


matchers : Parser (Route -> a) a
matchers =
    oneOf
        [ map MarkdownHomeRoute (s "vg100" </> top)
        , map PlayerRoute (s "vg100" </> s "players" </> string)
        , map PlayersRoute (s "vg100" </> s "players")
        , map MarkdownHomeRoute (s "vg100" </> s "markdown")
        , map MarkdownRoute (s "vg100" </> s "markdown" </> string)
        ]


parseUrl : Url -> Route
parseUrl url =
    case parse matchers url of
        Just route ->
            route

        Nothing ->
            NotFoundRoute


pathFor : Route -> String
pathFor route =
    case route of
        PlayersRoute ->
            "/vg100/players"

        PlayerRoute id ->
            "/vg100/players/" ++ id

        MarkdownHomeRoute ->
            "/vg100"

        MarkdownRoute name ->
            "/vg100/markdown/" ++ name

        NotFoundRoute ->
            "/vg100"


playersPath =
    pathFor PlayersRoute


playerPath id =
    pathFor (PlayerRoute id)


markdownPath name =
    pathFor (MarkdownRoute name)
