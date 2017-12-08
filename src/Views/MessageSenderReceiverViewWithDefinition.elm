module Views.MessageSenderReceiverViewWithDefinition exposing (Model, Msg(SendMessage), init, view, update, updateReceived)

import Domain.Message as Message exposing (Message)
import Html exposing (Html)
import Html.Events as Event


{-| the internal model. no details should leak outside.
-}
type alias Model =
    { received : Message
    , forSending : Message
    }


{-| only message used to communicate values up to a page should be exported.
-}
type Msg
    = -- used to pass value to Page
      SendMessage Message
      -- internally used
    | UpdateMessage Message


{-| must fully initialize the model
-}
init : Model
init =
    Model (Message.Message "") (Message.Message "")


{-| must handle all internal messages and do nothing for messages used to pass data to the page
-}
update : Msg -> Model -> Model
update msg model =
    case msg of
        UpdateMessage message ->
            { model | forSending = message }

        SendMessage message ->
            model


{-| one of many functions for accepting model changed from outside. remember: do not leak model information
-}
updateReceived : Model -> Message -> Model
updateReceived model message =
    { model | received = message }


{-| a regular view
-}
view : Model -> Html Msg
view model =
    Html.div []
        [ Html.text <| Message.toString model.received
        , Html.input [ Event.onInput <| Message.Message >> UpdateMessage ] []
        , Html.button [ Event.onClick <| SendMessage model.forSending ] [ Html.text "Send message" ]
        ]
