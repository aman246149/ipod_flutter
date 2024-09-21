import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';
import '../widgets/ipod_display.dart';
import '../widgets/ipod_controls.dart';

class MusicHomeScreen extends StatefulWidget {
  const MusicHomeScreen({super.key});

  @override
  State<MusicHomeScreen> createState() => _MusicHomeScreenState();
}

class _MusicHomeScreenState extends State<MusicHomeScreen> {

  @override
  void initState() {
    super.initState();
    //add notification permission
    Permission.notification.request();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade800,
      body: Center(
        child: Container(
          width: 300,
          height: 600,
          decoration: BoxDecoration(
            color: Colors.grey.shade300,
            borderRadius: BorderRadius.circular(20),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const IPodDisplay(),
              const SizedBox(height: 20),
              const IPodControls(),
            ],
          ),
        ),
      ),
    );
  }
}
