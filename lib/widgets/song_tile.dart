import 'package:flutter/material.dart';
import 'package:music/model/song_model.dart';

class SongTile extends StatelessWidget {
  const SongTile(
      {super.key,
      required this.songModel,
      required this.isSelected,
      this.padding});
  final SongModel songModel;
  final bool isSelected;
  final EdgeInsets? padding;

  @override
  Widget build(BuildContext context) {
    return Container(
      color: isSelected ? Colors.blue : null,
      child: ListTile(
        contentPadding: padding ?? EdgeInsets.symmetric(horizontal: 10),
        title: Text(
          songModel.title ?? "",
          style: TextStyle(
            color: isSelected ? Colors.white : Colors.black,
            fontSize: 14,
          ),
        ),
        subtitle: Text(
          songModel.artists?.map((e) => e.name).join(", ") ?? "",
          style: TextStyle(
            color: isSelected ? Colors.white70 : Colors.grey,
            fontSize: 12,
          ),
        ),
        trailing: IconButton(
          icon: Icon(
            songModel.isPlaying ? Icons.pause : Icons.play_arrow,
            color: isSelected ? Colors.white : Colors.black,
          ),
          onPressed: () {},
        ),
      ),
    );
  }
}
