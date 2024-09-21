import 'dart:isolate';

import 'package:flutter_foreground_task/flutter_foreground_task.dart';

@pragma('vm:entry-point')
void startCallback() {
  FlutterForegroundTask.setTaskHandler(MusicTaskHandler());
}

class MusicTaskHandler extends TaskHandler {
  @override
  Future<void> onStart(DateTime timestamp, SendPort? sendPort) async {
    // You can add any initialization code here
  }

  @override
  Future<void> onEvent(DateTime timestamp, SendPort? sendPort) async {
    // This method is called periodically
    // You can add code here to update the notification or perform other tasks
  }

  @override
  Future<void> onDestroy(DateTime timestamp, SendPort? sendPort) async {
    // Clean up resources here
  }

  @override
  void onButtonPressed(String id) {
    // Handle notification button presses
  }

  @override
  void onRepeatEvent(DateTime timestamp, SendPort? sendPort) {
    // TODO: implement onRepeatEvent
  }
}
