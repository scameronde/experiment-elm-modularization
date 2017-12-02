module Pages.Home exposing (Model, Msg, init, update, view)

import Domain.Title as Title exposing (Title)
import Html exposing (Html)
import Html.Events as Event
import Routes


type alias Record =
    { title : Title }


type Model
    = Model Record


type Msg
    = GotoMessageDemo1
    | GotoMessageDemo2
    | UpdateTitle Title


init : ( Model, Cmd Msg )
init =
    ( Model { title = Title.Title "" }, Cmd.none )


update : Msg -> Model -> ( Model, Cmd Msg )
update msg (Model r) =
    case msg of
        GotoMessageDemo1 ->
            ( Model r, Routes.modifyUrl (Routes.RouteToMessageDemo1 r.title) )

        GotoMessageDemo2 ->
            ( Model r, Routes.modifyUrl (Routes.RouteToMessageDemo2 r.title) )

        UpdateTitle title ->
            ( Model { r | title = title }, Cmd.none )


view : Model -> Html Msg
view (Model r) =
    Html.div []
        [ Html.text "Home"
        , Html.input [ Event.onInput <| UpdateTitle << Title.Title ] []
        , Html.button [ Event.onClick GotoMessageDemo1 ] [ Html.text "GoTo Demo 1" ]
        , Html.button [ Event.onClick GotoMessageDemo2 ] [ Html.text "GoTo Demo 2" ]
        ]
