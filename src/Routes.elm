module Routes exposing (Route(..), markdownPath, parseUrl, playerPath, playersPath)

import Url exposing (Url)
import Url.Parser as Parser exposing (..)


type Route
    = PlayersRoute
    | PlayerRoute String
    | MarkdownHomeRoute
    | MarkdownRoute String
    | SourceCodeRoute (List String)
    | NotFoundRoute



-- We use recursion to generate "rest" for routing
-- However, the recursion of the Elm compiler 0.19 may have a bug here
-- If we don't use even/odd functions like this, it will cause an error
-- Reference: https://discourse.elm-lang.org/t/parse-the-rest-of-a-url/3478/2


rest : Parser.Parser (List String -> a) a
rest =
    restHelpE 10


restHelpO : Int -> Parser.Parser (List String -> a) a
restHelpO maxDepth =
    if maxDepth < 1 then
        Parser.map [] Parser.top

    else
        Parser.oneOf
            [ Parser.map [] Parser.top
            , Parser.map (\str li -> str :: li) (Parser.string </> restHelpE (maxDepth - 1))
            ]


restHelpE : Int -> Parser.Parser (List String -> a) a
restHelpE maxDepth =
    if maxDepth < 1 then
        Parser.map [] Parser.top

    else
        Parser.oneOf
            [ Parser.map [] Parser.top
            , Parser.map (\str li -> str :: li) (Parser.string </> restHelpO (maxDepth - 1))
            ]


matchers : Parser (Route -> a) a
matchers =
    oneOf
        [ map MarkdownHomeRoute (s "vg100" </> top)
        , map PlayerRoute (s "vg100" </> s "players" </> string)
        , map PlayersRoute (s "vg100" </> s "players")
        , map MarkdownHomeRoute (s "vg100" </> s "markdown")
        , map MarkdownRoute (s "vg100" </> s "markdown" </> string)
        , map SourceCodeRoute (s "vg100" </> s "src" </> rest)
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

        SourceCodeRoute array ->
            "/vg100/src/" ++ String.join "/" array

        NotFoundRoute ->
            "/vg100"


playersPath =
    pathFor PlayersRoute


playerPath id =
    pathFor (PlayerRoute id)


markdownPath name =
    pathFor (MarkdownRoute name)
