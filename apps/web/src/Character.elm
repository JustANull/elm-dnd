module Character exposing (Character, Message(..), abilityModifier, defaultCharacter, defaultLevel, hasSkill, proficiencyModifier, skillModifier, update)

import Ability
import Skill


type alias Character =
    { name : String
    , level : Int
    , abilities : Ability.Abilities
    , skills : Skill.Skills
    }


defaultLevel : Int
defaultLevel =
    1


defaultCharacter : Character
defaultCharacter =
    { name = "Default Name"
    , level = defaultLevel
    , abilities = Ability.defaultAbilities
    , skills = Skill.defaultSkills
    }


type Message
    = Name String
    | Level Int
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
    getter character.abilities // 2 - 5


hasSkill : Character -> Skill.Skill -> Bool
hasSkill character skill =
    Skill.getter skill character.skills


skillModifier : Character -> Skill.Skill -> Int
skillModifier character skill =
    let
        appliedProficiency =
            if Skill.getter skill <| character.skills then
                proficiencyModifier character

            else
                0

        ability =
            Skill.ability skill
    in
    appliedProficiency + abilityModifier character ability


update : Character -> Message -> Character
update character msg =
    case msg of
        Name val ->
            { character | name = val }

        Level val ->
            { character | level = val }

        Ability ability_msg ->
            { character | abilities = Ability.update character.abilities ability_msg }

        Skill skill_msg ->
            { character | skills = Skill.update character.skills skill_msg }
