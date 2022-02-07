# GodotDialogCaptions

GodotDialogCaptions is specialized for audio dialog that plays one-at-a-time, without overlap, and automatically advances once the audio is complete. It can be improved to do more, but I recommend looking at other options like [Dialogic](https://github.com/Dialogic-Godot) for more advanced dialog in Godot.

I made this after reading about game accessibility guidelines and wanted to try making a standardized caption system for Godot.

# Features

- Built for use with multiple locales, you can write captions in a .csv for each language, and use the translation key to play audio and display captions depending on the locale selected.

- No need for hundreds AudioStreamPlayers for a whole scene's dialog. You can switch streams just by giving CaptionedAudio a different translation key.

- CaptionedAudio nodes work near-identically to your conventional AudioStreamPlayer, but they pass caption info to a ready-made CaptionDisplay scene.

- Each CaptionedAudio node can be given a speaker name, simplifying captions for procedurally-generated voiced characters, or similar sound effects from various sources.

- Minimal node footprint on each scene. Just needs a CaptionDisplay.tscn somewhere and a CaptionedAudio node. No connections or specific node structures required.

# Usage

## Project setup
1. Make sure your game has a .csv file to translate text using Godot's Translations system. Learn about [localizing your Godot game](https://docs.godotengine.org/en/stable/tutorials/i18n/internationalizing_games.html) or download the [project template (coming soon)](https://github.com/deertears).
2. Create a subfolder for all captioned audio, with subfolders for each locale you want to support: `res://voice/en`, `res://voice/es`
3. Add your audio files to the locale folders, naming them the same as your translation keys: `res://voices/en/alyx1.ogg`, `res://voices/es/alyx1.ogg`*

*Example .csv:
```csv
keys,en,es
alyx1,"Hi!","Hola!"
```

## Adding GodotDialogCaptions
1. Add `res://addons/GodotDialogCaptions/CaptionAutoload.gd` to your Project -> Autoload tab.
2. Add the `res://addons/GodotDialogCaptions/CaptionDisplay.tscn` node as a child of a CanvasLayer.
3. Add a CaptionedAudio node to your scene (it's in your Add Child Node menu), just like you would an AudioStreamPlayer.
4. Call `play_captioned()` and pass the csv string: `$CaptionedAudio.play_captioned("alyx1")`

If the current locale or string doesn't match a key, an error gets pushed, and the incorrect key will display on screen.

You can use `TranslationServer.set_locale("en")` to force a locale.

For convenience, `can_use_regional_dialects` is disabled by default in CaptionsAutoload. This is to reduce locales like `en_US` and `en_CA` into just `en`. If you want to use a unique regional dialect for dialog, enable `can_use_regional_dialects`, which will preserve the suffixes of `en_US` and `en_CA` when searching for audio files and .csv captions. This is


Captions and audio are not tightly coupled to the TranslationServer locale, so both captions and dialog could be displayed completely separate from the locale used for the in-game text. Useful for games where your translation team can only translate the story and dialog for some audiences, but resources like [PolyglotGamedev](https://github.com/PolyglotGamedev) can be used to translate common strings in games to many more locales.

You can optionally reduce regional dialects to play just the core locale's audio (en_CA and en_UK would both play en audio).

# Oversights

This system can't yet display captions of one language with audio in another language, but this is most likely the next feature. It's designed to pull locale data from CaptionAutoload, not just from TranslationServer.

This system doesn't utilize Godot's Localization -> Remap system to replace resources and audio files. I really could've used it, just didn't know how. At least this lets us decouple it from the current locale entirely.

This system relies on Godot's translation system. While this is a lot of work for smaller teams, you get the benefit of writing all your captions in one .csv file. 

You have to match translation key names to audio file names. This does enforce some amount of organization, and makes it easier to double-check audio against all captions, but it lacks flexibility if you need captioned audio to be organized in multiple folders.

Randomized voicelines must be determined when passing the translation key to `play_captioned()`. Example: `play_captioned("victory_1" if randi() % 2 == 0 else "victory_2")`

GodotDialogCaptions is intended to show one caption at a time. It isn't yet capable of displaying thorough closed captions as seen in Valve and Mojang titles. Although it keeps an accurate Array of currently playing keys, this isn't visualized in any way just yet, and I would like help implementing this.

The user cannot pause to read the text on a caption unless the entire scene tree is also paused. You may want to consider [Dialogic](https://github.com/Dialogic-Godot) to let the user control their reading pace, as this addon is meant to progress through text automatically.

# Bugs

Each audio player only supports one file extension at a time. You can use multiple file extensions so long as they're being played by different audio players. The assumption is that all voicework is done in .ogg, while all sounds are done in .wav.
