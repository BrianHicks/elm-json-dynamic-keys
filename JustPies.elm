module JustPies exposing (..)

-- but this is just to show the result below

import Dict exposing (Dict)
import Html exposing (Html)
import Json.Decode as Decode exposing (Decoder)
import Json.Decode.Pipeline exposing (required, decode)


type alias Pie =
    { filling : String
    , goodWithIceCream : Bool
    , madeBy : String
    }


pie : Decoder Pie
pie =
    decode Pie
        |> required "filling" Decode.string
        |> required "goodWithIceCream" Decode.bool
        |> required "madeBy" Decode.string


sample : String
sample =
    """{
    "cherry": {
        "filling": "cherries and love",
        "goodWithIceCream": true,
        "madeBy": "my grandmother"
     },
     "odd": {
         "filling": "rocks, I think?",
         "goodWithIceCream": false,
         "madeBy": "a child, maybe?"
     }
}
"""


main : Html msg
main =
    Decode.decodeString (Decode.dict pie) sample |> toString |> Html.text



-- main gives the following result (formatted and included here for clarity)


result : Dict String Pie
result =
    Dict.fromList
        [ ( "cherry"
          , { filling = "cherries and love"
            , goodWithIceCream = True
            , madeBy = "my grandmother"
            }
          )
        , ( "odd"
          , { filling = "rocks, I think?"
            , goodWithIceCream = False
            , madeBy = "a child, maybe?"
            }
          )
        ]
