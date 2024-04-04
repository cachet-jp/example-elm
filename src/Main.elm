module Main exposing (..)

import Element exposing (..)
import Element.Background as Background
import Element.Border as Border
import Element.Font as Font
import Element.Region as Region
import Html exposing (Html)


headerColor : Color
headerColor =
    rgb255 204 204 204


footerColor : Color
footerColor =
    rgb255 204 204 204


sidebarColor : Color
sidebarColor =
    rgb255 229 229 229


borderColor : Color
borderColor =
    rgb255 153 153 153


smallFontSize : Int
smallFontSize =
    14


mediumFontSize : Int
mediumFontSize =
    16


largeFontSize : Int
largeFontSize =
    24


spacingValue : Int
spacingValue =
    24


loremIpsum : String
loremIpsum =
    """
    Lorem ipsum dolor sit amet, consectetur adipiscing elit.
    Fusce bibendum neque eget nunc mattis eu sollicitudin enim tincidunt.
    Vestibulum lacus tortor, ultricies id dignissim ac, bibendum in velit.
    """


mainHeading : Element msg
mainHeading =
    el
        [ Region.heading 1
        , Font.size largeFontSize
        , Font.bold
        , Font.center
        ]
        (text "Example Elm with elm-ui")


main : Html msg
main =
    layout [] <|
        column [ width fill, height fill ]
            [ header [] [ text "Header" ]
            , row [ width fill, height fill ]
                [ sidebar [ alignTop ] [ text "Left Sidebar" ]
                , mainContent []
                    [ mainHeading
                    , paragraph [ Font.size mediumFontSize ] [ text loremIpsum ]
                    ]
                , sidebar [ alignTop ] [ text "Right Sidebar" ]
                ]
            , footer [] [ text "Footer" ]
            ]


header : List (Attribute msg) -> List (Element msg) -> Element msg
header attrs children =
    row
        ([ width fill
         , height (px 60)
         , Background.color headerColor
         , Font.size largeFontSize
         , Font.center
         , Border.widthEach { bottom = 1, left = 0, right = 0, top = 0 }
         , Border.color borderColor
         ]
            ++ attrs
        )
        children


footer : List (Attribute msg) -> List (Element msg) -> Element msg
footer attrs children =
    row
        ([ width fill
         , height (px 60)
         , Background.color footerColor
         , Font.size smallFontSize
         , Font.center
         , Border.widthEach { top = 1, left = 0, right = 0, bottom = 0 }
         , Border.color borderColor
         ]
            ++ attrs
        )
        children


sidebar : List (Attribute msg) -> List (Element msg) -> Element msg
sidebar attrs children =
    column
        ([ width (fillPortion 1)
         , height fill
         , Background.color sidebarColor
         , padding spacingValue
         , Font.size mediumFontSize
         ]
            ++ attrs
        )
        children


mainContent : List (Attribute msg) -> List (Element msg) -> Element msg
mainContent attrs children =
    column
        ([ width (fillPortion 4)
         , height fill
         , padding spacingValue
         , spacing spacingValue
         , Region.mainContent
         ]
            ++ attrs
        )
        children
