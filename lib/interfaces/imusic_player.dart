abstract class IMusicPlayer {
  void play(String url);
  void pause();
  void stop();
  Future<Duration?>? getDuration();
  Future<Duration?>? getPosition();
}
