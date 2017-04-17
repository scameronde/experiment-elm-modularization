module SumNode exposing (..)

import Leaf1
import ProductNode
import Html exposing (..)


type Model
    = Leaf1Model Leaf1.Model
    | ProductNodeModel ProductNode.Model


type Msg
    = Leaf1Msg Leaf1.Msg
    | ProductNodeMsg ProductNode.Msg


init : ( Model, Cmd Msg )
init =
    -- start with Leaf1
    let
        ( leaf1Model, leaf1Cmd ) =
            Leaf1.init
    in
        ( Leaf1Model leaf1Model, Cmd.map Leaf1Msg leaf1Cmd )


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case ( msg, model ) of
        -- switch to ProductNode as result of a message from Leaf1
        ( Leaf1Msg (Leaf1.Exit aMessage), _ ) ->
            let
                ( rmodel, rcmd ) =
                    ProductNode.init aMessage
            in
                ( ProductNodeModel rmodel, Cmd.map ProductNodeMsg rcmd )

        -- let Leaf1 handle it's other messages
        ( Leaf1Msg imsg, Leaf1Model imodel ) ->
            let
                ( rmodel, rcmd ) =
                    Leaf1.update imsg imodel
            in
                ( Leaf1Model rmodel, Cmd.map Leaf1Msg rcmd )

        -- let ProductNode handle it's own messages
        ( ProductNodeMsg imsg, ProductNodeModel imodel ) ->
            let
                ( rmodel, rcmd ) =
                    ProductNode.update imsg imodel
            in
                ( ProductNodeModel rmodel, Cmd.map ProductNodeMsg rcmd )

        _ ->
            ( model, Cmd.none )


view : Model -> Html Msg
view model =
    case model of
        Leaf1Model imodel ->
            Html.map Leaf1Msg (Leaf1.view imodel)

        ProductNodeModel imodel ->
            Html.map ProductNodeMsg (ProductNode.view imodel)


subscriptions : Model -> Sub Msg
subscriptions model =
    case model of
        Leaf1Model imodel ->
            Sub.map Leaf1Msg (Leaf1.subscriptions imodel)

        ProductNodeModel imodel ->
            Sub.map ProductNodeMsg (ProductNode.subscriptions imodel)
