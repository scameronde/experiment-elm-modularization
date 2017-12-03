module Views.MessageSenderReceiverViewWithDefinition exposing (Model, Msg(..), init, view, updateMessage, updateReceived)

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


init : Model
init =
    Model (Message.Message "") (Message.Message "")


updateMessage : Model -> Message -> Model
updateMessage model message =
    { model | forSending = message }


updateReceived : Model -> Message -> Model
updateReceived model message =
    { model | received = message }


view : Model -> Html Msg
view model =
    Html.div []
        [ Html.text <| Message.toString model.received
        , Html.input [ Event.onInput <| Message.Message >> UpdateMessage ] []
        , Html.button [ Event.onClick <| SendMessage model.forSending ] [ Html.text "Send message" ]
        ]
