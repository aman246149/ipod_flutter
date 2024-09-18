import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';

import '../provider/music_player_provider.dart';

class IPodControls extends StatelessWidget {
  const IPodControls({super.key});

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<MusicPlayerProvider>(context);

    return Container(
      width: 220,
      height: 220,
      decoration: const BoxDecoration(
        color: Colors.white,
        shape: BoxShape.circle,
      ),
      child: Stack(
        children: [
          Positioned(
            top: 0,
            left: 85,
            child: IconButton(
              icon: const Icon(Icons.keyboard_arrow_up),
              onPressed: () => provider.moveSelection(-1),
            ),
          ),
          Positioned(
            bottom: 0,
            left: 85,
            child: IconButton(
              icon: const Icon(Icons.keyboard_arrow_down),
              onPressed: () => provider.moveSelection(1),
            ),
          ),
          Positioned(
            left: 0,
            top: 85,
            child: IconButton(
              icon: const Icon(Icons.skip_previous),
              onPressed: provider.previousTrack,
            ),
          ),
          Positioned(
            right: 0,
            top: 85,
            child: IconButton(
              icon: const Icon(Icons.skip_next),
              onPressed: provider.nextTrack,
            ),
          ),
          Center(
            child: GestureDetector(
              onTap: () {
                HapticFeedback.heavyImpact(); // Add haptic feedback
                provider.handleCenterButtonTap(context);
              },
              child: Container(
                width: 80,
                height: 80,
                decoration: BoxDecoration(
                  color: Colors.white,
                  shape: BoxShape.circle,
                  border: Border.all(color: Colors.grey),
                ),
                child: const Center(
                  child: Text(
                    'MENU',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
