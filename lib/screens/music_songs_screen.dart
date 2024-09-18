import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../provider/music_player_provider.dart';

class MusicSongsScreen extends StatefulWidget {
  const MusicSongsScreen({super.key});

  @override
  State<MusicSongsScreen> createState() => _MusicSongsScreenState();
}

class _MusicSongsScreenState extends State<MusicSongsScreen> {
  late final ScrollController scrollController;

  @override
  void initState() {
    super.initState();
    scrollController = ScrollController();
  }

  @override
  void dispose() {
    scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<MusicPlayerProvider>(context);

    return ListView.builder(
      controller: scrollController,
      itemCount: provider.songs.length,
      itemBuilder: (context, index) {
        final song = provider.songs[index];
        return Container(
          color: provider.selectedSongIndex == index ? Colors.blue : null,
          child: ListTile(
            title: Text(
              song.title ?? "",
              style: TextStyle(
                color: provider.selectedSongIndex == index
                    ? Colors.white
                    : Colors.black,
                fontSize: 14,
              ),
            ),
            subtitle: Text(
              song.artists?.map((e) => e.name).join(",") ?? "",
              style: TextStyle(
                color: provider.selectedSongIndex == index
                    ? Colors.white70
                    : Colors.grey,
                fontSize: 12,
              ),
            ),
          ),
        );
      },
    );
  }
}
