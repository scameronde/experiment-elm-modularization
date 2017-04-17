module ProductNode exposing (..)

import Leaf2
import Leaf3
import Html exposing (..)


type alias Model =
    { leaf2Model : Leaf2.Model
    , leaf3Model : Leaf3.Model
    }


type Msg
    = Leaf2Msg Leaf2.Msg
    | Leaf3Msg Leaf3.Msg


init : String -> ( Model, Cmd Msg )
init aMessage =
    -- compose the initial model
    let
        ( leaf2Model, leaf2Cmd ) =
            Leaf2.init aMessage

        ( leaf3Model, leaf3Cmd ) =
            Leaf3.init aMessage
    in
        ( { leaf2Model = leaf2Model, leaf3Model = leaf3Model }
        , Cmd.batch [ Cmd.map Leaf2Msg leaf2Cmd, Cmd.map Leaf3Msg leaf3Cmd ]
        )


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        -- coordinate a message from Leaf2 to Leaf3
        Leaf2Msg (Leaf2.Send aMessage) ->
            let
                ( rmodel, rcmd ) =
                    Leaf3.update (Leaf3.Receive aMessage) model.leaf3Model
            in
                ( { model | leaf3Model = rmodel }, Cmd.map Leaf3Msg rcmd )

        -- coordinate a message from Leaf3 to Leaf2
        Leaf3Msg (Leaf3.Send aMessage) ->
            let
                ( rmodel, rcmd ) =
                    Leaf2.update (Leaf2.Receive aMessage) model.leaf2Model
            in
                ( { model | leaf2Model = rmodel }, Cmd.map Leaf2Msg rcmd )

        -- let Leaf2 handle it's other messages
        Leaf2Msg imsg ->
            let
                ( rmodel, rcmd ) =
                    Leaf2.update imsg model.leaf2Model
            in
                ( { model | leaf2Model = rmodel }, Cmd.map Leaf2Msg rcmd )

        -- let Leaf3 handle it's other messages
        Leaf3Msg imsg ->
            let
                ( rmodel, rcmd ) =
                    Leaf3.update imsg model.leaf3Model
            in
                ( { model | leaf3Model = rmodel }, Cmd.map Leaf3Msg rcmd )


view : Model -> Html Msg
view model =
    div []
        [ Html.map Leaf2Msg (Leaf2.view model.leaf2Model)
        , Html.map Leaf3Msg (Leaf3.view model.leaf3Model)
        ]


subscriptions : Model -> Sub Msg
subscriptions model =
    Sub.batch
        [ Sub.map Leaf2Msg (Leaf2.subscriptions model.leaf2Model)
        , Sub.map Leaf3Msg (Leaf3.subscriptions model.leaf3Model)
        ]
