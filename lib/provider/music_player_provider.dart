import 'package:flutter/foundation.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';
import 'package:music/model/song_model.dart';
import 'package:music/screens/artists_screen.dart';
import '../foreground_task.dart';
import '../interfaces/imusic_player.dart';
import '../player/audio_player_adapter.dart';
import '../repository/song_api.dart';

import '../screens/initial_menu_screen.dart';
import '../screens/music_songs_screen.dart';

import 'package:flutter_foreground_task/flutter_foreground_task.dart';

class Song {
  final String title;
  final String artist;
  final String audioPath;

  Song({required this.title, required this.artist, required this.audioPath});
}

class MusicPlayerProvider extends ChangeNotifier {
  final SongApi _songApi = SongApi();
  final IMusicPlayer _musicPlayer = AudioPlayerAdapter();
  final List<String> _menuItems = [
    'Playlists',
    'Artists',
    'Songs',
    'Contacts',
    'Settings'
  ];

  int _selectedIndex = 0;
  int _selectedSongIndex = 0;
  int _selectedArtistIndex = 0;
  List<SongModel> _songs = [];
  List<Artists> _artists = [];
  bool _showSongs = false;
  bool _showArtists = false;
  Widget _currentScreen = const InitialMenuScreen();
  String _currentScreenTitle = 'Music';

  // Getters
  int get selectedIndex => _selectedIndex;
  int get selectedSongIndex => _selectedSongIndex;
  int get selectedArtistIndex => _selectedArtistIndex;
  List<String> get menuItems => _menuItems;
  List<SongModel> get songs => _songs;
  List<Artists> get artists => _artists;
  bool get showSongs => _showSongs;
  bool get showArtists => _showArtists;
  IMusicPlayer get musicPlayer => _musicPlayer;
  Widget get currentScreen => _currentScreen;
  String get currentScreenTitle => _currentScreenTitle;

  final List<Map<String, dynamic>> _undoStack = [];

  // Singleton implementation
  static final MusicPlayerProvider _instance = MusicPlayerProvider._internal();
  factory MusicPlayerProvider() => _instance;
  MusicPlayerProvider._internal();

  void handleCenterButtonTap(BuildContext context) {
    if (currentScreen is ArtistsScreen) {
      _saveState();
    }
    selectMenuItem(context);
  }

  void _saveState() {
    _undoStack.add({
      'selectedIndex': _selectedIndex,
      'selectedSongIndex': _selectedSongIndex,
      'selectedArtistIndex': _selectedArtistIndex,
      'showSongs': _showSongs,
      'showArtists': _showArtists,
      'currentScreen': _currentScreen,
      'currentScreenTitle': _currentScreenTitle,
    });
  }

  void moveSelection(int direction) {
    int newIndex;
    int maxIndex;

    if (_showSongs) {
      newIndex = _selectedSongIndex + direction;
      maxIndex = _songs.length;
      if (newIndex >= 0 && newIndex < maxIndex) _selectedSongIndex = newIndex;
    } else if (_showArtists) {
      newIndex = _selectedArtistIndex + direction;
      maxIndex = _artists.length;
      if (newIndex >= 0 && newIndex < maxIndex) _selectedArtistIndex = newIndex;
    } else {
      newIndex = _selectedIndex + direction;
      maxIndex = _menuItems.length;
      if (newIndex >= 0 && newIndex < maxIndex) _selectedIndex = newIndex;
    }

    notifyListeners();
  }

  void selectMenuItem(BuildContext context) {
    if (menuItems[selectedIndex] == 'Songs') {
      _handleSongsSelection();
    } else if (menuItems[selectedIndex] == 'Artists') {
      _handleArtistsSelection();
    }
  }

  void _handleSongsSelection() {
    if (_showSongs) {
      _toggleSongPlayback();
    } else {
      _showSongs = true;
      setCurrentScreen(const MusicSongsScreen(), 'Songs');
      loadSongs();
    }
    notifyListeners();
  }

  void _handleArtistsSelection() {
    if (_showArtists) {
      // _toggleArtistSelection();
      if (artists.isNotEmpty) {
        _showSongs = true;
        _selectedIndex = 2;
        _selectedSongIndex = 0;
        setCurrentScreen(const MusicSongsScreen(), 'Songs');
        _songs.clear();
        loadSongs(songs: artists[_selectedArtistIndex].songs!);
        notifyListeners();
      }
    } else {
      _showArtists = true;
      setCurrentScreen(const ArtistsScreen(), 'Artists');
      loadArtists();
    }
    notifyListeners();
  }

  // void _toggleArtistSelection() {
  //   final selectedArtist = _artists[_selectedArtistIndex];
  //   _artists.forEach((artist) => artist.isSelected = false);
  //   selectedArtist.isSelected = !selectedArtist.isSelected;
  // }

  void goBack() {
    if (_undoStack.isNotEmpty) {
      final previousState = _undoStack.removeLast();
      _selectedIndex = previousState['selectedIndex'];
      _selectedSongIndex = previousState['selectedSongIndex'];
      _selectedArtistIndex = previousState['selectedArtistIndex'];
      _showSongs = previousState['showSongs'];
      _showArtists = previousState['showArtists'];
      _currentScreen = previousState['currentScreen'];
      _currentScreenTitle = previousState['currentScreenTitle'];
      notifyListeners();
    } else {
      // If the undo stack is empty, perform the original goBack logic
      if (_showSongs || _showArtists) {
        _showSongs = false;
        _showArtists = false;
        setCurrentScreen(const InitialMenuScreen(), 'Music');
        notifyListeners();
      }
    }
  }

  Future<void> loadSongs({List<SongModel>? songs}) async {
    try {
      if (songs != null && songs.isNotEmpty) {
        _songs = songs;
      } else {
        _songs = await _songApi.fetchSongs();
      }

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

  SongModel? _currentlyPlayingSong;
  bool _isPlaying = false;

  SongModel? get currentlyPlayingSong => _currentlyPlayingSong;
  bool get isPlaying => _isPlaying;

  void playSong(SongModel song) {
    _currentlyPlayingSong = song;
    _isPlaying = true;
    _musicPlayer.play(song.url!);
    startForegroundTask();
    notifyListeners();
  }

  void stopSong() {
    _currentlyPlayingSong = null;
    _isPlaying = false;
    _musicPlayer.stop();
    stopForegroundTask();
    notifyListeners();
  }

  void _toggleSongPlayback() {
    final selectedSong = _songs[_selectedSongIndex];

    if (_currentlyPlayingSong?.id == selectedSong.id) {
      if (_isPlaying) {
        stopSong();
      } else {
        playSong(selectedSong);
        listenEndStream();
      }
    } else {
      stopSong();
      playSong(selectedSong);
      listenEndStream();
    }
  }

  void listenEndStream() {
    _musicPlayer.onPlayerComplete.listen((_) {
      stopSong();
    }).onDone(() {});
  }

  bool isScrollerAtCurrentlyPlayingSong() {
    if (_currentlyPlayingSong == null) {
      return false;
    }
    return _selectedSongIndex == _songs.indexOf(_currentlyPlayingSong!);
  }

  void startForegroundTask() {
    FlutterForegroundTask.init(
      androidNotificationOptions: AndroidNotificationOptions(
        channelId: 'music_player_notification',
        channelName: 'Music Player Notification',
        channelDescription:
            'This notification appears when the music player is running in the background.',
        channelImportance: NotificationChannelImportance.LOW,
        priority: NotificationPriority.LOW,
        iconData: const NotificationIconData(
          resType: ResourceType.mipmap,
          resPrefix: ResourcePrefix.ic,
          name: 'launcher',
        ),
      ),
      iosNotificationOptions: const IOSNotificationOptions(
        showNotification: true,
        playSound: false,
      ),
      foregroundTaskOptions: const ForegroundTaskOptions(
        interval: 5000,
        isOnceEvent: false,
        autoRunOnBoot: true,
        allowWakeLock: true,
        allowWifiLock: true,
      ),
    );

    FlutterForegroundTask.startService(
      notificationTitle: 'Music Player',
      notificationText: 'Playing in the background',
      callback: startCallback,
    );
  }

  void stopForegroundTask() {
    FlutterForegroundTask.stopService();
  }
}
