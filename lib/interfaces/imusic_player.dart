abstract class IMusicPlayer {
  void play(String url);
  void pause();
  void stop();
  Future<Duration?>? getDuration();
  Future<Duration?>? getPosition();
  Stream<Duration?>? getPositionStream();
  Stream<Duration?>? getDurationStream();
  Stream<void> get onPlayerComplete;  // Add this line
}
