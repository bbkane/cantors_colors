module Main exposing (Model, Msg(..), init, main, update, view)

import Browser
import Debug
import Html as H
import Html.Attributes as Ha
import Html.Events exposing (onClick)
import Set
import Svg as S
import Svg.Attributes as Sa


main =
    Browser.sandbox { init = init, update = update, view = view }



-- TODO: subscribe to window size changes
-- Utils
-- -- Ratio


type NextPosDirection
    = Right
    | DownLeft
    | Down
    | UpRight


type alias IsRepeatedFraction =
    Maybe Bool


type alias Pos =
    { x : Int
    , y : Int
    , nextDir : NextPosDirection

    -- Nothing represents not initialized
    , isRepeatedFraction : IsRepeatedFraction
    }


{-| Generate coordinates from an initial position and direction in a zigzag pattern
Initial direction shoudl be Right or Down
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


gcd : Int -> Int -> Int
gcd a b =
    if b == 0 then
        a

    else
        gcd b (remainderBy b a)



-- TODO: test this maybe


markRepeatedFractions : List Pos -> List Pos
markRepeatedFractions positions =
    markRepeatedFractionsHelper positions Set.empty []


markRepeatedFractionsHelper : List Pos -> Set.Set ( Int, Int ) -> List Pos -> List Pos
markRepeatedFractionsHelper positions seen acc =
    case positions of
        [] ->
            acc

        p :: ps ->
            -- Special case for 0s - insert singleton and mark repeated
            if p.x == 0 || p.y == 0 then
                markRepeatedFractionsHelper ps (Set.insert ( 0, 1 ) seen) (List.append [ { p | isRepeatedFraction = Just True } ] acc)

            else
                let
                    fgcd =
                        -- Debug.log "gcd" <| gcd (Debug.log "x" p.x) (Debug.log "y" p.y)
                        gcd p.x p.y

                    reduced =
                        ( p.x // fgcd, p.y // fgcd )
                in
                if Set.member reduced seen then
                    markRepeatedFractionsHelper ps seen (List.append [ { p | isRepeatedFraction = Just True } ] acc)

                else
                    markRepeatedFractionsHelper ps (Set.insert reduced seen) (List.append [ { p | isRepeatedFraction = Just False } ] acc)


makeListOfPositions : Int -> List Pos
makeListOfPositions numSquares =
    repeatedlyCompose nextPos (Pos 0 0 Right Nothing) numSquares |> markRepeatedFractions



-- MODEL


type alias Model =
    { numSquares : Int
    , diagramWidth : Int
    , positions : List Pos
    }


init : Model
init =
    let
        numSquares =
            5000

        diagramWidth =
            900
    in
    Model numSquares diagramWidth (makeListOfPositions numSquares)



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
        getFillAndOpacity : Int -> Int -> IsRepeatedFraction -> List (S.Attribute msg)
        getFillAndOpacity x y irf =
            if y == 0 then
                [ Sa.fill "red", Sa.fillOpacity "1" ]

            else if irf == Just True then
                [ Sa.fill "blue", Sa.fillOpacity "1" ]

            else
                -- As x increases, opacity increases
                [ Sa.fill "black", Sa.fillOpacity (String.fromFloat (toFloat x / (toFloat x + toFloat y))) ]

        viewRect : Int -> Int -> IsRepeatedFraction -> S.Svg Msg
        viewRect x y irf =
            S.rect
                (List.append
                    [ Sa.x (String.fromInt x)
                    , Sa.y (String.fromInt y)
                    , Sa.width "1"
                    , Sa.height "1"
                    ]
                    (getFillAndOpacity x y irf)
                )
                []

        sps : List (S.Svg Msg)
        sps =
            List.map (\p -> viewRect p.x p.y p.isRepeatedFraction) model.positions

        -- Get side length : See notebook pic for derivation
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
