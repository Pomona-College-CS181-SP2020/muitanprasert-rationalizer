module HomePage exposing (..)

import Browser
import Html exposing (Html, Attribute, button, div, text, node, span, label, input, textarea, h1, h3, p)
import Html.Attributes exposing (style, class, name, placeholder, for, attribute, id, step, value, type_, max, min, href, rel, lang)
import Html.Events exposing (..)
import Array exposing (..)
import String


-- MAIN


main =
  Browser.sandbox { init = init, update = update, view = view }



-- MODEL


type alias Model = 
  { content: Array String
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
  | ShowWarning (List String)

update : Msg -> Model -> Model
update action model =
  case action of
    UpdateContent s ->
        { model | temp = s }
    Submit ->
        let
            items = String.split "\n" model.temp
            m1 = update (ShowWarning items) model
            m2 = { m1 | content = Array.append m1.content (fromList items) }
        in
            update Clear m2
    Clear ->
        { model | temp = "" }
    Delete i ->
        { model | content = deleteAt i model.content }
    Scale v ->
        { model | scale = (String.toFloat v |> Maybe.withDefault 1) }
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

illegalInput : List String -> Bool
illegalInput = List.foldr (\x xs -> not (String.any Char.isDigit x) && xs) True


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
                              [ text "WARNING: Last recipe batch contains unquantified item(s)." ]
                            ]
                    False ->
                        div [ attribute "style" "width:500px;height:100px;" ] []
                , div [ class "slidecontainer" ]
                    [ span [ attribute "style" "width: 100%; display: block;font-family: Montserrat-SemiBold;font-size: 20px;color: #333333;line-height: 1.2;text-align: center;margin-bottom: 1em;" ]
                        [ text "How many servings?" ]
                    , input [ type_ "range", Html.Attributes.max "10", Html.Attributes.min "0", step "0.1", attribute "style" "width:80%; margin:0px auto; display:block;"
                            , value (String.fromFloat model.scale)
                            , onInput Scale ] []
                    , label [ attribute "style" "text-align: center; margin-top: 0.5em;"]
                        [ text (String.fromFloat model.scale) ]
                    ]
                ]
            , div [ class "contact100-more flex-col-c-m", attribute "style" "background-image: url('images/bg-02.jpg');" ]
                [ div [ attribute "style" "width:65%; height:80%; background-color: white; opacity: 0.8; padding: 2em; overflow:auto;" ]
                    [ div [] (Array.indexedMap viewButton model.content |> toList)
                    ]
                ]
            ]
        ]
        

viewButton : Int -> String -> Html Msg
viewButton i val =
    div [] [ button [ onDoubleClick (Delete i) ] [ text val ] ]