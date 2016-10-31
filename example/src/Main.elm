module Main exposing (..)

import Html exposing (text, Html, div)
import Html.Attributes exposing (class)
import Html.App as HA
import Greeting


type alias Model =
    { greeting : Greeting.Model
    }


model : Model
model =
    { greeting = Greeting.model
    }


init : ( Model, Cmd Msg )
init =
    let
        ( str, msg ) =
            Greeting.init
    in
        ( model, Cmd.map GreetingMsg msg )


type Msg
    = GreetingMsg Greeting.Msg


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


renderGreeting : Model -> Html Msg
renderGreeting model =
    HA.map GreetingMsg (Greeting.view model.greeting)


view : Model -> Html Msg
view model =
    div [ class "app" ]
        [ renderGreeting model
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
