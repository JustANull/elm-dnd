module Main exposing (..)

import Browser exposing (Document)
import Flip exposing (flip)
import Html exposing (Attribute, Html, div, label, input, text)
import Html.Attributes exposing (..)
import Html.Events exposing (onCheck, onInput)
import Html.Lazy exposing (lazy)
import Maybe
import Result
import String

import Ability
import Character
import Skill


pureUpdate : (a -> b -> c) -> (a -> b -> (c, Cmd d))
pureUpdate f =
    \aVal bVal -> (f aVal bVal, Cmd.none)


initCharacter : Int -> (Character.Character, Cmd Character.Message)
initCharacter _ =
    (Character.basicCharacter, Cmd.none)


main : Program Int Character.Character Character.Message
main =
    Browser.document
        { init = initCharacter
        , subscriptions = (always Sub.none)
        , view = view
        , update = pureUpdate <| flip Character.update
        }


toSignedString : Int -> String
toSignedString n =
    let
        sign =
            if (n >= 0) then
                "+"
            else
                ""
    in
        sign ++ String.fromInt n


abilityInput : Character.Character -> Ability.Ability -> Html Ability.Message
abilityInput character ability =
    let
        abilityModifier =
            Character.abilityModifier character ability

        cleanInput =
            String.toInt >> Maybe.withDefault Ability.default >> ability
    in
        div [ id <| Ability.name ability ]
            [ input
                [ type_ "number"
                , placeholder <| String.fromInt Ability.default
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


view : Character.Character -> Document Character.Message
view character =
    let
        cleanInput =
            String.toInt >> Maybe.withDefault Character.defaultLevel >> Character.Level
    in
        { title = "elm-dnd"
        , body =
            [ div []
                  [ div []
                        [ input
                              [ type_ "number"
                              , placeholder <| String.fromInt Character.defaultLevel
                              , onInput cleanInput
                              ] []
                        , text <| toSignedString <| Character.proficiencyModifier character
                        ]
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
