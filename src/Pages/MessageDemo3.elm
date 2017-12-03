module Pages.MessageDemo3 exposing (Model, Msg, init, update, view)

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
    let
        ( model1, cmd1 ) =
            MSR.init

        ( model2, cmd2 ) =
            MSR.init
    in
        ( Model title model1 model2, Cmd.batch [ Cmd.map MsgFor1 cmd1, Cmd.map MsgFor2 cmd2 ] )


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        MsgFor1 imsg ->
            updateWithMessageFor1 model imsg model.modelFor1 model.modelFor2

        MsgFor2 imsg ->
            updateWithMessageFor2 model imsg model.modelFor2 model.modelFor1

        Back ->
            ( model, Routes.modifyUrl (Routes.RouteToHome) )


type alias ModelSetter =
    Model -> MSR.Model -> MSR.Model -> Model


type alias CmdMapper =
    MSR.Msg -> Msg


updateWithMessage : ModelSetter -> CmdMapper -> Model -> MSR.Msg -> MSR.Model -> MSR.Model -> ( Model, Cmd Msg )
updateWithMessage setter cmdMapperThis model iMsgThis iModelThis iModelOther =
    let
        ( maybeMessage, ( newModelThis, newCmdThis ) ) =
            MSR.update iMsgThis iModelThis

        newModelOther =
            case maybeMessage of
                Nothing ->
                    iModelOther

                Just message ->
                    MSR.receiveMessage message iModelOther
    in
        ( setter model newModelThis newModelOther, Cmd.map cmdMapperThis newCmdThis )


updateWithMessageFor1 : Model -> MSR.Msg -> MSR.Model -> MSR.Model -> ( Model, Cmd Msg )
updateWithMessageFor1 =
    updateWithMessage (\model this other -> { model | modelFor1 = this, modelFor2 = other }) MsgFor1


updateWithMessageFor2 : Model -> MSR.Msg -> MSR.Model -> MSR.Model -> ( Model, Cmd Msg )
updateWithMessageFor2 =
    updateWithMessage (\model this other -> { model | modelFor2 = this, modelFor1 = other }) MsgFor2


view : Model -> Html Msg
view model =
    Html.div []
        [ Html.text <| Title.toString model.title
        , Html.map MsgFor1 (MSR.view model.modelFor1)
        , Html.map MsgFor2 (MSR.view model.modelFor2)
        , Html.button [ Event.onClick Back ] [ Html.text "Back" ]
        ]
