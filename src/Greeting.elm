module Greeting exposing (..)

{-| Greeting functions and Msg.

# Model
@docs Model, init, model

# Message
@docs Msg

# Update function
@docs update

# View function
@docs view

# Main function
@docs main

# Common Helpers
@docs getGreeting, getRandomInt

# Static data
@docs greetings
-}

import Html exposing (text, Html, span)
import Html.Attributes exposing (class)
import Html.App as HA
import Random
import Array


{-| Model
-}
type alias Model =
    String


{-| The inital model
-}
model : Model
model =
    ""


{-| Init the app and generate a random Int
-}
init : ( Model, Cmd Msg )
init =
    ( model, getRandomInt (List.length greetings) )


{-| A list of availble greetings
-}
greetings : List String
greetings =
    [ "'Allo"
    , "'Allo 'Allo"
    , "Aye oop"
    , "Ay up"
    , "Ahoy"
    , "G'day"
    , "Greetings"
    , "Hello"
    , "Hey there"
    , "Hey"
    , "Hi there"
    , "Hi"
    , "Hiya"
    , "Howdy"
    , "Sup"
    , "What's up"
    , "Yo"
    ]


{-| Convert the greetings list to an array and retrieve a value
-}
getGreeting : Int -> String -> String
getGreeting num model =
    let
        arr =
            Array.fromList greetings
    in
        Array.get num arr
            |> Maybe.withDefault model


{-| Generate a Random int and send it to SetRandomInt
-}
getRandomInt : Int -> Cmd Msg
getRandomInt length =
    Random.generate SetRandomInt (Random.int 1 length)


{-| A union type representing The Elm Architect's `Msg`
-}
type Msg
    = SetRandomInt Int


{-| The Elm Architect's update function.
-}
update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        SetRandomInt int ->
            ( getGreeting int model, Cmd.none )


{-| Render a greeting element
-}
view : Model -> Html Msg
view model =
    span [ class "greeting" ]
        [ text model
        ]


{-| The Elm Architect's main function.
-}
main : Program Never
main =
    HA.program
        ({ init = init
         , view = view
         , update = update
         , subscriptions = \_ -> Sub.none
         }
        )
