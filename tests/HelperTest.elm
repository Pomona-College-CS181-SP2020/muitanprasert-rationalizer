module HelperTest exposing (..)

import Expect exposing (Expectation)
import Fuzz exposing (Fuzzer, int, list, string)
import Test exposing (..)
import HomePage exposing (..)

stringize_1 : Test
stringize_1 =
    test "stringize empty" <| \_ ->
        let
            input = {q=Nothing, unit=Nothing, rest=""} --Ingredient -> String
            output = "-"
        in
            Expect.equal (stringizeItem input) output

stringize_2 : Test
stringize_2 =
    test "stringize almost empty" <| \_ ->
        let
            input = {q=Nothing, unit=Nothing, rest="watermelon"} --Ingredient -> String
            output = "Some watermelon"
        in
            Expect.equal (stringizeItem input) output

stringize_3 : Test
stringize_3 =
    test "stringize unit only" <| \_ ->
        let
            input = {q=Nothing, unit=Just "tbsp.", rest="salt"} --Ingredient -> String
            output = "~ tbsp. salt"
        in
            Expect.equal (stringizeItem input) output

stringize_4 : Test
stringize_4 =
    test "stringize 1 coconut" <| \_ ->
        let
            input = {q=Just 1000, unit=Nothing, rest="coconut"} --Ingredient -> String
            output = "1 coconut"
        in
            Expect.equal (stringizeItem input) output

stringize_5 : Test
stringize_5 =
    test "stringize 2.5 coconuts" <| \_ ->
        let
            input = {q=Just 2500, unit=Nothing, rest="coconut"} --Ingredient -> String
            output = "3 coconuts (exact quantity: 2.5)"
        in
            Expect.equal (stringizeItem input) output

stringize_6 : Test
stringize_6 =
    test "stringize 10 coconuts" <| \_ ->
        let
            input = {q=Just 10000, unit=Nothing, rest="coconut"} --Ingredient -> String
            output = "10 coconuts"
        in
            Expect.equal (stringizeItem input) output

stringize_7 : Test
stringize_7 =
    test "stringize full" <| \_ ->
        let
            input = {q=Just 3120, unit=Just "ounce", rest="flour"} --Ingredient -> String
            output = "3.12 ounce flour"
        in
            Expect.equal (stringizeItem input) output


deleteAt_ : Test
deleteAt_ =
    describe "delete" --Int -> List a -> List a
        [ fuzz2 (list string) (Fuzz.intRange 0 50) "delete from list at index" <|
            \l id ->
                List.length (deleteAt id l)
                    |> Expect.equal (
                        if id >= List.length l
                        then List.length l
                        else max 0 (List.length l-1)
                    )
        ]

twoDecimal_ : Test
twoDecimal_ =
    test "round to two decimals" <| \_ ->
        let
            input = 2/3 --Float -> Float
            output = 0.67
        in
            twoDecimal input |> Expect.within (Expect.Absolute 0.000000001) output

ingredientize_ : Test
ingredientize_ =
    test "string to ingredient" <| \_ -> 
        let
            input = [ "1 cup Blanched almond flour"
                    , "1/4 Banana"
                    ] --List String -> List Ingredient
            output = [ {q=Just 1000, unit=Just "cup", rest="Blanched almond flour"}
                     , {q=Just 250, unit=Nothing, rest="Banana"}
                     ]
        in
            Expect.equal (ingredientize input) output
