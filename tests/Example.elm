module Example exposing (..)

import Expect exposing (Expectation)
import Fuzz exposing (Fuzzer, int, list, string)
import Test exposing (..)
import Parsing exposing (Ingredient, asIngredient, numWord)
import Parser exposing (..)


numWord_1 : Test
numWord_1 = 
    test "1.5" <| \_ ->
        let
            input = "one and a half"
            output = Ok (Just 1.5)
        in
            Expect.equal (run numWord input) output

numWord_2 : Test
numWord_2 = 
    test "100 1000" <| \_ ->
        let
            input = "a hundred thousand"
            output = Ok (Nothing)
        in
            Expect.equal (run numWord input) output

numWord_3 : Test
numWord_3 = 
    test "122" <| \_ ->
        let
            input = "a hundred and twenty two"
            output = Ok (Just 122)
        in
            Expect.equal (run numWord input) output

full : Test
full =
    test "full" <| \_ ->
        let
            input = "10 tbsp. of butter"
            output = {q=Just 10, unit=Just "tbsp.", rest="of butter"}
        in
            Expect.equal (asIngredient input) output

no_unit : Test
no_unit =
    test "no unit" <| \_ ->
        let
            input = "2 .eggs"
            output = {q=Just 2, unit=Nothing, rest=".eggs"}
        in
            Expect.equal (asIngredient input) output

floating : Test
floating =
    test "floating" <| \_ ->
        let
            input = "2.5 cups  whole milk"
            output = {q=Just 2.5, unit=Just "cups", rest="whole milk"}
        in
            Expect.equal (asIngredient input) output

frac : Test
frac =
    test "fraction" <| \_ ->
        let
            input = " 2/5 cups  whole milk"
            output = {q=Just 0.4, unit=Just "cups", rest="whole milk"}
        in
            Expect.equal (asIngredient input) output

word : Test
word =
    test "word" <| \_ ->
        let
            input = " two and a half  cups  whole milk"
            output = {q=Just 2.5, unit=Just "cups", rest="whole milk"}
        in
            Expect.equal (asIngredient input) output

bad_number_1 : Test 
bad_number_1 =
    test "more than 1 decimal point: remove" <| \_ ->
        let
            input = "2.5.24  cups water"
            output = {q=Nothing, unit=Nothing, rest="2.5.24  cups water"}
        in
            Expect.equal (asIngredient input) output

bad_number_2 : Test 
bad_number_2 =
    test "more than 1 slash: remove" <| \_ ->
        let
            input = "2/5/24  cups water"
            output = {q=Nothing, unit=Nothing, rest="2/5/24  cups water"}
        in
            Expect.equal (asIngredient input) output

no_space : Test
no_space =
    test "no space" <| \_ ->
        let
            input = "20 tablespoons vanilla extract  "
            output = {q=Just 20, unit=Just "tablespoons", rest="vanilla extract  "}
        in
            Expect.equal (asIngredient input) output

no_trailing : Test --Should we allow this? Doesn't seem like it could be valid recipe.
no_trailing =
    test "no trailing" <| \_ ->
        let
            input = "10.2 litres"
            output = {q=Just 10.2, unit=Just "litres", rest=""}
        in
            Expect.equal (asIngredient input) output

no_number : Test
no_number =
    test "no number" <| \_ ->
        let
            input = "some salt"
            output = {q=Nothing, unit=Nothing, rest="some salt"}
        in
            Expect.equal (asIngredient input) output