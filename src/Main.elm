module Main exposing (Msg(..), main, update, view)

import Browser
import Html exposing (Html, button, div, text)
import Html.Events exposing (onClick)


main : Program () Int Msg
main =
    Browser.element
        { init = \() -> ( 0, Cmd.none )
        , update = update
        , view = view
        , subscriptions = \_ -> Sub.none
        }


type Msg
    = Increment
    | Decrement


update msg model =
    case msg of
        Increment ->
            ( model + 1, Cmd.none )

        Decrement ->
            ( model - 1, Cmd.none )


view model =
    div []
        [ button [ onClick Decrement ] [ text "-" ]
        , div [] [ text (String.fromInt model) ]
        , button [ onClick Increment ] [ text "+" ]
        ]
