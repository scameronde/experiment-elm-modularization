module Pages.MessageDemo exposing (Model, Msg, init, update, view)

import Domain.Title as Title exposing (Title)
import Domain.Message as Message exposing (Message)
import Views.MessageSenderReceiver as MSR
import Html exposing (Html)


type alias Model =
    { title : Title
    , messageFor1 : Message
    , messageFor2 : Message
    , messageFrom1 : Message
    , messageFrom2 : Message
    }


type Msg
    = UpdateMessage1 Message
    | UpdateMessage2 Message
    | SendMessage1
    | SendMessage2


init : Title -> ( Model, Cmd Msg )
init title =
    ( Model title
        (Message.Message "")
        (Message.Message "")
        (Message.Message "")
        (Message.Message "")
    , Cmd.none
    )


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        UpdateMessage1 msg ->
            ( { model | messageFrom1 = msg }, Cmd.none )

        UpdateMessage2 msg ->
            ( { model | messageFrom2 = msg }, Cmd.none )

        SendMessage1 ->
            ( { model | messageFor2 = model.messageFrom1 }, Cmd.none )

        SendMessage2 ->
            ( { model | messageFor1 = model.messageFrom2 }, Cmd.none )


view : Model -> Html Msg
view model =
    Html.div []
        [ Html.text "Message-Demo"
        , Title.toHtml model.title
        , MSR.view model.messageFor1 UpdateMessage1 SendMessage1
        , MSR.view model.messageFor2 UpdateMessage2 SendMessage2
        ]
