module Views.ComplexMessageSenderReceiver exposing (Model, Msg(SendMessage, ReceiveMessage), init, update, view)

import Domain.Message as Message exposing (Message)
import Html exposing (Html)
import Html.Events as Event


type alias Record =
    { received : Message
    , forSending : Message
    }


type Model
    = Model Record


type Msg
    = SendMessage Message
    | UpdateMessage Message
    | ReceiveMessage Message


init : ( Model, Cmd Msg )
init =
    ( Model (Record (Message.Message "") (Message.Message "")), Cmd.none )


update : Msg -> Model -> ( Model, Cmd Msg )
update msg (Model r) =
    case msg of
        UpdateMessage message ->
            ( Model { r | forSending = message }, Cmd.none )

        SendMessage message ->
            -- cascade up
            ( Model r, Cmd.none )

        ReceiveMessage message ->
            ( Model { r | received = message }, Cmd.none )


view : Model -> Html Msg
view (Model r) =
    Html.div []
        [ Html.text <| Message.toString r.received
        , Html.input [ Event.onInput <| UpdateMessage << Message.Message ] []
        , Html.button [ Event.onClick <| SendMessage r.forSending ] [ Html.text "Send message" ]
        ]
