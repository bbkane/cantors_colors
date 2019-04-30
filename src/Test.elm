module Main exposing (main)

import Debug
import Html
import Set


main =
    let
        s : Set.Set ( Int, Int )
        s =
            Set.singleton ( 1, 2 )

        sn =
            if Set.member ( 1, 2 ) s then
                s

            else
                Set.insert ( 1, 2 ) s
    in
    Html.text <| Debug.toString sn
