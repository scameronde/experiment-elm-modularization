module Domain.Message exposing (..)

import Html exposing (Html)


type Message
    = Message String


toString : Message -> String
toString (Message message) =
    message


fromString : String -> Message
fromString message =
    Message message


toHtml : Message -> Html msg
toHtml (Message message) =
    Html.text message
