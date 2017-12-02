module Pages.Home exposing (Model, Msg, init, update, view)

import Domain.Title as Title exposing (Title)
import Html exposing (Html)
import Html.Events as Event
import Routes


type alias Record =
    { titleText : String }


type Model
    = Model Record


type Msg
    = SetTitle Title
    | UpdateTitle String


init : ( Model, Cmd Msg )
init =
    ( Model { titleText = "" }, Cmd.none )


update : Msg -> Model -> ( Model, Cmd Msg )
update msg (Model r) =
    case msg of
        SetTitle title ->
            ( Model r, Routes.modifyUrl (Routes.RouteToMessageDemo title) )

        UpdateTitle text ->
            ( Model { r | titleText = text }, Cmd.none )


view : Model -> Html Msg
view (Model r) =
    Html.div []
        [ Html.text "Home"
        , Html.input [ Event.onInput UpdateTitle ] []
        , Html.button [ Event.onClick (SetTitle <| Title.Title r.titleText) ] [ Html.text "Press me" ]
        ]
