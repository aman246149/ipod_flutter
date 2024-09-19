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
  
  @override
  Future<Duration> getDuration() {
    // TODO: implement getDuration
    throw UnimplementedError();
  }
  
  @override
  Future<Duration> getPosition() {
    // TODO: implement getPosition
    throw UnimplementedError();
  }
  
  @override
  Stream<Duration?>? getDurationStream() {
    // TODO: implement getDurationStream
    throw UnimplementedError();
  }
  
  @override
  Stream<Duration?>? getPositionStream() {
    // TODO: implement getPositionStream
    throw UnimplementedError();
  }
}
