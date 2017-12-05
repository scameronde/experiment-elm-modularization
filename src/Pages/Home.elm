module Pages.Home exposing (Model, Msg, init, update, view)

import Domain.Title as Title exposing (Title)
import Html exposing (Html)
import Html.Events as Event
import Routes


type alias Model =
    { title : Title }


type Msg
    = GotoMessageDemo1
    | GotoMessageDemo2
    | GotoMessageDemo3
    | GotoMessageDemo4
    | GotoMessageDemo5
    | UpdateTitle Title


init : ( Model, Cmd Msg )
init =
    ( { title = Title.Title "" }, Cmd.none )


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        GotoMessageDemo1 ->
            ( model, Routes.modifyUrl (Routes.RouteToMessageDemo1 model.title) )

        GotoMessageDemo2 ->
            ( model, Routes.modifyUrl (Routes.RouteToMessageDemo2 model.title) )

        GotoMessageDemo3 ->
            ( model, Routes.modifyUrl (Routes.RouteToMessageDemo3 model.title) )

        GotoMessageDemo4 ->
            ( model, Routes.modifyUrl (Routes.RouteToMessageDemo4 model.title) )

        GotoMessageDemo5 ->
            ( model, Routes.modifyUrl (Routes.RouteToMessageDemo5 model.title) )

        UpdateTitle title ->
            ( { model | title = title }, Cmd.none )


view : Model -> Html Msg
view model =
    Html.div []
        [ Html.text "Home"
        , Html.input [ Event.onInput <| UpdateTitle << Title.Title ] []
        , Html.button [ Event.onClick GotoMessageDemo1 ] [ Html.text "GoTo Demo 1" ]
        , Html.button [ Event.onClick GotoMessageDemo2 ] [ Html.text "GoTo Demo 2" ]
        , Html.button [ Event.onClick GotoMessageDemo3 ] [ Html.text "GoTo Demo 3" ]
        , Html.button [ Event.onClick GotoMessageDemo4 ] [ Html.text "GoTo Demo 4" ]
        , Html.button [ Event.onClick GotoMessageDemo5 ] [ Html.text "GoTo Demo 5" ]
        ]
