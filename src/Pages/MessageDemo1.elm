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


type alias Model =
    { title : Title
    , messageFor1 : Message
    , messageFor2 : Message
    , messageFrom1 : Message
    , messageFrom2 : Message
    }


type Msg
    = UpdateMessage1 Message
    | UpdateMessage2 Message
    | SendMessage1
    | SendMessage2
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
        UpdateMessage1 msg ->
            ( { model | messageFrom1 = msg }, Cmd.none )

        UpdateMessage2 msg ->
            ( { model | messageFrom2 = msg }, Cmd.none )

        SendMessage1 ->
            ( { model | messageFor2 = model.messageFrom1 }, Cmd.none )

        SendMessage2 ->
            ( { model | messageFor1 = model.messageFrom2 }, Cmd.none )

        Back ->
            ( model, Routes.modifyUrl (Routes.RouteToHome) )


view : Model -> Html Msg
view model =
    Html.div []
        [ Html.text <| Title.toString model.title
        , MSR.view model.messageFor1 UpdateMessage1 SendMessage1
        , MSR.view model.messageFor2 UpdateMessage2 SendMessage2
        , Html.button [ Event.onClick Back ] [ Html.text "Back" ]
        ]
