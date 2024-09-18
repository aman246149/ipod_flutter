import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../provider/music_player_provider.dart';

class IPodDisplay extends StatefulWidget {
  const IPodDisplay({super.key});

  @override
  State<IPodDisplay> createState() => _IPodDisplayState();
}

class _IPodDisplayState extends State<IPodDisplay> {
  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<MusicPlayerProvider>(context);

  

    return Container(
      width: 220,
      height: 280,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10),
      ),
      child: Column(
        children: [
          const SizedBox(height: 10),
          Text(
            provider.showSongs ? 'Songs' : 'iPod',
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
          const Divider(),
          Expanded(
            child: provider.currentScreen,
          ),
        ],
      ),
    );
  }
}
