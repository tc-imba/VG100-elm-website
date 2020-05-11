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
        [ map MarkdownHomeRoute top
        , map PlayerRoute (s "players" </> string)
        , map PlayersRoute (s "players")
        , map MarkdownHomeRoute (s "markdown")
        , map MarkdownRoute (s "markdown" </> string)
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
            "/players"

        PlayerRoute id ->
            "/players/" ++ id

        MarkdownHomeRoute ->
            "/"

        MarkdownRoute name ->
            "/markdown/" ++ name

        NotFoundRoute ->
            "/"


playersPath =
    pathFor PlayersRoute


playerPath id =
    pathFor (PlayerRoute id)


markdownPath name =
    pathFor (MarkdownRoute name)
