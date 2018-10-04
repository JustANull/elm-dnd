module Main exposing (main)

import Ability
import Browser exposing (Document)
import Character
import Flip exposing (flip)
import Html.Styled exposing (Html, button, div, input, label, text)
import Html.Styled.Attributes exposing (checked, placeholder, type_)
import Html.Styled.Events exposing (onCheck, onInput)
import Html.Styled.Lazy exposing (lazy2, lazy3)
import Maybe
import Result
import Skill
import String


pureUpdate2 : (a -> b -> c) -> (a -> b -> ( c, Cmd d ))
pureUpdate2 f =
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
        , update = pureUpdate2 <| flip Character.update
        }


labeledCheckbox : (Bool -> msg) -> Bool -> String -> Html msg
labeledCheckbox msg chk lbl =
    label []
        [ input
            [ type_ "checkbox"
            , checked chk
            , onCheck msg
            ]
            []
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
    labeledCheckbox skill hasSkill description


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
        List.map Html.Styled.toUnstyled
            [ div []
                [ labeledNumericInput cleanInput (String.fromInt Character.defaultLevel) (toSignedString <| Character.proficiencyModifier character)
                , Html.Styled.map Character.Ability
                    (div []
                        (List.map (abilityInput character) Ability.list)
                    )
                , Html.Styled.map Character.Skill
                    (div []
                        (List.map (skillInput character) Skill.list)
                    )
                ]
            ]
    }
