module Pages.MessageDemo1 exposing (Model, Msg, init, update, view)

{-|
This version uses a view as a subcomponent. The view does not have its own definition
of state or message types. This has all to be provided by the page.

# Advantages
- simple view without need for complex logic

# Disadvantages
- a lot of shared internal knowledge between Page and View
-}

import Routes
import Domain.Title as Title exposing (Title)
import Domain.Message as Message exposing (Message)
import Views.MessageSenderReceiverViewOnly as MSR
import Html exposing (Html)
import Html.Events as Event


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
            updateForUpdate (\nm -> { model | modelFor1 = nm }) model.modelFor1 message

        MsgFor2 (UpdateMessage message) ->
            updateForUpdate (\nm -> { model | modelFor2 = nm }) model.modelFor2 message

        MsgFor1 SendMessage ->
            updateForSend (\nm -> { model | modelFor2 = nm }) model.modelFor2 model.modelFor1.forSending

        MsgFor2 SendMessage ->
            updateForSend (\nm -> { model | modelFor1 = nm }) model.modelFor1 model.modelFor2.forSending

        Back ->
            ( model, Routes.modifyUrl (Routes.RouteToHome) )


type alias SetterForUpdate =
    MSRModel -> Model


updateForUpdate : SetterForUpdate -> MSRModel -> Message -> ( Model, Cmd Msg )
updateForUpdate setter imodel message =
    let
        newIModel =
            { imodel | forSending = message }
    in
        ( setter newIModel, Cmd.none )


updateForSend : SetterForUpdate -> MSRModel -> Message -> ( Model, Cmd Msg )
updateForSend setter imodelother message =
    let
        newmodelother =
            { imodelother | received = message }
    in
        ( setter newmodelother, Cmd.none )


view : Model -> Html Msg
view model =
    Html.div []
        [ Html.text <| Title.toString model.title
        , MSR.view model.modelFor1.received (UpdateMessage >> MsgFor1) (SendMessage |> MsgFor1)
        , MSR.view model.modelFor2.received (UpdateMessage >> MsgFor2) (SendMessage |> MsgFor2)
        , Html.button [ Event.onClick Back ] [ Html.text "Back" ]
        ]
