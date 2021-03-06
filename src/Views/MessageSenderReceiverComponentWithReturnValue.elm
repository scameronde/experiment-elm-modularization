module Views.MessageSenderReceiverComponentWithReturnValue exposing (Model, Msg, init, update, view, updateReceived)

import Domain.Message as Message exposing (Message)
import Html exposing (Html)
import Html.Events as Event


type alias Model =
    { received : Message
    , forSending : Message
    }


type Msg
    = SendMessage
    | UpdateMessage Message


init : Model
init =
    Model (Message.Message "") (Message.Message "")


update : Msg -> Model -> ( Maybe Message, Model )
update msg model =
    case msg of
        UpdateMessage message ->
            ( Nothing, { model | forSending = message } )

        SendMessage ->
            ( Just model.forSending, model )


updateReceived : Message -> Model -> Model
updateReceived message model =
    { model | received = message }


view : Model -> Html Msg
view model =
    Html.div []
        [ Html.text <| Message.toString model.received
        , Html.input [ Event.onInput <| Message.Message >> UpdateMessage ] []
        , Html.button [ Event.onClick <| SendMessage ] [ Html.text "Send message" ]
        ]
