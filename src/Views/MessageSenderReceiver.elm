module Views.MessageSenderReceiver exposing (view)

import Domain.Message as Message exposing (Message)
import Html exposing (Html)
import Html.Events as Event


view : Message -> (Message -> msgT) -> msgT -> Html msgT
view received toUpdateMsg toSendMsg =
    Html.div []
        [ Html.text <| Message.toString received
        , Html.input [ Event.onInput <| toUpdateMsg << Message.Message ] []
        , Html.button [ Event.onClick toSendMsg ] [ Html.text "Send message" ]
        ]
