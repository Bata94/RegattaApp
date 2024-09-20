import 'package:assets_audio_player/assets_audio_player.dart';

class AudioController {
  AssetsAudioPlayer audioPlayer = AssetsAudioPlayer.newPlayer();

  Audio airHorn = Audio("assets/sound/airHorn.mp3");

  void preloadAirHorn() {
    audioPlayer.open(
      airHorn,
      volume: 0,
    );
  }

  void playAirHorn() {
    audioPlayer.open(
      airHorn,
      volume: 1.0,
    );
  }
}

