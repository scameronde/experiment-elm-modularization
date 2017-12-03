module Views.MessageSenderReceiverComponentWithMsgs exposing (Model, Msg(SendMessage), init, update, view, receiveMessage)

import Domain.Message as Message exposing (Message)
import Html exposing (Html)
import Html.Events as Event


type alias Model =
    { received : Message
    , forSending : Message
    }


type Msg
    = SendMessage Message
    | UpdateMessage Message


init : ( Model, Cmd Msg )
init =
    ( Model (Message.Message "") (Message.Message ""), Cmd.none )


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        UpdateMessage message ->
            ( { model | forSending = message }, Cmd.none )

        SendMessage message ->
            -- cascade up
            ( model, Cmd.none )


receiveMessage : Message -> Model -> Model
receiveMessage message model =
    { model | received = message }


view : Model -> Html Msg
view model =
    Html.div []
        [ Html.text <| Message.toString model.received
        , Html.input [ Event.onInput <| UpdateMessage << Message.Message ] []
        , Html.button [ Event.onClick <| SendMessage model.forSending ] [ Html.text "Send message" ]
        ]
