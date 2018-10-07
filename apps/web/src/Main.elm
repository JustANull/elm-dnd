port module Main exposing (main)

import Ability
import Browser exposing (Document)
import Character
import Flip exposing (flip)
import Html exposing (Attribute, Html, button, div, input, label, p, text)
import Html.Attributes exposing (checked, class, classList, placeholder, type_)
import Html.Events exposing (onCheck, onClick, onInput)
import Html.Lazy exposing (lazy2, lazy3)
import Json.Decode
import Json.Encode
import Settings
import Skill


port saveSettings : Json.Encode.Value -> Cmd msg


main : Program Json.Decode.Value Model Message
main =
    Browser.document
        { init = init
        , subscriptions = always Sub.none
        , view = view
        , update = update
        }


type alias Model =
    { settings : Settings.Settings
    , character : Character.Character
    }


type Message
    = Settings Settings.Message
    | Character Character.Message


init : Json.Decode.Value -> ( Model, Cmd Message )
init maybeSettings =
    let
        settings =
            case Json.Decode.decodeValue Settings.decoder maybeSettings of
                Err _ ->
                    Settings.defaultSettings

                Ok value ->
                    value
    in
    ( { settings = settings
      , character = Character.defaultCharacter
      }
    , saveSettings <| Settings.encode settings
    )


update : Message -> Model -> ( Model, Cmd Message )
update msg model =
    case msg of
        Settings settings_msg ->
            let
                updated =
                    { model | settings = Settings.update model.settings settings_msg }
            in
            ( updated, saveSettings <| Settings.encode updated.settings )

        Character character_msg ->
            ( { model | character = Character.update model.character character_msg }, Cmd.none )


view : Model -> Document Message
view model =
    let
        cleanInput =
            String.toInt >> Maybe.withDefault Character.defaultLevel >> Character.Level

        settings =
            model.settings

        character =
            model.character
    in
    { title = "elm-dnd"
    , body =
        [ div
            [ classList
                [ ( "min-w-screen", True )
                , ( "min-h-screen", True )
                , ( "bg-primary", True )
                , ( "text-primary", True )
                , ( Settings.themeClass settings.theme, True )
                , ( "relative", True )
                ]
            ]
            <| div
                [ classList
                    [ ( "flex", True )
                    , ( "flex-col", True )
                    , ( "items-center", True )
                    ]
                ]
                (List.map (Html.map Character)
                    [ div
                        [ classList
                            [ ( "flex", True )
                            , ( "flex-col", True )
                            , ( "sm:flex-row", True )
                            ]
                        ]
                        [ labeledInput3
                            [ classList
                                [ ( "input-text", True )
                                , ( "sm:mr-2", True )
                                ]
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
                        [ classList
                            [ ( "flex", True )
                            , ( "flex-col", True )
                            , ( "sm:flex-row", True )
                            ]
                        ]
                        [ Html.map Character.Ability
                            (div
                                [ classList
                                    [ ( "flex", True )
                                    , ( "flex-col", True )
                                    ]
                                ]
                                (List.map (abilityInput character) Ability.list)
                            )
                        , Html.map Character.Skill
                            (div
                                [ classList
                                    [ ( "flex", True )
                                    , ( "flex-col", True )
                                    ]
                                ]
                                (List.map (skillInput character) Skill.list)
                            )
                        ]
                    ]
                )
                :: List.map (Html.map Settings)
                    [ button
                        [ onClick Settings.ToggleTheme
                        , classList
                            [ ( "sticky", True )
                            , ( "pin-b", True )
                            , ( "p-1", True )
                            , ( "ml-1", True )
                            , ( "rounded", True )
                            , ( "bg-highlight", True )
                            ]
                        ]
                        [ text <|
                            case settings.theme of
                                Settings.Light ->
                                    "-> Dark Mode"

                                Settings.Dark ->
                                    "-> Light Mode"
                        ]
                    ]
        ]
    }


labeledInput3 : List (Attribute msg) -> List (Attribute msg) -> List (Html msg) -> Html msg
labeledInput3 labelAttributes attributes lbl =
    label
        ([ classList
            [ ( "p-1", True )
            , ( "relative", True )
            , ( "flex", True )
            , ( "items-center", True )
            ]
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
