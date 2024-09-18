import 'package:flutter/foundation.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';
import 'package:music/model/song_model.dart';
import 'package:music/screens/artists_screen.dart';
import '../interfaces/imusic_player.dart';
import '../player/audio_player_adapter.dart';
import '../player/just_audio_adapter.dart';
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
  List<Artists> _artists = [];
  IMusicPlayer _musicPlayer = AudioPlayerAdapter();
  int _selectedArtistIndex = 0;
  Widget _currentScreen = const InitialMenuScreen();
  String _currentScreenTitle = 'iPod';

  Widget get currentScreen => _currentScreen;
  String get currentScreenTitle => _currentScreenTitle;

  bool get isPlaying => _isPlaying;
  int get selectedIndex => _selectedIndex;
  int get selectedSongIndex => _selectedSongIndex;
  int get selectedArtistIndex => _selectedArtistIndex;
  bool _showSongs = false;
  bool _showArtists = false;
  List<String> get menuItems => _menuItems;
  List<SongModel> get songs => _songs;
  List<Artists> get artists => _artists;
  bool get showSongs => _showSongs;
  bool get showArtists => _showArtists;

  DateTime? _lastTapTime;

  //make musicprovider a singleton
  static final MusicPlayerProvider _instance = MusicPlayerProvider._internal();
  factory MusicPlayerProvider() {
    return _instance;
  }
  MusicPlayerProvider._internal();

  void handleCenterButtonTap(BuildContext context) {
    selectMenuItem(context);
  }

  void moveSelection(int direction) {
    if (_showSongs) {
      int newIndex = _selectedSongIndex + direction;
      if (newIndex >= 0 && newIndex < _songs.length) {
        _selectedSongIndex = newIndex;

        notifyListeners();
      }
    } else if (_showArtists) {
      int newIndex = _selectedArtistIndex + direction;
      if (newIndex >= 0 && newIndex < _artists.length) {
        _selectedArtistIndex = newIndex;

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
      if (_showSongs) {
        print(_songs[selectedSongIndex].isPlaying);
        if (_songs[selectedSongIndex].isPlaying == false) {
          _musicPlayer.play(_songs[selectedSongIndex].url!);
          _songs[selectedSongIndex].isPlaying = true;
        } else {
          _musicPlayer.stop();
          _songs[selectedSongIndex].isPlaying = false;
        }
        notifyListeners();
        return;
      }

      _showSongs = true;

      setCurrentScreen(const MusicSongsScreen(), 'Songs');
      loadSongs();
      notifyListeners();
    } else if (menuItems[selectedIndex] == 'Artists') {
      if (_showArtists) {
        if (_artists[selectedArtistIndex].isSelected == false) {
          for (var artist in _artists) {
            artist.isSelected = false;
          }
          _artists[selectedArtistIndex].isSelected = true;
        } else {
          for (var artist in _artists) {
            artist.isSelected = false;
          }
        }
        notifyListeners();
        return;
      }

      _showArtists = true;

      setCurrentScreen(const ArtistsScreen(), 'Artists');
      loadArtists();
      notifyListeners();
    }
  }

  void goBack() {
    if (_showSongs) {
      _showSongs = false;
      setCurrentScreen(const InitialMenuScreen(), 'iPod');
      notifyListeners();
    } else if (_showArtists) {
      _showArtists = false;
      setCurrentScreen(const InitialMenuScreen(), 'iPod');
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

  Future<void> loadArtists() async {
    try {
      _artists = await _songApi.fetchArtists();
      notifyListeners();
    } catch (e) {
      print('Error loading artists: $e');
      // Handle error (e.g., show an error message to the user)
    }
  }

  void setCurrentScreen(Widget screen, String title) {
    _currentScreen = screen;
    _currentScreenTitle = title;
    notifyListeners();
  }
}
