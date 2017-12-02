module Views.ComplexMessageSenderReceiver exposing (Model, Msg(SendMessage), init, update, view, receiveMessage)

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


receiveMessage : Message -> Model -> Model
receiveMessage message (Model r) =
    Model { r | received = message }


view : Model -> Html Msg
view (Model r) =
    Html.div []
        [ Html.text <| Message.toString r.received
        , Html.input [ Event.onInput <| UpdateMessage << Message.Message ] []
        , Html.button [ Event.onClick <| SendMessage r.forSending ] [ Html.text "Send message" ]
        ]
