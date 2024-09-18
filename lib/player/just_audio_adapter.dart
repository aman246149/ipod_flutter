import 'package:just_audio/just_audio.dart';
import 'package:music/interfaces/imusic_player.dart';

class JustAudioAdapter implements IMusicPlayer {
  final player = AudioPlayer();

  @override
  void pause() {
    player.pause();
  }

  @override
  void play(String url) async {
    await player.setAudioSource(AudioSource.asset(url));
    player.play();
  }

  @override
  void stop() {
    player.stop();
  }
}
