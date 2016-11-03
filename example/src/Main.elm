module Main exposing (..)

import Html exposing (text, Html, div, span)
import Html.Attributes exposing (classList)
import Html.App as HA
import Greeting
import Task
import Process
import Time


type alias Model =
    { greeting : Greeting.Model
    , visible : Bool
    }


model : Model
model =
    { greeting = Greeting.model
    , visible = False
    }


init : ( Model, Cmd Msg )
init =
    let
        ( str, msg ) =
            Greeting.init
    in
        ( model, Cmd.batch [ Cmd.map GreetingMsg msg, delayVisibility ] )


type Msg
    = GreetingMsg Greeting.Msg
    | Visible Bool
    | NoOp ()


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        GreetingMsg subMsg ->
            let
                ( updatedGreetingModel, progressCmd ) =
                    Greeting.update subMsg model.greeting
            in
                ( { model | greeting = updatedGreetingModel }
                , Cmd.map GreetingMsg progressCmd
                )

        NoOp _ ->
            ( model, Cmd.none )

        Visible bool ->
            ( { model | visible = bool }, Cmd.none )


delayVisibility : Cmd Msg
delayVisibility =
    Task.perform NoOp Visible
        <| Process.sleep (1 * Time.second)
        `Task.andThen` \_ -> Task.succeed True


renderGreeting : Model -> Html Msg
renderGreeting model =
    HA.map GreetingMsg (Greeting.view model.greeting)


view : Model -> Html Msg
view model =
    div
        [ classList
            [ ( "app", True )
            , ( "visible", model.visible )
            ]
        ]
        [ renderGreeting model
        , span [] [ text ", how are you?" ]
        ]


main : Program Never
main =
    HA.program
        ({ init = init
         , view = view
         , update = update
         , subscriptions = \_ -> Sub.none
         }
        )
