module HomePage exposing (..)

import Browser
import Html exposing (Html, button, div, text, node, span, label, input, textarea, form)
import Html.Attributes exposing (class, name, placeholder, for, attribute, id, step, value, type_, max, min, href, rel, lang)
import Html.Events exposing (onClick)



-- MAIN


main =
  Browser.sandbox { init = init, update = update, view = view }



-- MODEL


type alias Model = Int


init : Model
init =
  0



-- UPDATE


type Msg
  = Increment
  | Decrement


update : Msg -> Model -> Model
update msg model =
  case msg of
    Increment ->
      model + 1

    Decrement ->
      model - 1



-- VIEW


view : Model -> Html Msg
view model =
  div [ class "main" ]
        [ div [ class "wrap-contact100" ]
            [ form [ class "contact100-form validate-form" ]
                [ span [ class "contact100-form-title" ]
                    [ text "Recipe Rationalizer				" ]
                , div [ class "wrap-input100 validate-input" ]
                    [ label [ class "label-input100", for "recipe" ]
                        [ text "Recipe:" ]
                    , textarea [ class "input100", id "message", name "recipe", placeholder "Enter to add a list of ingredients (1 ingredient per line)" ]
                        []
                    , span [ class "focus-input100" ]
                        []
                    ]
                , div [ class "container-contact100-form-btn" ]
                    [ button [ class "contact100-form-btn" ]
                        [ text "Add ingredient list to recipe" ]
                    ]
                , div [ attribute "style" "width:500px;height:100px;" ]
                    []
                , div [ class "slidecontainer" ]
                    [ span [ attribute "style" "width: 100%; display: block;font-family: Montserrat-SemiBold;font-size: 20px;color: #333333;line-height: 1.2;text-align: center;margin-bottom: 1em;" ]
                        [ text "How many servings?" ]
                    , input [ type_ "range", Html.Attributes.max "10", Html.Attributes.min "0", step "0.1", attribute "style" "width:80%; margin:0px auto; display:block;", value "1" ]
                        []
                    ]
                ]
            , div [ class "contact100-more flex-col-c-m", attribute "style" "background-image: url('images/bg-02.jpg');" ]
                [ div [ attribute "style" "width:65%;height:80%;background-color: white; opacity: 0.8; padding: 2em; overflow:auto;" ]
                    []
                ]
            ]     
        ]
    