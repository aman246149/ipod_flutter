import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../provider/music_player_provider.dart';
import '../model/song_model.dart';

class ArtistsScreen extends StatefulWidget {
  const ArtistsScreen({Key? key}) : super(key: key);

  @override
  State<ArtistsScreen> createState() => _ArtistsScreenState();
}

class _ArtistsScreenState extends State<ArtistsScreen> {
  final ScrollController _scrollController = ScrollController();

  @override
  Widget build(BuildContext context) {
    return Consumer<MusicPlayerProvider>(
      builder: (context, musicProvider, child) {
        final artists = musicProvider.artists;
        final selectedIndex = musicProvider.selectedArtistIndex;

        WidgetsBinding.instance.addPostFrameCallback((_) {
          if (_scrollController.hasClients && selectedIndex != -1) {
            final itemHeight = 56.0; // Approximate height of an ExpansionTile
            final targetOffset = selectedIndex * itemHeight;
            _scrollController.animateTo(
              targetOffset,
              duration: const Duration(milliseconds: 300),
              curve: Curves.easeInOut,
            );
          }
        });

        if (artists.isEmpty) {
          return const Center(child: Text('No artists found'));
        }

        return ListView.builder(
          controller: _scrollController,
          itemCount: artists.length,
          itemBuilder: (context, index) {
            final artist = artists[index];
            final isSelected = index == selectedIndex;
            return Container(
              color: isSelected
                  ? Theme.of(context).primaryColor.withOpacity(0.2)
                  : null,
              child: ExpansionTile(
                key: Key(artist.name ?? ""),
                title: Text(
                  artist.name ?? "",
                  style: TextStyle(
                    fontWeight:
                        isSelected ? FontWeight.bold : FontWeight.normal,
                    color: isSelected ? Theme.of(context).primaryColor : null,
                  ),
                ),
                initiallyExpanded: isSelected,
                children: artist.songs
                        ?.map((song) => ListTile(
                              title: Text(song.title ?? ""),
                              onTap: () {
                                // musicProvider.playSong(song);
                                // musicProvider.setSelectedArtistIndex(index);
                              },
                            ))
                        .toList() ??
                    [],
              ),
            );
          },
        );
      },
    );
  }
}
