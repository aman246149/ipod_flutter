import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../provider/music_player_provider.dart';
import '../widgets/song_tile.dart';

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

    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (scrollController.hasClients) {
        final itemHeight = 56.0; // Approximate height of a ListTile
        final selectedIndex = provider.selectedSongIndex;
        final targetOffset = selectedIndex * itemHeight;

        // Only scroll if necessary
        if (targetOffset != scrollController.offset) {
          scrollController.animateTo(
            targetOffset,
            duration: const Duration(milliseconds: 200),
            curve: Curves.easeOutCubic,
          );
        }
      }
    });

    return ListView.builder(
      controller: scrollController,
      itemCount: provider.songs.length,
      itemBuilder: (context, index) {
        final song = provider.songs[index];
        return SongTile(songModel: song, isSelected: index == provider.selectedSongIndex);
      },
    );
  }
}
