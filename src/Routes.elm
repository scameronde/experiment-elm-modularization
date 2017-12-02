module Routes exposing (Route(..), fromLocation, href, modifyUrl)

import Domain.Title as Title exposing (Title)
import Html exposing (Attribute)
import Html.Attributes as Attr
import Navigation exposing (Location)
import UrlParser as Url exposing ((</>), Parser, oneOf, parseHash, s, string)


-- ROUTING --


type Route
    = RouteToHome
    | RouteToMessageDemo Title


routeParser : Parser (Route -> a) a
routeParser =
    oneOf
        [ Url.map RouteToHome (s "")
        , Url.map RouteToMessageDemo (s "demo" </> titleUrlParameterParser)
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

                RouteToMessageDemo title ->
                    [ "demo", Title.toString title ]
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
