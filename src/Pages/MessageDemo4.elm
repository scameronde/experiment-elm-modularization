module Pages.MessageDemo4 exposing (Model, Msg, init, update, view)

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
import Focus exposing (Focus, set, get)
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
            ( updateModel model1Focus model2Focus imsg model, Cmd.none )

        MsgFor2 imsg ->
            ( updateModel model2Focus model1Focus imsg model, Cmd.none )

        Back ->
            ( model, Routes.modifyUrl (Routes.RouteToHome) )


type alias ModelSetter =
    Model -> MSR.Model -> MSR.Model -> Model


updateModel : Focus Model MSR.Model -> Focus Model MSR.Model -> MSR.Msg -> Model -> Model
updateModel sender receiver imsg model =
    let
        ( maybeMessage, newSender ) =
            MSR.update imsg (get sender model)

        newReceiver =
            case maybeMessage of
                Nothing ->
                    get receiver model

                Just message ->
                    MSR.updateReceived message (get receiver model)
    in
        set sender newSender model |> set receiver newReceiver


model1Focus : Focus { b | modelFor1 : a } a
model1Focus =
    Focus.create .modelFor1 (\f r -> { r | modelFor1 = f r.modelFor1 })


model2Focus : Focus { b | modelFor2 : a } a
model2Focus =
    Focus.create .modelFor2 (\f r -> { r | modelFor2 = f r.modelFor2 })


view : Model -> Html Msg
view model =
    Html.div []
        [ Html.text <| Title.toString model.title
        , Html.map MsgFor1 <| MSR.view model.modelFor1
        , Html.map MsgFor2 <| MSR.view model.modelFor2
        , Html.button [ Event.onClick Back ] [ Html.text "Back" ]
        ]
