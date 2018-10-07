module Settings exposing (Message(..), Settings, Theme(..), decoder, defaultSettings, encode, themeClass, update)

import Json.Decode exposing (Decoder)
import Json.Encode
import Maybe


type Theme
    = Light
    | Dark


themeClass : Theme -> String
themeClass theme =
    case theme of
        Light ->
            "theme-light"

        Dark ->
            "theme-dark"


themeDecoder : Decoder Theme
themeDecoder =
    Json.Decode.string
        |> Json.Decode.andThen
            (\str ->
                case str of
                    "light" ->
                        Json.Decode.succeed Light

                    "dark" ->
                        Json.Decode.succeed Dark

                    somethingElse ->
                        Json.Decode.fail <| "Unknown theme: " ++ somethingElse
            )


themeEncode : Theme -> Json.Encode.Value
themeEncode theme =
    case theme of
        Light ->
            Json.Encode.string "light"

        Dark ->
            Json.Encode.string "dark"


type alias Settings =
    { theme : Theme
    }


defaultSettings : Settings
defaultSettings =
    { theme = Light
    }


type Message
    = ToggleTheme


decoder : Decoder Settings
decoder =
    Json.Decode.map Settings
        (Json.Decode.field "theme" themeDecoder |> Json.Decode.maybe |> Json.Decode.map (Maybe.withDefault defaultSettings.theme))


encode : Settings -> Json.Encode.Value
encode settings =
    Json.Encode.object
        [ ( "theme", themeEncode settings.theme )
        ]


update : Settings -> Message -> Settings
update settings msg =
    case msg of
        ToggleTheme ->
            { settings
                | theme =
                    case settings.theme of
                        Light ->
                            Dark

                        Dark ->
                            Light
            }
