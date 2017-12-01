module Pages.Home exposing (Model, Msg, init, update, view)

import Domain.Title as Title
import Html exposing (Html)
import Html.Events as Event
import Routes


type Model
    = Model


type Msg
    = TitleSet Title.Title


init : ( Model, Cmd Msg )
init =
    ( Model, Cmd.none )


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        TitleSet title ->
            ( model, Routes.modifyUrl (Routes.RouteToMessageDemo title) )


view : Model -> Html Msg
view model =
    Html.div []
        [ Html.text "Home"
        , Html.button [ Event.onClick (TitleSet (Title.Title "Zur Demo")) ] [ Html.text "Press me" ]
        ]
