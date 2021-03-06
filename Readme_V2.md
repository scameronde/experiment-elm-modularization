# Modularization of Elm UIs using Navigation

My first attempt of Elm UI modularization was meant for simple SPAs. It did not have routing using some kind of persistent URLs. In a large application this is absolutely necessary. To learn more about routing in Elm, I took the demo application from Feldmann and tried to extract the basic architecture. Here are my results.

## Basic building blocks

An application is divided into Pages. Each page can be directly navigated to using the browser URL. All context for a page - besides some global context like authentification information - must be provided as URL parameters.

How each page is divided further into smaller chunks is up to application itself. Feldmanns demo uses only Views, which do not have a model, messages or an update-render loop of their own. This seems to be the way NoRedInk is doing all their UIs. But there is no reason for not having a more complex model of how a page is designed.

### Routes

All possible routes for an application are defined in a top level module 'Routes'.

The module exposes a sum type with all possible routes. Each instance must contain all the necessary context passed along as URL parameters.

```elm
type Route
    = RouteToHome
    | RouteToMessageDemo Title.Title
```

It must expose those routes to main function that is responsible for the actual navigation:

```elm
module Routes exposing (Route(..))
```

It also provides a function for getting the correct route from a Location (a representation of the URL) ...

```elm
import UrlParser as Url exposing ((</>), Parser, oneOf, parseHash, s, string)

fromLocation : Location -> Maybe Route
fromLocation location =
    if String.isEmpty location.hash then
        Just RouteToHome
    else
        parseHash routeParser location

routeParser : Parser (Route -> a) a
routeParser =
    oneOf
        [ Url.map RouteToHome (s "")
        , Url.map RouteToMessageDemo (s "demo" </> titleUrlParameterParser)
        ]

titleUrlParameterParser : Parser (Title.Title -> a) a
titleUrlParameterParser =
    Url.custom "USERNAME" (Ok << Title.fromString)
```

... and a function to create a command for modifying the Location. This command is used to switch from one page to another.

```elm
import Navigation exposing (Location)

modifyUrl : Route -> Cmd msg
modifyUrl =
    routeToString >> Navigation.modifyUrl

routeToString : Route -> String
routeToString page =
    let
        pieces =
            case page of
                RouteToHome ->
                    []

                RouteToMessageDemo title ->
                    [ "demo", Title.toString title ]
    in
        "#/" ++ String.join "/" pieces
```

A third function converts a Route into a Html href that can be used for links.

```elm
href : Route -> Attribute msg
href route =
    Attr.href (routeToString route)
```

### Navigation

Defining Routes is good and fine, but it does not actuall do anything. For navigation using routes to work, the main event loop has to observe the location in the browser URL.

```elm
import Navigation exposing (Location)
import Routes exposing (Route)

type Msg
    = SetRoute (Maybe Route)
    | OtherMessages

main : Program Never Model Msg
main =
    Navigation.program (Routes.fromLocation >> SetRoute)
        { init = init
        , view = view
        , update = update
        , subscriptions = subscriptions
        }

```

Whenever the browser URL changes, the update function gets a message instance of `SetRoute (Maybe Route)`. The update function can use the passed information for setting the model and the view accordingly.

```elm
update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case ( msg, model ) of
        ( SetRoute maybeRoute, _ ) ->
            setRoute maybeRoute model

setRoute : Maybe Route -> Model -> ( Model, Cmd Msg )
setRoute maybeRoute model =
    case maybeRoute of
        Nothing ->
            -- do whatever is appropriate in your context
            ( model, Cmd.none )

        Just (Routes.RouteToHome) ->
            -- do whatever is appropriate in your context
            ( model, Cmd.none )

        Just (Routes.RouteToMessageDemo title) ->
            -- do whatever is appropriate in your context
            ( model, Cmd.none )
```

### Pages, Models and Messages

The concept of pages is analog to my concept of sum type components. Pages are handled exclusively, that means you can only display and handle one page at a time. A page is associated with an URL and vice versa.

Each page must supply the basic Elm buildingblocks:

```elm
module Pages.Home exposing (Model, Msg, init, update, view, subscriptions)
```

The main program must orchestrate the models and messages.

Let's start with the messages. For each page there has to be a wrapper message type:

```elm
type Msg
    = SetRoute (Maybe Route)
    | HomePageMsg Pages.Home.Msg
    | MessageDemoPageMsg Pages.MessageDemo.Msg
```

The same is true for the model:

```elm
type PageModel
    = BlankPageModel
    | HomePageModel Pages.Home.Model
    | MessageDemoPageModel Pages.MessageDemo.Model
```

The idea for the global model is, that it contains a global part and a part for the currently active page. So if a page is left, all its model data are destroyed and do not occupy memory.

```elm
type SessionModel
    = Session

type alias Model =
    { actualPage : PageModel
    , session : SessionModel
    }
```

Now for the orchestration of model initialization, updates and views.

Init:

```elm
init : Location -> ( Model, Cmd Msg )
init location =
    setRouteAccordingLocation location initialModel

setRouteAccordingLocation : Location -> Model -> ( Model, Cmd Msg )
setRouteAccordingLocation location model =
    -- see main function. this does effectively the same for the initialization
    setRoute (Routes.fromLocation location) model
```

And Update:

```elm
update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case ( msg, model.actualPage ) of
        ( SetRoute maybeRoute, _ ) ->
            setRoute maybeRoute model

        ( HomePageMsg homeMsg, HomePageModel homeModel ) ->
            let
                ( newModel, newCmd ) =
                    Pages.Home.update homeMsg homeModel
            in
                ( { model | actualPage = HomePageModel newModel }, Cmd.map HomePageMsg newCmd )

        ( MessageDemoPageMsg messageDemoMsg, MessageDemoPageModel messageDemoModel ) ->
            let
                ( newModel, newCmd ) =
                    Pages.MessageDemo.update messageDemoMsg messageDemoModel
            in
                ( { model | actualPage = MessageDemoPageModel newModel }, Cmd.map MessageDemoPageMsg newCmd )

        ( _, _ ) ->
            ( model, Cmd.none )
```

Or shorter and more elegant:

```elm
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
```

And View:

```elm
view : Model -> Html Msg
view model =
    case model.actualPage of
        BlankPageModel ->
            Html.div [] [ Html.text "Blank" ]

        HomePageModel homeModel ->
            Html.map HomePageMsg (Pages.Home.view homeModel)

        MessageDemoPageModel messageDemoModel ->
            Html.map MessageDemoPageMsg (Pages.MessageDemo.view messageDemoModel)
```

And that is basically it.

## Pages and Views

There are different ways a page can be composed of smaller elements. I want to explore some methods here.

- Variant 1: using a view function and a simple model
- Variant 2: using a view function and a nested model defined by the page
- Variant 3: using a view function and a nested model defined by the view
- Variant 4: using a component with a return value (using update)
- Variant 5: using a component with a return value passed by a message

So far variant 3 is my favorit for anything more complex than a button of a textfield.

My previous attempts to decompose a UI into components with the same interface (effectively
Pages in Pages in Pages) lead to unessessary code and deep message hierarchies. The update functions
got too complex. Another problem of this architecture of "independant components arranged into a deep hierarchy" is innefective data retrieval. Each component was responsible for the retrieval of its own data. This caused a lot of small requests to the server, sometimes querying the same data multiple times.

So my new architecture is Pages with Views. The Page is responsible for handling all the data for the current use case. It can use Views, which provide a Model, Messages, view, init and update functions. But the init and update function only return the model, they can not issue Cmds. Values to the View are passed from the Page to the view using the init function or a specialized updateXXX function. Values from View to Page are passed using a message.

### View

The following example shows a typical view.

```elm
module Views.MessageSenderReceiverViewWithDefinition exposing (Model, Msg(SendMessage), init, view, update, updateReceived)

import Domain.Message as Message exposing (Message)
import Html exposing (Html)
import Html.Events as Event


{-| the internal model. no details should leak outside.
-}
type alias Model =
    { received : Message
    , forSending : Message
    }


{-| only message used to communicate values up to a page should be exported.
-}
type Msg
    = -- used to pass value to Page
      SendMessage Message
      -- internally used
    | UpdateMessage Message


{-| must fully initialize the model
-}
init : Model
init =
    Model (Message.Message "") (Message.Message "")


{-| must handle all internal messages and do nothing for messages used to pass data to the page
-}
update : Msg -> Model -> Model
update msg model =
    case msg of
        UpdateMessage message ->
            { model | forSending = message }

        SendMessage message ->
            model


{-| one of many functions for accepting model changed from outside. remember: do not leak model information
-}
updateReceived : Model -> Message -> Model
updateReceived model message =
    { model | received = message }


{-| a regular view
-}
view : Model -> Html Msg
view model =
    Html.div []
        [ Html.text <| Message.toString model.received
        , Html.input [ Event.onInput <| Message.Message >> UpdateMessage ] []
        , Html.button [ Event.onClick <| SendMessage model.forSending ] [ Html.text "Send message" ]
        ]
```

### Page

The following example shows a typical page using two instances of the same view.

```elm
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


view : Model -> Html Msg
view model =
    Html.div []
        [ Html.text <| Title.toString model.title
        , Html.map MsgFor1 <| MSR.view model.modelFor1
        , Html.map MsgFor2 <| MSR.view model.modelFor2
        ]

```
