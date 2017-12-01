module Domain.Title exposing (..)

import Html exposing (Html)


type Title
    = Title String


toString : Title -> String
toString (Title title) =
    title


fromString : String -> Title
fromString str =
    Title str


toHtml : Title -> Html msg
toHtml (Title title) =
    Html.text title
