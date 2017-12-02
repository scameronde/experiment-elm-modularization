module Pages.MessageDemo2 exposing (Model, Msg, init, update, view)

import Domain.Title as Title exposing (Title)
import Domain.Message as Message exposing (Message)
import Views.ComplexMessageSenderReceiver as MSR
import Html exposing (Html)


type alias Model =
    { title : Title
    , modelFor1 : MSR.Model
    , modelFor2 : MSR.Model
    }


type Msg
    = MsgFor1 MSR.Msg
    | MsgFor2 MSR.Msg


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
        MsgFor1 (MSR.SendMessage message) ->
            let
                ( newModel, newCmd ) =
                    MSR.update (MSR.ReceiveMessage message) model.modelFor2
            in
                ( { model | modelFor2 = newModel }, Cmd.map MsgFor2 newCmd )

        MsgFor1 imsg ->
            let
                ( newModel, newCmd ) =
                    MSR.update imsg model.modelFor1
            in
                ( { model | modelFor1 = newModel }, Cmd.map MsgFor1 newCmd )

        MsgFor2 (MSR.SendMessage message) ->
            let
                ( newModel, newCmd ) =
                    MSR.update (MSR.ReceiveMessage message) model.modelFor1
            in
                ( { model | modelFor1 = newModel }, Cmd.map MsgFor1 newCmd )

        MsgFor2 imsg ->
            let
                ( newModel, newCmd ) =
                    MSR.update imsg model.modelFor2
            in
                ( { model | modelFor2 = newModel }, Cmd.map MsgFor2 newCmd )


view : Model -> Html Msg
view model =
    Html.div []
        [ Html.text <| Title.toString model.title
        , Html.map MsgFor1 (MSR.view model.modelFor1)
        , Html.map MsgFor2 (MSR.view model.modelFor2)
        ]