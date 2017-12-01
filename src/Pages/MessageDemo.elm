module Pages.MessageDemo exposing (Model, Msg, init, update, view)

import Domain.Title as Title
import Domain.Message as Message
import Html exposing (Html)


type alias Model =
    { title : Title.Title
    , messageTo1 : Message.Message
    , messageTo2 : Message.Message
    , messageFrom1 : Message.Message
    , messageFrom2 : Message.Message
    }


type Msg
    = TitleSet Title.Title


init : Title.Title -> ( Model, Cmd Msg )
init title =
    ( Model title "" "" "" ""
    , Cmd.none
    )


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    ( model, Cmd.none )


view : Model -> Html Msg
view model =
    Html.div [] [ Html.text "Message-Demo" ]
