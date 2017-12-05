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
    , received1 : Message
    , forSending1 : Message
    , received2 : Message
    , forSending2 : Message
    }


type MSRMsg
    = SendMessage
    | UpdateMessage Message


type Msg
    = SendMessage1
    | UpdateMessage1 Message
    | SendMessage2
    | UpdateMessage2 Message
    | Back


init : Title -> ( Model, Cmd Msg )
init title =
    ( Model title
        (Message.Message "")
        (Message.Message "")
        (Message.Message "")
        (Message.Message "")
    , Cmd.none
    )


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        UpdateMessage1 message ->
            ( { model | forSending1 = message }, Cmd.none )

        UpdateMessage2 message ->
            ( { model | forSending2 = message }, Cmd.none )

        SendMessage1 ->
            ( { model | received2 = model.forSending1 }, Cmd.none )

        SendMessage2 ->
            ( { model | received1 = model.forSending2 }, Cmd.none )

        Back ->
            ( model, Routes.modifyUrl (Routes.RouteToHome) )


view : Model -> Html Msg
view model =
    Html.div []
        [ Html.text <| Title.toString model.title
        , MSR.view model.received1 UpdateMessage1 SendMessage1
        , MSR.view model.received2 UpdateMessage2 SendMessage2
        , Html.button [ Event.onClick Back ] [ Html.text "Back" ]
        ]
