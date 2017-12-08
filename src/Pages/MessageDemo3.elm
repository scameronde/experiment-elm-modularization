module Pages.MessageDemo3 exposing (Model, Msg, init, update, view)

{-|
This version is a hybrid between using only a simple view and a full fledged component. The
view defines its Model and Msg, but shares all its internals with the Page.

# Advantages
- still simple view without need for complex logic
- the definition of Model and Msg is where its usage is defined

# Disadvantages
- still a lot of shared internal knowledge between Page and View
-}

import Routes
import Domain.Title as Title exposing (Title)
import Views.MessageSenderReceiverViewWithDefinition as MSR
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
        -- handle message from view that is used to pass data
        MsgFor1 (MSR.SendMessage message) ->
            ( { model | modelFor2 = MSR.updateReceived model.modelFor2 message }, Cmd.none )

        -- handle message from view that is used to pass data
        MsgFor2 (MSR.SendMessage message) ->
            ( { model | modelFor1 = MSR.updateReceived model.modelFor1 message }, Cmd.none )

        -- handle all internal messages from view
        MsgFor1 msgFor1 ->
            ( { model | modelFor1 = MSR.update msgFor1 model.modelFor1 }, Cmd.none )

        -- handle all internal messages from view
        MsgFor2 msgFor2 ->
            ( { model | modelFor2 = MSR.update msgFor2 model.modelFor2 }, Cmd.none )

        Back ->
            ( model, Routes.modifyUrl (Routes.RouteToHome) )


view : Model -> Html Msg
view model =
    Html.div []
        [ Html.text <| Title.toString model.title
        , Html.map MsgFor1 <| MSR.view model.modelFor1
        , Html.map MsgFor2 <| MSR.view model.modelFor2
        , Html.button [ Event.onClick Back ] [ Html.text "Back" ]
        ]
