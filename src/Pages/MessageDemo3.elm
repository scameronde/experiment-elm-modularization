module Pages.MessageDemo3 exposing (Model, Msg, init, update, view)

{-|
This version uses a component with its own update-view loop. The component communicates data to its
parent with the result of its update function.

# Advantages
- more encapsulation
- simple value passing

# Disadvantages
- none
-}

import Routes
import Domain.Title as Title exposing (Title)
import Views.MessageSenderReceiverComponentWithReturnValue as MSR
import Html exposing (Html)
import Html.Events as Event


type alias Model =
    { title : Title
    , modelFor1 : MSR.Model
    , modelFor2 : MSR.Model
    }


type Msg
    = MsgFor1 MSR.Msg
    | MsgFor2 MSR.Msg
    | Back


init : Title -> ( Model, Cmd Msg )
init title =
    ( Model title MSR.init MSR.init, Cmd.none )


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        MsgFor1 imsg ->
            ( updateWithMessageFor1 model imsg model.modelFor1 model.modelFor2, Cmd.none )

        MsgFor2 imsg ->
            ( updateWithMessageFor2 model imsg model.modelFor2 model.modelFor1, Cmd.none )

        Back ->
            ( model, Routes.modifyUrl (Routes.RouteToHome) )


type alias ModelSetter =
    Model -> MSR.Model -> MSR.Model -> Model


updateWithMessage : ModelSetter -> Model -> MSR.Msg -> MSR.Model -> MSR.Model -> Model
updateWithMessage setter model iMsgThis iModelThis iModelOther =
    let
        ( maybeMessage, newModelThis ) =
            MSR.update iMsgThis iModelThis

        newModelOther =
            case maybeMessage of
                Nothing ->
                    iModelOther

                Just message ->
                    MSR.updateReceived message iModelOther
    in
        setter model newModelThis newModelOther


updateWithMessageFor1 : Model -> MSR.Msg -> MSR.Model -> MSR.Model -> Model
updateWithMessageFor1 =
    updateWithMessage (\model this other -> { model | modelFor1 = this, modelFor2 = other })


updateWithMessageFor2 : Model -> MSR.Msg -> MSR.Model -> MSR.Model -> Model
updateWithMessageFor2 =
    updateWithMessage (\model this other -> { model | modelFor2 = this, modelFor1 = other })


view : Model -> Html Msg
view model =
    Html.div []
        [ Html.text <| Title.toString model.title
        , Html.map MsgFor1 (MSR.view model.modelFor1)
        , Html.map MsgFor2 (MSR.view model.modelFor2)
        , Html.button [ Event.onClick Back ] [ Html.text "Back" ]
        ]
