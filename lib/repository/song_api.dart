import 'package:dio/dio.dart';
import 'package:music/model/song_model.dart';

class SongApi {
  static final SongApi _instance = SongApi._internal();
  late final Dio _dio;

  factory SongApi() {
    return _instance;
  }

  SongApi._internal() {
    _dio = Dio(BaseOptions(
      baseUrl: 'http://65.0.106.141',
      headers: {
        'Authorization':
            'Bearer eyJhbGciOiJIUzUxMiJ9.eyJzdWIiOiIxIiwiZW1haWwiOiJhbWFudGhhcGxpeWFsMTRAZ21haWwuY29tIiwicm9sZXMiOiJbQURNSU5dIiwiaWF0IjoxNzI2Njc4NDA1LCJleHAiOjYxNzI2MzIwMDAwfQ.boQNQzdUEtMthCS7_qqZpRoQLYdZCCb7GQ3mO1mq9YLeIEtUx_LAdn8JFrPxCnSM58rTC8izA7LGtjfcozH3cw',
      },
    ));
  }

  Future<List<SongModel>> fetchSongs() async {
    try {
      final response = await _dio.get('/api/songs');
      if (response.statusCode == 200) {
        final List<dynamic> songsJson = response.data['data'];
        return songsJson.map((json) => SongModel.fromJson(json)).toList();
      } else {
        throw Exception('Failed to load songs');
      }
    } catch (e) {
      throw Exception('Failed to load songs: $e');
    }
  }

  ///api/artists/all
  ///

  Future<List<Artists>> fetchArtists() async {
    try {
      final response = await _dio.get('/api/artists/all');
      if (response.statusCode == 200) {
        final List<dynamic> artistsJson = response.data['data'];
        return artistsJson.map((json) => Artists.fromJson(json)).toList();
      } else {
        throw Exception('Failed to load artists');
      }
    } catch (e) {
      throw Exception('Failed to load artists: $e');
    }
  }
}
