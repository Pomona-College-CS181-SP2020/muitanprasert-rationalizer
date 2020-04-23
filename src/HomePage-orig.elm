module HomePage-orig exposing (Model, Msg, initialModel, main, subscriptions, update, view)

import Array exposing (..)
import Browser
import DnDList
import Html exposing (Html, button, div, input, label,  span, text, textarea)
import Html.Attributes exposing (attribute, class, for, href, id, max, min, name, placeholder, step, type_, value)
import Html.Events exposing (..)
import Inflect exposing (pluralize, singularize)
import Parsing exposing (Ingredient, asIngredient)
import Round
import String



-- MAIN


main : Program () Model Msg
main =
    Browser.element
        { init = init
        , update = update
        , view = view
        , subscriptions = subscriptions
        }



-- MODEL


type alias Model =
    { content : List Ingredient
    , temp : String
    , scale : Float
    , warningText : String
    , dnd : DnDList.Model
    }


initialModel : Model
initialModel =
    { content = [ { q = Just 2500, unit = Just "cups", rest = "whole milk" } ]
    , temp = ""
    , scale = 1.0
    , warningText = ""
    , dnd = system.model
    }

init : () -> ( Model, Cmd Msg )
init _ =
    ( initialModel, Cmd.none )



-- SYSTEM


config : DnDList.Config Ingredient
config =
    { beforeUpdate = \_ _ list -> list
    , movement = DnDList.Free
    , listen = DnDList.OnDrag
    , operation = DnDList.Rotate
    }


system : DnDList.System Ingredient Msg
system =
    DnDList.create config MyMsg



-- SUBSCRIPTIONS


subscriptions : Model -> Sub Msg
subscriptions model =
    system.subscriptions model.dnd



-- UPDATE


type Msg
    = Submit
    | UpdateContent String
    | Clear
    | Delete Int
    | Scale String
    | ShowWarning (List Ingredient)
    | MyMsg DnDList.Msg


update : Msg -> Model -> ( Model, Cmd Msg )
update action model =
    case action of
        UpdateContent s ->
            ( { model | temp = s }, Cmd.none )

        Submit ->
            let
                items =
                    ingredientize (String.split "\n" model.temp)

                ( m1, _ ) =
                    update (ShowWarning items) model

                m2 =
                    { m1 | content = List.append m1.content items }
            in
            update Clear m2

        Clear ->
            ( { model | temp = "" }, Cmd.none )

        Delete i ->
            ( { model | content = deleteAt i model.content }, Cmd.none )

        Scale v ->
            let
                origScale =
                    model.scale

                newScale =
                    String.toFloat v |> Maybe.withDefault 1
            in
            ( { model
                | scale = newScale
                , content = scaleContent (newScale / origScale) model.content
              }
            , Cmd.none
            )

        ShowWarning items ->
            ( { model | warningText = illegalInput items }, Cmd.none )

        MyMsg msg ->
            let
                ( dnd, items ) =
                    system.update msg model.dnd model.content
            in
            ( { model | dnd = dnd, content = items }
            , system.commands dnd
            )


deleteAt : Int -> List a -> List a
deleteAt i l =
    let
        array =
            Array.fromList l

        front =
            Array.slice 0 i array

        back =
            Array.slice (i + 1) (length array) array
    in
    Array.toList (Array.append front back)


scaleContent : Float -> List Ingredient -> List Ingredient
scaleContent scale =
    List.map
        (\{ q, unit, rest } ->
            case q of
                Nothing ->
                    { q = q, unit = unit, rest = rest }

                Just a ->
                    { q = Just (twoDecimal (a * scale)), unit = unit, rest = rest }
        )


twoDecimal : Float -> Float
twoDecimal x =
    Basics.toFloat (Basics.round (x * 100)) / 100


illegalInput : List Ingredient -> String
illegalInput ls =
    let
        ingr =
            List.foldr (\x xs -> String.isEmpty x.rest || xs) False ls

        quan =
            List.foldr (\x xs -> x.q == Nothing || xs) False ls
    in
    case ( ingr, quan ) of
        ( True, False ) ->
            "Your last batch has underspecified items(s)."

        ( False, True ) ->
            "Your last batch contains unsupported quantity."

        ( True, True ) ->
            "Your last batch has illegal input(s)."

        ( False, False ) ->
            ""


ingredientize : List String -> List Ingredient
ingredientize =
    List.map
        (\str ->
            let
                { q, unit, rest } =
                    asIngredient str
            in
            case q of
                Nothing ->
                    { q = Nothing, unit = unit, rest = rest }

                Just x ->
                    { q = Just (x * 1000), unit = unit, rest = rest }
         --keep quantity x1000 for precision
        )


stringize : List Ingredient -> List String
stringize l =
    List.filter (\s -> not (String.isEmpty s))
        (List.map stringizeItem l)


stringizeItem : Ingredient -> String
stringizeItem { q, unit, rest } =
    case ( q, unit ) of
        ( Nothing, Nothing ) ->
            "Some " ++ rest

        ( Nothing, Just u ) ->
            "~" ++ u ++ " " ++ rest

        ( Just a, Nothing ) ->
            let
                v =
                    Round.ceiling 0 (a / 1000)

                real =
                    String.fromFloat (twoDecimal (a / 1000))
            in
            if v == "1" || rest == "" then
                v ++ " " ++ singularize rest ++ " (use " ++ real ++ ")"

            else
                v ++ " " ++ pluralize rest ++ " (use " ++ real ++ ")"

        ( Just a, Just u ) ->
            String.fromFloat (twoDecimal (a / 1000)) ++ " " ++ u ++ " " ++ rest



-- VIEW


view : Model -> Html Msg
view model =
    div [ class "main" ]
        [ div [ class "wrap-contact100" ]
            [ div [ class "contact100-form validate-form" ]
                [ span [ class "contact100-form-title" ]
                    [ text "Recipe Rationalizer\t\t\t\t" ]
                , div [ class "wrap-input100 validate-input" ]
                    [ label [ class "label-input100", for "recipe" ]
                        [ text "Recipe:" ]
                    , textarea
                        [ class "input100"
                        , id "message"
                        , name "recipe"
                        , placeholder "Enter to add a list of ingredients (1 ingredient per line)"
                        , value model.temp
                        , onInput UpdateContent
                        ]
                        []
                    , span [ class "focus-input100" ]
                        []
                    ]
                , div [ class "container-contact100-form-btn" ]
                    [ button [ class "contact100-form-btn", onClick Submit ]
                        [ text "Add ingredient list to recipe" ]
                    ]
                , div [ attribute "style" "width:500px;height:100px;" ]
                    [ div [ attribute "style" "width:500px;height:10px;" ] []
                    , span [ attribute "style" "color: red;" ]
                        [ text model.warningText ]
                    ]
                , div [ class "slidecontainer" ]
                    [ span [ attribute "style" "width: 100%; display: block;font-family: Montserrat-SemiBold;font-size: 20px;color: #333333;line-height: 1.2;text-align: center;margin-bottom: 1em;" ]
                        [ text "How many servings?" ]
                    , input
                        [ type_ "range"
                        , Html.Attributes.max "10"
                        , Html.Attributes.min "0.05"
                        , step "0.05"
                        , attribute "style" "width:80%; margin:0px auto; display:block;"
                        , value (String.fromFloat model.scale)
                        , onInput Scale
                        ]
                        []
                    , label [ attribute "style" "text-align: center; margin-top: 0.5em;" ]
                        [ text (String.fromFloat model.scale) ]
                    ]
                ]
            , div [ class "contact100-more flex-col-c-m", attribute "style" "background-image: url('images/bg-02.jpg');" ]
                [ div 
                    [ attribute "style" "width:65%; height:80%; background-color: white; opacity: 0.8; padding: 2em; overflow:auto;" ]
                    [ model.content
                        |> List.indexedMap (viewButton model.dnd)
                        |> div []
                    , ghostView model.dnd model.content
                    ]
                ]
            ]
        ]


viewButton : DnDList.Model -> Int -> Ingredient -> Html Msg
viewButton dnd index ingr =
    let
        item = stringizeItem ingr
        itemId =
            "id-" ++ item
    in
    case system.info dnd of
        Just { dragIndex } ->
            if dragIndex /= index then
                div 
                    (Html.Attributes.id itemId :: system.dropEvents index itemId)
                    [ text (item ++ " being dragged") ]

            else
                div [ Html.Attributes.id itemId ] [ text "------------" ]

        Nothing ->
            div 
                (Html.Attributes.id itemId :: system.dropEvents index itemId)
                [ button [ onDoubleClick (Delete index) ] [ text (item ++ " still") ] ]


ghostView : DnDList.Model -> List Ingredient -> Html Msg
ghostView dnd items =
    let
        maybeDragItem : Maybe Ingredient
        maybeDragItem =
            system.info dnd
                |> Maybe.andThen (\{ dragIndex } -> items |> List.drop dragIndex |> List.head)
    in
        case maybeDragItem of
            Just item ->
                div (system.ghostStyles dnd)
                    [ text ( stringizeItem item ++ " ghost") ]

            Nothing ->
                text ""
