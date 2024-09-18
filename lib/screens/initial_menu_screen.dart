import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../provider/music_player_provider.dart';

class InitialMenuScreen extends StatefulWidget {
  const InitialMenuScreen({super.key});

  @override
  State<InitialMenuScreen> createState() => _InitialMenuScreenState();
}

class _InitialMenuScreenState extends State<InitialMenuScreen> {
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
        final selectedIndex = provider.showSongs
            ? provider.selectedSongIndex
            : provider.selectedIndex;
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
      physics: const ClampingScrollPhysics(),
      controller: scrollController,
      itemCount: provider.menuItems.length,
      itemBuilder: (context, index) {
        return Container(
          color: provider.selectedIndex == index ? Colors.blue : null,
          child: ListTile(
            title: Text(
              provider.menuItems[index],
              style: TextStyle(
                color: provider.selectedIndex == index
                    ? Colors.white
                    : Colors.black,
              ),
            ),
          ),
        );
      },
    );
  }
}
