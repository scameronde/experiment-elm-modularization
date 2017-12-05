module Main exposing (main)

import Navigation exposing (Location)
import Pages.Home
import Pages.MessageDemo1
import Pages.MessageDemo2
import Pages.MessageDemo3
import Pages.MessageDemo4
import Pages.MessageDemo5
import Routes exposing (Route)
import Html exposing (Html)


type SessionModel
    = Session


type PageModel
    = BlankPageModel
    | HomePageModel Pages.Home.Model
    | MessageDemo1PageModel Pages.MessageDemo1.Model
    | MessageDemo2PageModel Pages.MessageDemo2.Model
    | MessageDemo3PageModel Pages.MessageDemo3.Model
    | MessageDemo4PageModel Pages.MessageDemo4.Model
    | MessageDemo5PageModel Pages.MessageDemo5.Model


type alias Model =
    { actualPage : PageModel
    , session : SessionModel
    }


type Msg
    = SetRoute (Maybe Route)
    | HomePageMsg Pages.Home.Msg
    | MessageDemo1PageMsg Pages.MessageDemo1.Msg
    | MessageDemo2PageMsg Pages.MessageDemo2.Msg
    | MessageDemo3PageMsg Pages.MessageDemo3.Msg
    | MessageDemo4PageMsg Pages.MessageDemo4.Msg
    | MessageDemo5PageMsg Pages.MessageDemo5.Msg


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

        MessageDemo1PageModel messageDemoModel ->
            Html.map MessageDemo1PageMsg (Pages.MessageDemo1.view messageDemoModel)

        MessageDemo2PageModel messageDemoModel ->
            Html.map MessageDemo2PageMsg (Pages.MessageDemo2.view messageDemoModel)

        MessageDemo3PageModel messageDemoModel ->
            Html.map MessageDemo3PageMsg (Pages.MessageDemo3.view messageDemoModel)

        MessageDemo4PageModel messageDemoModel ->
            Html.map MessageDemo4PageMsg (Pages.MessageDemo4.view messageDemoModel)

        MessageDemo5PageModel messageDemoModel ->
            Html.map MessageDemo5PageMsg (Pages.MessageDemo5.view messageDemoModel)


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case ( msg, model.actualPage ) of
        ( SetRoute maybeRoute, _ ) ->
            setRoute maybeRoute model

        ( HomePageMsg homeMsg, HomePageModel homeModel ) ->
            updatePage (Pages.Home.update homeMsg homeModel) HomePageModel HomePageMsg model

        ( HomePageMsg _, _ ) ->
            -- should not happen
            ( model, Cmd.none )

        ( MessageDemo1PageMsg messageDemoMsg, MessageDemo1PageModel messageDemoModel ) ->
            updatePage (Pages.MessageDemo1.update messageDemoMsg messageDemoModel) MessageDemo1PageModel MessageDemo1PageMsg model

        ( MessageDemo1PageMsg _, _ ) ->
            -- should not happen
            ( model, Cmd.none )

        ( MessageDemo2PageMsg messageDemoMsg, MessageDemo2PageModel messageDemoModel ) ->
            updatePage (Pages.MessageDemo2.update messageDemoMsg messageDemoModel) MessageDemo2PageModel MessageDemo2PageMsg model

        ( MessageDemo2PageMsg _, _ ) ->
            -- should not happen
            ( model, Cmd.none )

        ( MessageDemo3PageMsg messageDemoMsg, MessageDemo3PageModel messageDemoModel ) ->
            updatePage (Pages.MessageDemo3.update messageDemoMsg messageDemoModel) MessageDemo3PageModel MessageDemo3PageMsg model

        ( MessageDemo3PageMsg _, _ ) ->
            -- should not happen
            ( model, Cmd.none )

        ( MessageDemo4PageMsg messageDemoMsg, MessageDemo4PageModel messageDemoModel ) ->
            updatePage (Pages.MessageDemo4.update messageDemoMsg messageDemoModel) MessageDemo4PageModel MessageDemo4PageMsg model

        ( MessageDemo4PageMsg _, _ ) ->
            -- should not happen
            ( model, Cmd.none )

        ( MessageDemo5PageMsg messageDemoMsg, MessageDemo5PageModel messageDemoModel ) ->
            updatePage (Pages.MessageDemo5.update messageDemoMsg messageDemoModel) MessageDemo5PageModel MessageDemo5PageMsg model

        ( MessageDemo5PageMsg _, _ ) ->
            -- should not happen
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

        Just (Routes.RouteToMessageDemo1 title) ->
            let
                ( messageDemoModel, messageDemoCmd ) =
                    Pages.MessageDemo1.init title
            in
                ( { model | actualPage = MessageDemo1PageModel messageDemoModel }, Cmd.map MessageDemo1PageMsg messageDemoCmd )

        Just (Routes.RouteToMessageDemo2 title) ->
            let
                ( messageDemoModel, messageDemoCmd ) =
                    Pages.MessageDemo2.init title
            in
                ( { model | actualPage = MessageDemo2PageModel messageDemoModel }, Cmd.map MessageDemo2PageMsg messageDemoCmd )

        Just (Routes.RouteToMessageDemo3 title) ->
            let
                ( messageDemoModel, messageDemoCmd ) =
                    Pages.MessageDemo3.init title
            in
                ( { model | actualPage = MessageDemo3PageModel messageDemoModel }, Cmd.map MessageDemo3PageMsg messageDemoCmd )

        Just (Routes.RouteToMessageDemo4 title) ->
            let
                ( messageDemoModel, messageDemoCmd ) =
                    Pages.MessageDemo4.init title
            in
                ( { model | actualPage = MessageDemo4PageModel messageDemoModel }, Cmd.map MessageDemo4PageMsg messageDemoCmd )

        Just (Routes.RouteToMessageDemo5 title) ->
            let
                ( messageDemoModel, messageDemoCmd ) =
                    Pages.MessageDemo5.init title
            in
                ( { model | actualPage = MessageDemo5PageModel messageDemoModel }, Cmd.map MessageDemo5PageMsg messageDemoCmd )
