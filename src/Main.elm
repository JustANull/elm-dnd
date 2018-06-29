module Main exposing (..)

import Html exposing (Html, Attribute, beginnerProgram, text, div, label, input)
import Html.Attributes exposing (..)
import Html.Events exposing (onCheck, onInput)
import Maybe
import Result
import String

import Ability
import Character
import Skill


main : Program Never Character.Character Character.Message
main =
    beginnerProgram
        { model = Character.basicCharacter
        , view = view
        , update = flip Character.update
        }


toSignedString : Int -> String
toSignedString n =
    let
        sign =
            case (compare n 0) of
                LT ->
                    ""

                EQ ->
                    "+"

                GT ->
                    "+"
    in
        sign ++ toString n


abilityInput : Character.Character -> Ability.Ability -> Html Ability.Message
abilityInput character ability =
    let
        abilityModifier =
            Character.abilityModifier character ability

        cleanInput =
            String.toInt >> Result.toMaybe >> Maybe.withDefault Ability.default >> ability
    in
        div [ id <| Ability.name ability ]
            [ input
                [ type_ "number"
                , defaultValue <| toString Ability.default
                , placeholder <| toString Ability.default
                , onInput cleanInput
                ]
                []
            , text <| toSignedString abilityModifier
            ]


skillInput : Character.Character -> Skill.Skill -> Html Skill.Message
skillInput character skill =
    let
        abilityDescription =
            String.left 3 <| Ability.name <| Skill.ability skill

        description =
            Skill.name skill ++ " (" ++ abilityDescription ++ "): "
    in
        label []
            [ input [ type_ "checkbox", onCheck skill ] []
            , text <| description ++ toSignedString (Character.skillModifier character skill)
            ]


view : Character.Character -> Html Character.Message
view character =
    let
        cleanInput =
            String.toInt >> Result.toMaybe >> Maybe.withDefault Character.defaultLevel >> Character.Level
    in
        div [ id "character" ]
            [ div []
                [ input
                    [ type_ "number"
                    , defaultValue <| toString Character.defaultLevel
                    , placeholder <| toString Character.defaultLevel
                    , onInput cleanInput
                    ] []
                , text <| toSignedString <| Character.proficiencyModifier character
                ]
            , Html.map Character.Ability
                (div [ id "abilities" ]
                    (List.map (abilityInput character) Ability.list)
                )
            , Html.map Character.Skill
                (div [ id "skills" ]
                    (List.map (skillInput character) Skill.list)
                )
            ]
