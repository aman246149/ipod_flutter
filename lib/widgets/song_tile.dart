import 'dart:async';
import 'package:flutter/material.dart';
import 'package:music/model/song_model.dart';
import 'package:provider/provider.dart';
import '../provider/music_player_provider.dart';

class SongTile extends StatefulWidget {
  const SongTile({
    super.key,
    required this.songModel,
    required this.isSelected,
    this.padding,
  });

  final SongModel songModel;
  final bool isSelected;
  final EdgeInsets? padding;

  @override
  SongTileState createState() => SongTileState();
}

class SongTileState extends State<SongTile> {
  late Timer _timer;
  Duration _position = Duration.zero;
  Duration _duration = Duration.zero;

  @override
  void initState() {
    super.initState();
    _startTimer();
  }

  @override
  void dispose() {
    _timer.cancel();
    super.dispose();
  }

  void _startTimer() {
    _timer = Timer.periodic(Duration(milliseconds: 500), (timer) async {
      if (mounted) {
        final provider =
            Provider.of<MusicPlayerProvider>(context, listen: false);
        final position =
            await provider.musicPlayer.getPosition() ?? Duration.zero;
        final duration =
            await provider.musicPlayer.getDuration() ?? Duration.zero;
        setState(() {
          _position = position;
          _duration = duration;
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<MusicPlayerProvider>(context);
    return Container(
      color: widget.isSelected ? Colors.blue : null,
      child: Column(
        children: [
          ListTile(
            contentPadding:
                widget.padding ?? EdgeInsets.symmetric(horizontal: 10),
            title: Text(
              widget.songModel.title ?? "",
              style: TextStyle(
                color: widget.isSelected ? Colors.white : Colors.black,
                fontSize: 14,
                fontWeight: FontWeight.bold,
              ),
            ),
            subtitle: Text(
              widget.songModel.artists?.map((e) => e.name).join(", ") ?? "",
              style: TextStyle(
                color: widget.isSelected ? Colors.white : Colors.grey,
                fontSize: 12,
              ),
            ),
            trailing: IconButton(
              icon: Icon(
                provider.isPlaying && provider.currentlyPlayingSong?.id == widget.songModel.id ? Icons.pause : Icons.play_arrow,
                color: widget.isSelected ? Colors.white : Colors.black,
              ),
              onPressed: () {
                // Toggle play/pause
              },
            ),
          ),
          if (
            provider.isScrollerAtCurrentlyPlayingSong() &&
             provider.isPlaying && provider.currentlyPlayingSong?.id == widget.songModel.id) ...[
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 16),
              child: Column(
                children: [
                  LinearProgressIndicator(
                    value: _duration.inMilliseconds > 0
                        ? _position.inMilliseconds / _duration.inMilliseconds
                        : 0,
                    backgroundColor: Colors.grey[300],
                    valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                    minHeight: 3,
                  ),
                  SizedBox(height: 4),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        _formatDuration(_position),
                        style: TextStyle(fontSize: 10, color: Colors.white),
                      ),
                      Text(
                        _formatDuration(_duration),
                        style: TextStyle(fontSize: 10, color: Colors.white),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            SizedBox(height: 8),
          ],
        ],
      ),
    );
  }

  String _formatDuration(Duration duration) {
    String twoDigits(int n) => n.toString().padLeft(2, "0");
    String twoDigitMinutes = twoDigits(duration.inMinutes.remainder(60));
    String twoDigitSeconds = twoDigits(duration.inSeconds.remainder(60));
    return "$twoDigitMinutes:$twoDigitSeconds";
  }
}
