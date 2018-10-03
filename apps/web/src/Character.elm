module Character exposing (..)

import Ability
import Skill


type alias Character =
    { name : String
    , level : Int
    , abilities : Ability.Abilities
    , skills : Skill.Skills
    }

defaultLevel : Int
defaultLevel = 1

basicCharacter : Character
basicCharacter =
    { name = "Default Name"
    , level = defaultLevel
    , abilities = Ability.basicAbilities
    , skills = Skill.basicSkills
    }


type Message
    = Level Int
    | Ability Ability.Message
    | Skill Skill.Message


proficiencyModifier : Character -> Int
proficiencyModifier character =
    (7 + character.level) // 4


abilityModifier : Character -> Ability.Ability -> Int
abilityModifier character ability =
    let
        getter =
            Ability.getter ability
    in
        (getter character.abilities) // 2 - 5


skillModifier : Character -> Skill.Skill -> Int
skillModifier character skill =
    let
        appliedProficiency =
            if (Skill.getter skill <| character.skills) then
                proficiencyModifier character
            else
                0

        ability =
            Skill.ability skill
    in
        appliedProficiency + (abilityModifier character ability)


update : Character -> Message -> Character
update character msg =
    case msg of
        Level val ->
            { character | level = val }

        Ability ability_msg ->
            { character | abilities = Ability.update character.abilities ability_msg }

        Skill skill_msg ->
            { character | skills = Skill.update character.skills skill_msg }
