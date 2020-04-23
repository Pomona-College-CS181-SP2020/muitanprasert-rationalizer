module Parsing exposing (..)

import Parser exposing (..)
import Inflect exposing (pluralize, pascalize)

type alias Ingredient = { q : Maybe Float, unit : Maybe String, rest : String }

abbrevs =
  [ "g"
  , "kg"
  , "L"
  , "mL"
  , "tsp"
  , "tbsp"
  , "fl oz", "fl.oz", "fl. oz"
  , "oz"
  , "C"
  , "pt"
  , "qt"
  , "gal"
  , "pn"
  , "dr"
  ]

bases =
  [ "gram"
  , "kilogram"
  , "litre"
  , "millilitre"
  , "teaspoon"
  , "tablespoon"
  , "fluid ounce"
  , "ounce"
  , "cup"
  , "pint"
  , "quart"
  , "gallon"
  , "pinch"
  , "drop" ]

units : List (Parser ())
units = List.concatMap (
          \b -> [keyword (b++"."), keyword b, keyword (pascalize b)]
          ) abbrevs
     ++ List.concatMap (
          \b -> [keyword (pluralize b), keyword b]
          ) bases

type alias Frac = { num : Int, deno : Int }

fraction : Parser Float
fraction =
  Parser.map (\{num, deno} -> (toFloat num) / (toFloat deno))
    <| succeed Frac
        |= int
        |. symbol "/" --no space allowed between slash
        |= int

parseQuantity : Parser (Maybe Float)
parseQuantity =
    oneOf
        [ backtrackable ( succeed Just
            |. spaces
            |= float
            |. symbol " " --requires a space after quantity
            |. spaces )
        , backtrackable ( succeed Just
            |. spaces
            |= fraction
            |. symbol " " --requires a space after quantity
            |. spaces )
        , numWord
        , succeed Nothing
        ]

parseUnit : Parser (Maybe String)
parseUnit =
    oneOf
        [ succeed Just
            |. spaces
            |= (getChompedString <| oneOf units)
            |. spaces
        , succeed Nothing
        ]

parseRest : Parser String
parseRest = 
    getChompedString <| chompWhile (\c -> True)

parseLine : Parser Ingredient 
parseLine =
    succeed Ingredient
      |. spaces
      |= parseQuantity
      |= parseUnit
      |= parseRest

asIngredient : String -> Ingredient
asIngredient str = 
    case (run parseLine str) of
      Err _ -> {q=Nothing, unit=Nothing, rest=""} --no input should ever trigger this??
      Ok x -> x


--Number words parsing

ones = [("a", 0), ("one",1), ("two",2), ("three",3), ("four",4), ("five",5),
        ("six",6), ("seven",7), ("eight",8), ("nine",9), ("ten",10),
        ("eleven",11), ("twelve",12), ("thirteen",13), ("fourteen",14),
        ("fifteen",15), ("sixteen",16), ("seventeen",17), ("eighteen",18), ("nineteen",19)]

tens = [("ten",10), ("twenty",20), ("thirty",30), ("forty",40), ("fifty",50),
        ("sixty",60), ("seventy",70), ("eighty",80), ("ninety",90)]

multipliers = [("and", -1), ("hundred", -100), ("thousand", -1000),
               ("half", -0.5), ("quarter", -0.25)]

allNums : List (Parser Float)
allNums = List.concatMap (
              \(word, num) ->
                [ map (\_ -> num) (keyword word)
                , map (\_ -> num) (keyword (pascalize word))
                ]
              ) ( ones 
                  ++ tens
                  ++ multipliers )

numWord : Parser (Maybe Float)
numWord = 
  let
      ls = loop [] numWordHelp --Parser (List Float)
  in
      map calculate ls

calculate : List Float -> Maybe Float
calculate ls =
  case ls of
    [] -> Nothing
    (x::xs) -> 
      let
        val = calculateHelp 10000000 0 0 (x::xs)
      in
        if val < 0
        then Nothing
        else Just val

calculateHelp : Float -> Float -> Float -> List Float -> Float
calculateHelp bound prev cur rest =
    case rest of
      [] -> prev + cur
      (x::xs) ->
          if x == 0
          then calculateHelp bound prev 1 xs
          else
              if x < 0
              then
                let
                  chunk = cur*x*(-1)
                in
                  if chunk >= bound || (chunk == 0 && x < -1) --catch composite unit (e.g. hundred thousand)
                  then -10000000
                  else calculateHelp (min bound chunk) (prev+chunk) 0 xs
              else calculateHelp bound prev (cur+x) xs
      

numWordHelp : List Float -> Parser (Step (List Float) (List Float))
numWordHelp revNums =
  oneOf
    [ succeed (\n -> Loop (n :: revNums))
        |. spaces
        |= oneOf allNums
        |. spaces
    , succeed ()
        |> map (\_ -> Done (List.reverse revNums))
    ]