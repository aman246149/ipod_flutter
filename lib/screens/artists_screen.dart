import 'package:flutter/material.dart';
import 'package:music/screens/music_songs_screen.dart';
import 'package:provider/provider.dart';
import '../provider/music_player_provider.dart';
import '../model/song_model.dart';
import 'package:flutter/services.dart';

import '../widgets/song_tile.dart';

class ArtistsScreen extends StatefulWidget {
  const ArtistsScreen({Key? key}) : super(key: key);

  @override
  State<ArtistsScreen> createState() => _ArtistsScreenState();
}

class _ArtistsScreenState extends State<ArtistsScreen> {
  final ScrollController _scrollController = ScrollController();
  int _selectedSongIndex = -1;

  @override
  Widget build(BuildContext context) {
    return Consumer<MusicPlayerProvider>(
      builder: (context, musicProvider, child) {
        final artists = musicProvider.artists;
        final selectedArtistIndex = musicProvider.selectedArtistIndex;

        WidgetsBinding.instance.addPostFrameCallback((_) {
          if (_scrollController.hasClients) {
            final itemHeight = 56.0; // Approximate height of a ListTile
            final selectedIndex = musicProvider.selectedArtistIndex;
            final targetOffset = selectedIndex * itemHeight;

            // Only scroll if necessary
            if (targetOffset != _scrollController.offset) {
              _scrollController.animateTo(
                targetOffset,
                duration: const Duration(milliseconds: 200),
                curve: Curves.easeOutCubic,
              );
            }
          }
        });

        return ListView.builder(
          controller: _scrollController,
          itemCount: artists.length,
          itemBuilder: (context, index) {
            final artist = artists[index];
            final isSelected = index == selectedArtistIndex;
            return Container(
              color: isSelected ? Colors.blue : null,
              child: ListTile(
                title: Text(
                  artist.name ?? "",
                  style: TextStyle(
                    color: isSelected ? Colors.white : Colors.black,
                  ),
                ),
              ),
            );
          },
        );
      },
    );
  }
}
