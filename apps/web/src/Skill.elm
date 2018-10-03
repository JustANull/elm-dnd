module Skill exposing (Message(..), Skill, Skills, ability, defaultSkills, getter, list, name, update)

import Ability exposing (Ability)


type alias Skills =
    { acrobatics : Bool
    , animalHandling : Bool
    , arcana : Bool
    , athletics : Bool
    , deception : Bool
    , history : Bool
    , insight : Bool
    , intimidation : Bool
    , investigation : Bool
    , medicine : Bool
    , nature : Bool
    , perception : Bool
    , persuasion : Bool
    , religion : Bool
    , sleightOfHand : Bool
    , stealth : Bool
    , survival : Bool
    }


defaultSkills : Skills
defaultSkills =
    { acrobatics = False
    , animalHandling = False
    , arcana = False
    , athletics = False
    , deception = False
    , history = False
    , insight = False
    , intimidation = False
    , investigation = False
    , medicine = False
    , nature = False
    , perception = False
    , persuasion = False
    , religion = False
    , sleightOfHand = False
    , stealth = False
    , survival = False
    }


type Message
    = Acrobatics Bool
    | AnimalHandling Bool
    | Arcana Bool
    | Athletics Bool
    | Deception Bool
    | History Bool
    | Insight Bool
    | Intimidation Bool
    | Investigation Bool
    | Medicine Bool
    | Nature Bool
    | Perception Bool
    | Persuasion Bool
    | Religion Bool
    | SleightOfHand Bool
    | Stealth Bool
    | Survival Bool


type alias Skill =
    Bool -> Message


list : List Skill
list =
    [ Acrobatics
    , AnimalHandling
    , Arcana
    , Athletics
    , Deception
    , History
    , Insight
    , Intimidation
    , Investigation
    , Medicine
    , Nature
    , Perception
    , Persuasion
    , Religion
    , SleightOfHand
    , Stealth
    , Survival
    ]


ability : Skill -> Ability.Ability
ability kind =
    case kind False of
        Acrobatics _ ->
            Ability.Dexterity

        AnimalHandling _ ->
            Ability.Wisdom

        Arcana _ ->
            Ability.Intelligence

        Athletics _ ->
            Ability.Strength

        Deception _ ->
            Ability.Charisma

        History _ ->
            Ability.Intelligence

        Insight _ ->
            Ability.Wisdom

        Intimidation _ ->
            Ability.Charisma

        Investigation _ ->
            Ability.Intelligence

        Medicine _ ->
            Ability.Wisdom

        Nature _ ->
            Ability.Intelligence

        Perception _ ->
            Ability.Wisdom

        Persuasion _ ->
            Ability.Charisma

        Religion _ ->
            Ability.Intelligence

        SleightOfHand _ ->
            Ability.Dexterity

        Stealth _ ->
            Ability.Dexterity

        Survival _ ->
            Ability.Wisdom


getter : Skill -> Skills -> Bool
getter kind =
    case kind False of
        Acrobatics _ ->
            .acrobatics

        AnimalHandling _ ->
            .animalHandling

        Arcana _ ->
            .arcana

        Athletics _ ->
            .athletics

        Deception _ ->
            .deception

        History _ ->
            .history

        Insight _ ->
            .insight

        Intimidation _ ->
            .intimidation

        Investigation _ ->
            .investigation

        Medicine _ ->
            .medicine

        Nature _ ->
            .nature

        Perception _ ->
            .perception

        Persuasion _ ->
            .persuasion

        Religion _ ->
            .religion

        SleightOfHand _ ->
            .sleightOfHand

        Stealth _ ->
            .stealth

        Survival _ ->
            .survival


name : Skill -> String
name kind =
    case kind False of
        Acrobatics _ ->
            "Acrobatics"

        AnimalHandling _ ->
            "Animal Handling"

        Arcana _ ->
            "Arcana"

        Athletics _ ->
            "Athletics"

        Deception _ ->
            "Deception"

        History _ ->
            "History"

        Insight _ ->
            "Insight"

        Intimidation _ ->
            "Intimidation"

        Investigation _ ->
            "Investigation"

        Medicine _ ->
            "Medicine"

        Nature _ ->
            "Nature"

        Perception _ ->
            "Perception"

        Persuasion _ ->
            "Persuasion"

        Religion _ ->
            "Religion"

        SleightOfHand _ ->
            "Sleight of Hand"

        Stealth _ ->
            "Stealth"

        Survival _ ->
            "Survival"


update : Skills -> Message -> Skills
update skills msg =
    case msg of
        Acrobatics prof ->
            { skills | acrobatics = prof }

        AnimalHandling prof ->
            { skills | animalHandling = prof }

        Arcana prof ->
            { skills | arcana = prof }

        Athletics prof ->
            { skills | athletics = prof }

        Deception prof ->
            { skills | deception = prof }

        History prof ->
            { skills | history = prof }

        Insight prof ->
            { skills | insight = prof }

        Intimidation prof ->
            { skills | intimidation = prof }

        Investigation prof ->
            { skills | investigation = prof }

        Medicine prof ->
            { skills | medicine = prof }

        Nature prof ->
            { skills | nature = prof }

        Perception prof ->
            { skills | perception = prof }

        Persuasion prof ->
            { skills | persuasion = prof }

        Religion prof ->
            { skills | religion = prof }

        SleightOfHand prof ->
            { skills | sleightOfHand = prof }

        Stealth prof ->
            { skills | stealth = prof }

        Survival prof ->
            { skills | survival = prof }
