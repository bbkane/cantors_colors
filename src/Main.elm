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
    { width : Int, height : Int }


init : Model
init =
    Model 500 500



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


viewSvgNumbers : Model -> H.Html Msg
viewSvgNumbers model =
    let
        viewSvgNumber : Int -> Int -> Int -> S.Svg Msg
        viewSvgNumber x y num =
            S.text_
                [ Sa.x (String.fromInt x)
                , Sa.y (String.fromInt y)
                ]
                [ S.text (String.fromInt num) ]

        ps : List Pos
        ps =
            repeatedlyCompose nextPos (Pos 0 0 Right) 10

        ips : List ( Int, Pos )
        ips =
            List.indexedMap Tuple.pair ps

        sips : List (S.Svg Msg)
        sips =
            List.map (\ip -> viewSvgNumber (Tuple.second ip).x (Tuple.second ip).y (Tuple.first ip)) ips
    in
    S.svg
        [ Sa.width (String.fromInt model.width)
        , Sa.height (String.fromInt model.width)
        , Sa.viewBox "-1 -1 5 5"
        , Sa.style "font: 1px sans-serif"
        ]
        sips


viewRects : Model -> H.Html Msg
viewRects model =
    let
        getFillAndOpacity : Int -> Int -> List (S.Attribute msg)
        getFillAndOpacity x y =
            case y of
                0 ->
                    [ Sa.fill "red", Sa.fillOpacity "1" ]

                _ ->
                    -- TODO: this breaks if x > y!
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
            repeatedlyCompose nextPos (Pos 0 0 Right) 1000

        sps : List (S.Svg Msg)
        sps =
            List.map (\p -> viewRect p.x p.y) ps
    in
    S.svg
        [ Sa.width (String.fromInt model.width)
        , Sa.height (String.fromInt model.width)
        , Sa.viewBox "0 0 100 100"
        ]
        sps


viewText : Model -> H.Html Msg
viewText model =
    H.text <| Debug.toString <| repeatedlyCompose nextPos (Pos 0 0 Right) 10
