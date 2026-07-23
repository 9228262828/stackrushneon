STACK RUSH NEON ASSETS

Audio files are original procedurally generated WAV files:
- assets/audio/tap.wav
- assets/audio/button.wav
- assets/audio/perfect.wav
- assets/audio/game_over.wav
- assets/audio/background_music.wav

Image files:
- assets/images/logo.png
- assets/images/icon.png
- assets/images/splash_logo.png
- assets/images/bg_home.png
- assets/images/bg_game.png
- assets/images/bg_game_over.png
- assets/images/particles/

Add to pubspec.yaml:

flutter:
  assets:
    - assets/audio/
    - assets/images/
    - assets/images/particles/

Recommended package:
audioplayers: ^6.5.1

Use AssetSource('audio/tap.wav') with audioplayers because Flutter assets are referenced relative to the assets folder.