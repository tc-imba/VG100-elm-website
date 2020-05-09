module Routes exposing (Route(..), parseUrl, playerPath, playersPath, markdownPath)

import Url exposing (Url)
import Url.Parser exposing (..)


type Route
    = PlayersRoute
    | PlayerRoute String
    | MarkdownRoute String
    | NotFoundRoute


matchers : Parser (Route -> a) a
matchers =
    oneOf
        [ map PlayersRoute top
        , map PlayerRoute (s "players" </> string)
        , map PlayersRoute (s "players")
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
