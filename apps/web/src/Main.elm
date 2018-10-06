module Main exposing (main)

import Ability
import Browser exposing (Document)
import Character
import Flip exposing (flip)
import Html exposing (Attribute, Html, button, div, input, label, text)
import Html.Attributes exposing (checked, class, classList, placeholder, type_)
import Html.Events exposing (onCheck, onInput)
import Html.Lazy exposing (lazy2, lazy3)
import Skill


main : Program Int Character.Character Character.Message
main =
    Browser.document
        { init = init
        , subscriptions = always Sub.none
        , view = view
        , update = pureUpdate2 <| flip Character.update
        }


init : Int -> ( Character.Character, Cmd Character.Message )
init _ =
    ( Character.defaultCharacter, Cmd.none )


pureUpdate2 : (a -> b -> c) -> (a -> b -> ( c, Cmd d ))
pureUpdate2 f =
    \aVal bVal -> ( f aVal bVal, Cmd.none )


labeledInput3 : List (Attribute msg) -> List (Attribute msg) -> List (Html msg) -> Html msg
labeledInput3 labelAttributes attributes lbl =
    label
        ([ class "m-1"
         , class "flex"
         , class "items-center"
         ]
            ++ labelAttributes
        )
    <|
        input
            (class "mr-1" :: attributes)
            []
            :: lbl


labeledInput2 : List (Attribute msg) -> List (Html msg) -> Html msg
labeledInput2 attributes lbl =
    labeledInput3 [] attributes lbl


toSignedString : Int -> String
toSignedString n =
    let
        asString =
            String.fromInt <| abs n
    in
    if n >= 0 then
        "+" ++ asString

    else
        "−" ++ asString


abilityInput_ : Int -> Ability.Ability -> Html Ability.Message
abilityInput_ modifier ability =
    labeledInput3
        [ class "input-text"
        ]
        [ type_ "number"
        , placeholder <| String.fromInt Ability.default
        , onInput <| String.toInt >> Maybe.withDefault Ability.default >> ability
        ]
        [ text <| toSignedString modifier ]


abilityInput : Character.Character -> Ability.Ability -> Html Ability.Message
abilityInput character ability =
    let
        modifier =
            Character.abilityModifier character ability
    in
    lazy2 abilityInput_ modifier ability


skillInput_ : Bool -> Int -> Skill.Skill -> Html Skill.Message
skillInput_ hasSkill modifier skill =
    let
        abilityDescription =
            String.left 3 <| Ability.name <| Skill.ability skill

        skillDescription =
            Skill.name skill ++ " (" ++ abilityDescription ++ "): "

        description =
            skillDescription ++ toSignedString modifier
    in
    labeledInput2
        [ type_ "checkbox"
        , checked hasSkill
        , onCheck skill
        ]
        [ text description ]


skillInput : Character.Character -> Skill.Skill -> Html Skill.Message
skillInput character skill =
    let
        hasSkill =
            Character.hasSkill character skill

        modifier =
            Character.skillModifier character skill
    in
    lazy3 skillInput_ hasSkill modifier skill


view : Character.Character -> Document Character.Message
view character =
    let
        cleanInput =
            String.toInt >> Maybe.withDefault Character.defaultLevel >> Character.Level
    in
    { title = "elm-dnd"
    , body =
        [ div
            [ class "min-w-screen"
            , class "min-h-screen"
            , class "flex"
            , class "flex-col"
            , class "items-center"
            ]
            [ div
                [ class "flex"
                , class "flex-col"
                , class "sm:flex-row"
                ]
                [ labeledInput3
                    [ class "input-text"
                    ]
                    [ placeholder "Name"
                    , onInput Character.Name
                    ]
                    []
                , labeledInput3
                    [ class "input-text"
                    ]
                    [ type_ "number"
                    , placeholder <| String.fromInt Character.defaultLevel
                    , onInput cleanInput
                    ]
                    [ text <| toSignedString <| Character.proficiencyModifier character ]
                ]
            , div
                [ class "flex"
                , class "flex-col"
                , class "sm:flex-row"
                ]
                [ Html.map Character.Ability
                    (div
                        [ class "flex"
                        , class "flex-col"
                        ]
                        (List.map (abilityInput character) Ability.list)
                    )
                , Html.map Character.Skill
                    (div
                        [ class "flex"
                        , class "flex-col"
                        ]
                        (List.map (skillInput character) Skill.list)
                    )
                ]
            ]
        ]
    }
