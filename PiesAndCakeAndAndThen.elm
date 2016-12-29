module PiesAndCakeAndAndThen exposing (..)

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


type alias Cake =
    { flavor : String
    , forABirthday : Bool
    , madeBy : String
    }


type BakedGood
    = PieValue Pie
    | CakeValue Cake


pie : Decoder Pie
pie =
    decode Pie
        |> required "filling" Decode.string
        |> required "goodWithIceCream" Decode.bool
        |> required "madeBy" Decode.string


cake : Decoder Cake
cake =
    decode Cake
        |> required "flavor" Decode.string
        |> required "forABirthday" Decode.bool
        |> required "madeBy" Decode.string


bakedGood : Decoder BakedGood
bakedGood =
    let
        decoderBakedGood : String -> Decoder BakedGood
        decoderBakedGood tag =
            case tag of
                "pie" ->
                    Decode.map PieValue pie

                "cake" ->
                    Decode.map CakeValue cake

                _ ->
                    Decode.fail ("I only know how to decode pie and cake, not \"" ++ tag ++ "\"")
    in
        Decode.field "type" Decode.string |> Decode.andThen decoderBakedGood


sample : String
sample =
    """{
    "cherry": {
        "type": "pie",
        "filling": "cherries and love",
        "goodWithIceCream": true,
        "madeBy": "my grandmother"
     },
     "odd": {
         "type": "pie",
         "filling": "rocks, I think?",
         "goodWithIceCream": false,
         "madeBy": "a child, maybe?"
     },
     "super-chocolate": {
         "type": "cake",
         "flavor": "german chocolate with chocolate shavings",
         "forABirthday": false,
         "madeBy": "the charming bakery up the street"
     }
}
"""


main : Html msg
main =
    Decode.decodeString (Decode.dict bakedGood) sample |> toString |> Html.text



-- main gives the following result (formatted and included here for clarity)


result : Dict String BakedGood
result =
    Dict.fromList
        [ ( "cherry"
          , PieValue
                { filling = "cherries and love"
                , goodWithIceCream = True
                , madeBy = "my grandmother"
                }
          )
        , ( "odd"
          , PieValue
                { filling = "rocks, I think?"
                , goodWithIceCream = False
                , madeBy = "a child, maybe?"
                }
          )
        , ( "super-chocolate"
          , CakeValue
                { flavor = "german chocolate with chocolate shavings"
                , forABirthday = False
                , madeBy = "the charming bakery up the street"
                }
          )
        ]
