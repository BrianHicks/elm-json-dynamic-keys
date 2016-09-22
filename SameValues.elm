module SameValues exposing (..)

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
        "filling": "cherry",
        "goodWithIceCream": true,
        "madeBy": "my grandmother"
     },
     "odd": {
         "filling": "rocks, I think?",
         "goodWithIceCream": false,
         "madeBy": "maybe a five year old?"
     }
}
"""


main : Html msg
main =
    Decode.decodeString (Decode.dict pie) sample |> toString |> Html.text
