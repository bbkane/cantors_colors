module Main exposing (Model, Msg(..), init, main, update, view)

import Browser
import Debug
import Html as H
import Html.Attributes as Ha
import Html.Events exposing (onClick)
import Svg as S
import Svg.Attributes as Sa


main =
    Browser.sandbox { init = init, update = update, view = view }



-- TODO: subscribe to window size changes
-- Utils
-- -- Ratio


gcd : ( Int, Int ) -> Int
gcd ( a, b ) =
    if b == 0 then
        a

    else
        gcd ( b, modBy a b )


type NextPosDirection
    = Right
    | DownLeft
    | Down
    | UpRight


type alias Pos =
    { x : Int
    , y : Int
    , nextDir : NextPosDirection

    -- Nothing represents not initialized
    , isRepeatingFraction : Maybe Bool
    }


{-| TODO: test
-}
nextPos : Pos -> Pos
nextPos current =
    -- NOTE: this relies on an X+ to the right and Y+ to the down
    case current.nextDir of
        Right ->
            { current | x = current.x + 1, nextDir = DownLeft }

        DownLeft ->
            let
                newNextDir =
                    if current.x == 1 then
                        Down

                    else
                        DownLeft
            in
            { current | x = current.x - 1, y = current.y + 1, nextDir = newNextDir }

        Down ->
            { current | y = current.y + 1, nextDir = UpRight }

        UpRight ->
            let
                newNextDir =
                    if current.y == 1 then
                        Right

                    else
                        UpRight
            in
            { current | x = current.x + 1, y = current.y - 1, nextDir = newNextDir }


repeatedlyCompose : (a -> a) -> a -> Int -> List a
repeatedlyCompose func val timesLeft =
    repeatedlyComposeHelper func val (timesLeft - 1) [ val ]


repeatedlyComposeHelper : (a -> a) -> a -> Int -> List a -> List a
repeatedlyComposeHelper func val timesLeft acc =
    if timesLeft == 0 then
        acc

    else
        let
            nextVal =
                func val
        in
        repeatedlyComposeHelper func nextVal (timesLeft - 1) (List.append acc [ nextVal ])



-- MODEL


type alias Model =
    { numSquares : Int
    , diagramWidth : Int
    }


init : Model
init =
    Model 10000 900



-- UPDATE


type Msg
    = PlaceHolder


update : Msg -> Model -> Model
update msg model =
    case msg of
        PlaceHolder ->
            model



-- VIEW


view =
    viewRects


viewRects : Model -> H.Html Msg
viewRects model =
    let
        getFillAndOpacity : Int -> Int -> List (S.Attribute msg)
        getFillAndOpacity x y =
            case y of
                0 ->
                    [ Sa.fill "red", Sa.fillOpacity "1" ]

                _ ->
                    -- As x increases, opacity increases
                    [ Sa.fill "black", Sa.fillOpacity (String.fromFloat (toFloat x / (toFloat x + toFloat y))) ]

        viewRect : Int -> Int -> S.Svg Msg
        viewRect x y =
            S.rect
                (List.append
                    [ Sa.x (String.fromInt x)
                    , Sa.y (String.fromInt y)
                    , Sa.width "1"
                    , Sa.height "1"
                    ]
                    (getFillAndOpacity x y)
                )
                []

        ps : List Pos
        ps =
            repeatedlyCompose nextPos (Pos 0 0 Right Nothing) model.numSquares

        sps : List (S.Svg Msg)
        sps =
            List.map (\p -> viewRect p.x p.y) ps

        -- Get side length : See notebook pic for derivation...
        -- but numSquares is basically half the area of the enclosing diagram
        sideLength =
            String.fromInt <| ceiling (sqrt (toFloat model.numSquares * 2)) + 1
    in
    S.svg
        [ Sa.width <| String.fromInt model.diagramWidth
        , Sa.height <| String.fromInt model.diagramWidth
        , Sa.viewBox <| "0 0 " ++ sideLength ++ " " ++ sideLength
        ]
        sps
