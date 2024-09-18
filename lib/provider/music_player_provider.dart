import 'package:flutter/foundation.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';
import 'package:music/model/song_model.dart';
import '../repository/song_api.dart';

import '../screens/initial_menu_screen.dart';
import '../screens/music_songs_screen.dart';

class Song {
  final String title;
  final String artist;
  final String audioPath;

  Song({required this.title, required this.artist, required this.audioPath});
}

class MusicPlayerProvider extends ChangeNotifier {
  final AudioPlayer _audioPlayer = AudioPlayer();
  bool _isPlaying = false;
  int _selectedIndex = 0;
  int _selectedSongIndex = 0;
  final SongApi _songApi = SongApi();
  final List<String> _menuItems = [
    'Playlists',
    'Artists',
    'Songs',
    'Contacts',
    'Settings'
  ];
  List<SongModel> _songs = [];

  Widget _currentScreen = const InitialMenuScreen();
  String _currentScreenTitle = 'iPod';

  Widget get currentScreen => _currentScreen;
  String get currentScreenTitle => _currentScreenTitle;

  bool get isPlaying => _isPlaying;
  int get selectedIndex => _selectedIndex;
  int get selectedSongIndex => _selectedSongIndex;
  bool _showSongs = false;
  List<String> get menuItems => _menuItems;
  List<SongModel> get songs => _songs;
  bool get showSongs => _showSongs;

  DateTime? _lastTapTime;

  //make musicprovider a singleton
  static final MusicPlayerProvider _instance = MusicPlayerProvider._internal();
  factory MusicPlayerProvider() {
    return _instance;
  }
  MusicPlayerProvider._internal();

  void handleCenterButtonTap(BuildContext context) {
    final now = DateTime.now();
    if (_lastTapTime != null &&
        now.difference(_lastTapTime!) < Duration(milliseconds: 300)) {
    } else {
      selectMenuItem(context);
    }
    _lastTapTime = now;
  }

  void togglePlayPause() {
    _isPlaying = !_isPlaying;
    if (_isPlaying) {
      _audioPlayer.play(UrlSource(_songs[_selectedSongIndex].url!));
    } else {
      _audioPlayer.pause();
    }
    notifyListeners();
  }

  void moveSelection(int direction) {
    if (_showSongs) {
      int newIndex = _selectedSongIndex + direction;
      if (newIndex >= 0 && newIndex < _songs.length) {
        _selectedSongIndex = newIndex;
        notifyListeners();
      }
    } else {
      int newIndex = _selectedIndex + direction;
      if (newIndex >= 0 && newIndex < _menuItems.length) {
        _selectedIndex = newIndex;
        notifyListeners();
      }
    }
  }

  void selectMenuItem(BuildContext context) {
    if (menuItems[selectedIndex] == 'Songs') {
      _showSongs = true;

      setCurrentScreen(const MusicSongsScreen(), 'Songs');
      loadSongs();
      notifyListeners();
    }
  }

  void goBack() {
    if (_showSongs) {
      _showSongs = false;
      notifyListeners();
    }
  }

  void nextTrack() {
    if (_selectedSongIndex < _songs.length - 1) {
      _selectedSongIndex++;
      if (_isPlaying) {
        _audioPlayer.play(UrlSource(_songs[_selectedSongIndex].url!));
      }
      notifyListeners();
    }
  }

  void previousTrack() {
    if (_selectedSongIndex > 0) {
      _selectedSongIndex--;
      if (_isPlaying) {
        _audioPlayer.play(UrlSource(_songs[_selectedSongIndex].url!));
      }
      notifyListeners();
    }
  }

  Future<void> loadSongs() async {
    try {
      _songs = await _songApi.fetchSongs();
      notifyListeners();
    } catch (e) {
      print('Error loading songs: $e');
      // Handle error (e.g., show an error message to the user)
    }
  }

  void setCurrentScreen(Widget screen, String title) {
    _currentScreen = screen;
    _currentScreenTitle = title;
    notifyListeners();
  }
}
