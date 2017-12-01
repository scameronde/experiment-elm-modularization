module Main exposing (main)

import Navigation exposing (Location)
import Pages.Home
import Pages.MessageDemo
import Routes exposing (Route)
import Html exposing (Html)


type SessionModel
    = Session


type PageModel
    = BlankPageModel
    | HomePageModel Pages.Home.Model
    | MessageDemoPageModel Pages.MessageDemo.Model


type alias Model =
    { actualPage : PageModel
    , session : SessionModel
    }


type Msg
    = SetRoute (Maybe Route)
    | HomePageMsg Pages.Home.Msg
    | MessageDemoPageMsg Pages.MessageDemo.Msg


init : Location -> ( Model, Cmd Msg )
init location =
    setRouteAccordingLocation location initialModel


initialModel : Model
initialModel =
    Model BlankPageModel Session


view : Model -> Html Msg
view model =
    case model.actualPage of
        BlankPageModel ->
            Html.div [] [ Html.text "Blank" ]

        HomePageModel homeModel ->
            Html.map HomePageMsg (Pages.Home.view homeModel)

        MessageDemoPageModel messageDemoModel ->
            Html.map MessageDemoPageMsg (Pages.MessageDemo.view messageDemoModel)


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case ( msg, model.actualPage ) of
        ( SetRoute maybeRoute, _ ) ->
            setRoute maybeRoute model

        ( HomePageMsg homeMsg, HomePageModel homeModel ) ->
            updatePage (Pages.Home.update homeMsg homeModel) HomePageModel HomePageMsg model

        ( MessageDemoPageMsg messageDemoMsg, MessageDemoPageModel messageDemoModel ) ->
            updatePage (Pages.MessageDemo.update messageDemoMsg messageDemoModel) MessageDemoPageModel MessageDemoPageMsg model

        ( _, _ ) ->
            ( model, Cmd.none )


updatePage : ( subModel, Cmd subMsg ) -> (subModel -> PageModel) -> (subMsg -> Msg) -> Model -> ( Model, Cmd Msg )
updatePage ( subModel, subCmd ) modelMapper messageMapper model =
    ( { model | actualPage = modelMapper subModel }, Cmd.map messageMapper subCmd )


subscriptions : Model -> Sub Msg
subscriptions model =
    Sub.none


main : Program Never Model Msg
main =
    Navigation.program (Routes.fromLocation >> SetRoute)
        { init = init
        , view = view
        , update = update
        , subscriptions = subscriptions
        }


setRouteAccordingLocation : Location -> Model -> ( Model, Cmd Msg )
setRouteAccordingLocation location model =
    setRoute (Routes.fromLocation location) model


setRoute : Maybe Route -> Model -> ( Model, Cmd Msg )
setRoute maybeRoute model =
    case maybeRoute of
        Nothing ->
            ( model, Cmd.none )

        Just (Routes.RouteToHome) ->
            let
                ( homeModel, homeCmd ) =
                    Pages.Home.init
            in
                ( { model | actualPage = HomePageModel homeModel }, Cmd.map HomePageMsg homeCmd )

        Just (Routes.RouteToMessageDemo title) ->
            let
                ( messageDemoModel, messageDemoCmd ) =
                    Pages.MessageDemo.init title
            in
                ( { model | actualPage = MessageDemoPageModel messageDemoModel }, Cmd.map MessageDemoPageMsg messageDemoCmd )
