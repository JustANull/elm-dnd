module Ability exposing (..)


type alias Abilities =
    { strength : Int
    , dexterity : Int
    , constitution : Int
    , intelligence : Int
    , wisdom : Int
    , charisma : Int
    }


default : Int
default =
    10


defaultAbilities : Abilities
defaultAbilities =
    { strength = default
    , dexterity = default
    , constitution = default
    , intelligence = default
    , wisdom = default
    , charisma = default
    }


type Message
    = Strength Int
    | Dexterity Int
    | Constitution Int
    | Intelligence Int
    | Wisdom Int
    | Charisma Int


type alias Ability =
    Int -> Message


list : List Ability
list =
    [ Strength
    , Dexterity
    , Constitution
    , Intelligence
    , Wisdom
    , Charisma
    ]


getter : Ability -> Abilities -> Int
getter kind =
    case (kind 0) of
        Strength _ ->
            .strength

        Dexterity _ ->
            .dexterity

        Constitution _ ->
            .constitution

        Intelligence _ ->
            .intelligence

        Wisdom _ ->
            .wisdom

        Charisma _ ->
            .charisma


name : (Int -> Message) -> String
name kind =
    case (kind 0) of
        Strength _ ->
            "Strength"

        Dexterity _ ->
            "Dexterity"

        Constitution _ ->
            "Constitution"

        Intelligence _ ->
            "Intelligence"

        Wisdom _ ->
            "Wisdom"

        Charisma _ ->
            "Charisma"


update : Abilities -> Message -> Abilities
update abilities msg =
    case msg of
        Strength val ->
            { abilities | strength = val }

        Dexterity val ->
            { abilities | dexterity = val }

        Constitution val ->
            { abilities | constitution = val }

        Intelligence val ->
            { abilities | intelligence = val }

        Wisdom val ->
            { abilities | wisdom = val }

        Charisma val ->
            { abilities | charisma = val }
