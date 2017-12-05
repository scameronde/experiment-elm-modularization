module Pages.MessageDemo2 exposing (Model, Msg, init, update, view)

{-|
This version uses a view as a subcomponent. The view does not have its own definition
of state or message types. This has all to be provided by the page.
This time, the page defines a submodel and submessages for the view to be a bit more structured.

# Advantages
- simple view without need for complex logic

# Disadvantages
- a lot of shared internal knowledge between Page and View
- increase of complexity in update function
-}

import Routes
import Domain.Title as Title exposing (Title)
import Domain.Message as Message exposing (Message)
import Views.MessageSenderReceiverViewOnly as MSR
import Html exposing (Html)
import Html.Events as Event
import Focus exposing (Focus, set, get, (=>))


type alias MSRModel =
    { received : Message
    , forSending : Message
    }


type alias Model =
    { title : Title
    , modelFor1 : MSRModel
    , modelFor2 : MSRModel
    }


type MSRMsg
    = SendMessage
    | UpdateMessage Message


type Msg
    = MsgFor1 MSRMsg
    | MsgFor2 MSRMsg
    | Back


init : Title -> ( Model, Cmd Msg )
init title =
    ( Model title
        (MSRModel (Message.Message "") (Message.Message ""))
        (MSRModel (Message.Message "") (Message.Message ""))
    , Cmd.none
    )


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        MsgFor1 (UpdateMessage message) ->
            ( set (modelFor1 => forSending) message model, Cmd.none )

        MsgFor2 (UpdateMessage message) ->
            ( set (modelFor2 => forSending) message model, Cmd.none )

        MsgFor1 SendMessage ->
            ( set (modelFor2 => received) model.modelFor1.forSending model, Cmd.none )

        MsgFor2 SendMessage ->
            ( set (modelFor1 => received) model.modelFor2.forSending model, Cmd.none )

        Back ->
            ( model, Routes.modifyUrl (Routes.RouteToHome) )


view : Model -> Html Msg
view model =
    Html.div []
        [ Html.text <| Title.toString model.title
        , MSR.view model.modelFor1.received (UpdateMessage >> MsgFor1) (SendMessage |> MsgFor1)
        , MSR.view model.modelFor2.received (UpdateMessage >> MsgFor2) (SendMessage |> MsgFor2)
        , Html.button [ Event.onClick Back ] [ Html.text "Back" ]
        ]



-- Foci


modelFor1 : Focus { b | modelFor1 : a } a
modelFor1 =
    Focus.create .modelFor1 (\f r -> { r | modelFor1 = f r.modelFor1 })


modelFor2 : Focus { b | modelFor2 : a } a
modelFor2 =
    Focus.create .modelFor2 (\f r -> { r | modelFor2 = f r.modelFor2 })


received : Focus { b | received : a } a
received =
    Focus.create .received (\f r -> { r | received = f r.received })


forSending : Focus { b | forSending : a } a
forSending =
    Focus.create .forSending (\f r -> { r | forSending = f r.forSending })
