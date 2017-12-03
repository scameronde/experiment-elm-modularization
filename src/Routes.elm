module Routes exposing (Route(..), fromLocation, href, modifyUrl)

import Domain.Title as Title exposing (Title)
import Html exposing (Attribute)
import Html.Attributes as Attr
import Navigation exposing (Location)
import UrlParser as Url exposing ((</>), Parser, oneOf, parseHash, s, string)


-- ROUTING --


type Route
    = RouteToHome
    | RouteToMessageDemo1 Title
    | RouteToMessageDemo2 Title
    | RouteToMessageDemo3 Title


homePath : String
homePath =
    ""


demo1Path : String
demo1Path =
    "demo1"


demo2Path : String
demo2Path =
    "demo2"


demo3Path : String
demo3Path =
    "demo3"


routeParser : Parser (Route -> a) a
routeParser =
    oneOf
        [ Url.map RouteToHome (s homePath)
        , Url.map RouteToMessageDemo1 (s demo1Path </> titleUrlParameterParser)
        , Url.map RouteToMessageDemo2 (s demo2Path </> titleUrlParameterParser)
        , Url.map RouteToMessageDemo3 (s demo3Path </> titleUrlParameterParser)
        ]


titleUrlParameterParser : Parser (Title -> a) a
titleUrlParameterParser =
    Url.custom "USERNAME" (Ok << Title.fromString)



-- INTERNAL --


routeToString : Route -> String
routeToString page =
    let
        pieces =
            case page of
                RouteToHome ->
                    []

                RouteToMessageDemo1 title ->
                    [ demo1Path, Title.toString title ]

                RouteToMessageDemo2 title ->
                    [ demo2Path, Title.toString title ]

                RouteToMessageDemo3 title ->
                    [ demo3Path, Title.toString title ]
    in
        "#/" ++ String.join "/" pieces



-- PUBLIC HELPERS --


href : Route -> Attribute msg
href route =
    Attr.href (routeToString route)


modifyUrl : Route -> Cmd msg
modifyUrl =
    routeToString >> Navigation.modifyUrl


fromLocation : Location -> Maybe Route
fromLocation location =
    if String.isEmpty location.hash then
        Just RouteToHome
    else
        parseHash routeParser location
