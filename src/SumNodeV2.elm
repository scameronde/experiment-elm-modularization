module SumNodeV2 exposing (..)

import Leaf1
import ProductNodeV2 as ProductNode
import Model
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
    Model.map Leaf1Model Leaf1Msg Leaf1.init


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case ( msg, model ) of
        -- switch to ProductNode as result of a message from Leaf1
        ( Leaf1Msg (Leaf1.Exit aMessage), _ ) ->
            Model.map ProductNodeModel ProductNodeMsg (ProductNode.init aMessage)

        -- switch to Leaf1 as result of a message from ProductNode
        ( ProductNodeMsg (ProductNode.BackMsg _), ProductNodeModel imodel ) ->
            Model.map Leaf1Model Leaf1Msg (Leaf1.init)

        -- let Leaf1 handle it's other messages
        ( Leaf1Msg imsg, Leaf1Model imodel ) ->
            Model.map Leaf1Model Leaf1Msg (Leaf1.update imsg imodel)

        -- let ProductNode handle it's own messages
        ( ProductNodeMsg imsg, ProductNodeModel imodel ) ->
            Model.map ProductNodeModel ProductNodeMsg (ProductNode.update imsg imodel)

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
