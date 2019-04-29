module Main exposing (main)

import Html


type alias IsRepeatFraction =
    Maybe Bool


printBlah : IsRepeatFraction -> String
printBlah x =
    case x of
        Just b ->
            case b of
                True ->
                    "JT"

                False ->
                    "JF"

        Nothing ->
            "Not init"


printBlah2 : IsRepeatFraction -> String
printBlah2 x =
    case x of
        Just True ->
            "JT"

        Just False ->
            "JF"

        Nothing ->
            "Not init"


main =
    Html.text <| printBlah2 (Just True)
