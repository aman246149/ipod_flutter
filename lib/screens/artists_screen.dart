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

        return RawKeyboardListener(
          focusNode: FocusNode(),
          autofocus: true,
          onKey: (RawKeyEvent event) {},
          child: ListView.builder(
            controller: _scrollController,
            itemCount: artists.length,
            itemBuilder: (context, index) {
              final artist = artists[index];
              final isSelected = index == selectedArtistIndex;
              return Container(
                color: isSelected
                    ? Theme.of(context).primaryColor.withOpacity(0.2)
                    : null,
                child: ListTile(
                  title: Text(artist.name ?? ""),
                ),
              );
            },
          ),
        );
      },
    );
  }

  void _moveSongSelection(MusicPlayerProvider musicProvider, int direction) {
    final selectedArtist =
        musicProvider.artists[musicProvider.selectedArtistIndex];
    final songCount = selectedArtist.songs?.length ?? 0;
    if (songCount > 0) {
      setState(() {
        _selectedSongIndex =
            (_selectedSongIndex + direction).clamp(-1, songCount - 1);
      });
    }
  }

  void _playSongAtCurrentSelection(MusicPlayerProvider musicProvider) {
    final selectedArtist =
        musicProvider.artists[musicProvider.selectedArtistIndex];
    if (_selectedSongIndex >= 0 &&
        _selectedSongIndex < (selectedArtist.songs?.length ?? 0)) {
      final selectedSong = selectedArtist.songs![_selectedSongIndex];
      if (selectedSong.isPlaying) {
        musicProvider.musicPlayer.stop();
        selectedSong.isPlaying = false;
      } else {
        musicProvider.musicPlayer.play(selectedSong.url ?? "");
        selectedSong.isPlaying = true;
      }
    }
  }
}
