module HomePage exposing (..)

import Browser
import Html exposing (Html, Attribute, button, div, text, node, span, label, input, textarea, h1, h3, p)
import Html.Attributes exposing (style, class, name, placeholder, for, attribute, id, step, value, type_, max, min, href, rel, lang)
import Html.Events exposing (..)
import Array exposing (..)
import String
import Parsing exposing (Ingredient, asIngredient)
import Round
import Inflect exposing (pluralize, singularize)

-- MAIN


main =
  Browser.sandbox { init = init, update = update, view = view }



-- MODEL


type alias Model = 
  { content: Array Ingredient
  , temp: String
  , scale: Float
  , modalOn: Bool }


init : Model
init = 
  { content = Array.empty
  , temp = ""
  , scale = 1.0
  , modalOn = False }



-- UPDATE


type Msg
  = Submit
  | UpdateContent String
  | Clear
  | Delete Int
  | Scale String
  | ShowWarning (List Ingredient)

update : Msg -> Model -> Model
update action model =
  case action of
    UpdateContent s ->
        { model | temp = s }
    Submit ->
        let
            items = ingredientize (String.split "\n" model.temp)
            m1 = update (ShowWarning items) model
            m2 = { m1 | content = Array.append m1.content (fromList items) }
        in
            update Clear m2
    Clear ->
        { model | temp = "" }
    Delete i ->
        { model | content = deleteAt i model.content }
    Scale v ->
        let
            origScale = model.scale
            newScale = String.toFloat v |> Maybe.withDefault 1
        in
            { model | scale = newScale
                    , content = scaleContent (newScale/origScale) model.content }
    ShowWarning items ->
        if illegalInput items
        then { model | modalOn = True }
        else { model | modalOn = False }

deleteAt : Int -> Array a -> Array a
deleteAt i l =
  let
    front = Array.slice 0 i l
    back = Array.slice (i+1) (Array.length l) l
  in
    Array.append front back

scaleContent : Float -> Array Ingredient -> Array Ingredient
scaleContent scale = Array.map (\{q, unit, rest} ->
    case q of
      Nothing -> {q=q, unit=unit, rest=rest}
      Just a -> {q=Just (twoDecimal (a*scale)), unit=unit, rest=rest})

twoDecimal : Float -> Float
twoDecimal x = (Basics.toFloat (Basics.round (x*100)))/100

illegalInput : List Ingredient -> Bool
illegalInput = List.foldr (\x xs -> 
    x.q == Nothing
    || String.isEmpty x.rest
    || xs) False

ingredientize : List String -> List Ingredient
ingredientize = List.map (\str ->
    let
        {q, unit, rest} =  asIngredient str
    in
        case q of
            Nothing -> {q=Nothing, unit=unit, rest=rest}
            Just x -> {q=Just (x*1000), unit=unit, rest=rest} --keep quantity x1000 for precision
    )

stringize : Array Ingredient -> Array String
stringize l = Array.filter (\s -> not (String.isEmpty s))
    ( Array.map (\ {q,unit,rest} ->
        case (q,unit) of
        (Nothing, Nothing) -> rest
        (Nothing, Just u) -> u ++ " " ++ rest
        (Just a, Nothing) -> 
            let
                v = Round.ceiling 0 (a/1000)
                real = String.fromFloat (twoDecimal (a/1000))
            in
                if v == "1"
                then v ++ " " ++ (singularize rest) ++ " (use " ++ real ++ ")"
                else v ++ " " ++ (pluralize rest) ++ " (use " ++ real ++ ")"
        (Just a, Just u) -> (String.fromFloat (twoDecimal (a/1000))) ++ " " ++ u ++ " " ++ rest ) l )


-- VIEW

view : Model -> Html Msg
view model =
    div [ class "main" ]
        [ div [ class "wrap-contact100" ]
            [ div [ class "contact100-form validate-form" ]
                [ span [ class "contact100-form-title" ]
                    [ text "Recipe Rationalizer				" ]
                , div [ class "wrap-input100 validate-input" ]
                    [ label [ class "label-input100", for "recipe" ]
                        [ text "Recipe:" ]
                    , textarea [ class "input100", id "message", name "recipe"
                                , placeholder "Enter to add a list of ingredients (1 ingredient per line)"
                                , value model.temp
                                , onInput UpdateContent ]
                        []
                    , span [ class "focus-input100" ]
                        []
                    ]
                , div [ class "container-contact100-form-btn" ]
                    [ button [ class "contact100-form-btn", onClick Submit ]
                        [ text "Add ingredient list to recipe" ]
                    ]
                , case model.modalOn of
                    True ->
                        div [ attribute "style" "width:500px;height:100px;" ]
                            [ div [ attribute "style" "width:500px;height:10px;" ] []
                            , span [ attribute "style" "color: red;" ]
                              [ text "WARNING: Last recipe batch contains underspecified item(s)." ]
                            ]
                    False ->
                        div [ attribute "style" "width:500px;height:100px;" ] []
                , div [ class "slidecontainer" ]
                    [ span [ attribute "style" "width: 100%; display: block;font-family: Montserrat-SemiBold;font-size: 20px;color: #333333;line-height: 1.2;text-align: center;margin-bottom: 1em;" ]
                        [ text "How many servings?" ]
                    , input [ type_ "range", Html.Attributes.max "10", Html.Attributes.min "0.05", step "0.05", attribute "style" "width:80%; margin:0px auto; display:block;"
                            , value (String.fromFloat model.scale)
                            , onInput Scale ] []
                    , label [ attribute "style" "text-align: center; margin-top: 0.5em;"]
                        [ text (String.fromFloat model.scale) ]
                    ]
                ]
            , div [ class "contact100-more flex-col-c-m", attribute "style" "background-image: url('images/bg-02.jpg');" ]
                [ div [ attribute "style" "width:65%; height:80%; background-color: white; opacity: 0.8; padding: 2em; overflow:auto;" ]
                    [ div [] (Array.indexedMap viewButton (stringize model.content) |> toList)
                    ]
                ]
            ]
        ]
        

viewButton : Int -> String -> Html Msg
viewButton i val =
    div [] [ button [ onDoubleClick (Delete i) ] [ text val ] ]