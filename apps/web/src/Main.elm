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


labeledInput : List (Attribute msg) -> List (Html msg) -> Html msg
labeledInput attributes lbl =
    label [] <|
        input attributes []
            :: lbl


toSignedString : Int -> String
toSignedString n =
    let
        asString =
            String.fromInt <| abs n
    in
    if n >= 0 then
        "\u{0002b}" ++ asString

    else
        "\u{02212}" ++ asString


abilityInput_ : Int -> Ability.Ability -> Html Ability.Message
abilityInput_ modifier ability =
    labeledInput
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
    labeledInput
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
            [ class "flex"
            , class "flex-col"
            ]
            [ div
                [ class "flex"
                , class "flex-row"
                ]
                [ input
                    [ placeholder "Name"
                    , onInput Character.Name
                    ]
                    []
                , labeledInput
                    [ type_ "number"
                    , placeholder <| String.fromInt Character.defaultLevel
                    , onInput cleanInput
                    ]
                    [ text <| toSignedString <| Character.proficiencyModifier character ]
                ]
            , div
                [ class "flex"
                , class "flex-row"
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
