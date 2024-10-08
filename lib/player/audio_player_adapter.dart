import 'package:audioplayers/audioplayers.dart';

import '../interfaces/imusic_player.dart';

class AudioPlayerAdapter implements IMusicPlayer {
  final player = AudioPlayer();



  @override
  void pause() {
    player.pause();
  }

  @override
  void play(String url) {
    player.play(UrlSource(url));
  }

  @override
  void stop() {
    player.stop();
  }

  @override
  Future<Duration?> getDuration() {
    return player.getDuration();
  }

  @override
  Future<Duration?> getPosition() {
    return player.getCurrentPosition();
  }

  @override
  Stream<Duration?> getPositionStream() {
    return player.onPositionChanged;
  }

  @override
  Stream<Duration?> getDurationStream() {
    return player.onDurationChanged;  

  }
  
  @override
  Stream<void> get onPlayerComplete => player.onPlayerComplete;
}
