import 'package:flutter/material.dart';
import '../widgets/ipod_display.dart';
import '../widgets/ipod_controls.dart';

class MusicHomeScreen extends StatelessWidget {
  const MusicHomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: Container(
          width: 300,
          height: 600,
          decoration: BoxDecoration(
            color: Colors.grey[200],
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
