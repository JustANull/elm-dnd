module Main exposing (main)

import Ability
import Browser exposing (Document)
import Character
import Flip exposing (flip)
import Html exposing (Attribute, Html, div, input, label, text)
import Html.Attributes exposing (..)
import Html.Events exposing (onCheck, onInput)
import Html.Lazy exposing (..)
import Maybe
import Result
import Skill
import String


pureUpdate : (a -> b -> c) -> (a -> b -> ( c, Cmd d ))
pureUpdate f =
    \aVal bVal -> ( f aVal bVal, Cmd.none )


initCharacter : Int -> ( Character.Character, Cmd Character.Message )
initCharacter _ =
    ( Character.defaultCharacter, Cmd.none )


main : Program Int Character.Character Character.Message
main =
    Browser.document
        { init = initCharacter
        , subscriptions = always Sub.none
        , view = view
        , update = pureUpdate <| flip Character.update
        }


labeledCheckbox : (Bool -> msg) -> String -> Html msg
labeledCheckbox msg lbl =
    label []
        [ input [ type_ "checkbox", onCheck msg ] []
        , text lbl
        ]


labeledNumericInput : (String -> msg) -> String -> String -> Html msg
labeledNumericInput msg plc lbl =
    div []
        [ input
            [ type_ "number"
            , placeholder plc
            , onInput msg
            ]
            []
        , text lbl
        ]


toSignedString : Int -> String
toSignedString n =
    let
        asString =
            String.fromInt n
    in
    if n >= 0 then
        "+" ++ asString

    else
        asString


abilityInput_ : Int -> Ability.Ability -> Html Ability.Message
abilityInput_ modifier ability =
    let
        cleanInput =
            String.toInt >> Maybe.withDefault Ability.default >> ability

        placeholder =
            String.fromInt Ability.default
    in
    labeledNumericInput cleanInput placeholder (toSignedString modifier)


abilityInput : Character.Character -> Ability.Ability -> Html Ability.Message
abilityInput character ability =
    lazy2 abilityInput_ (Character.abilityModifier character ability) ability


skillInput_ : Int -> Skill.Skill -> Html Skill.Message
skillInput_ modifier skill =
    let
        abilityDescription =
            String.left 3 <| Ability.name <| Skill.ability skill

        skillDescription =
            Skill.name skill ++ " (" ++ abilityDescription ++ "): "

        description =
            skillDescription ++ toSignedString modifier
    in
    labeledCheckbox skill description


skillInput : Character.Character -> Skill.Skill -> Html Skill.Message
skillInput character skill =
    lazy2 skillInput_ (Character.skillModifier character skill) skill


view : Character.Character -> Document Character.Message
view character =
    let
        cleanInput =
            String.toInt >> Maybe.withDefault Character.defaultLevel >> Character.Level
    in
    { title = "elm-dnd"
    , body =
        [ div []
            [ labeledNumericInput cleanInput (String.fromInt Character.defaultLevel) (toSignedString <| Character.proficiencyModifier character)
            , Html.map Character.Ability
                (div []
                    (List.map (abilityInput character) Ability.list)
                )
            , Html.map Character.Skill
                (div []
                    (List.map (skillInput character) Skill.list)
                )
            ]
        ]
    }
