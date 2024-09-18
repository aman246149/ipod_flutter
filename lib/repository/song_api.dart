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
            'Bearer eyJhbGciOiJIUzUxMiJ9.eyJzdWIiOiIxIiwiZW1haWwiOiJhbWFudGhhcGxpeWFsMTRAZ21haWwuY29tIiwicm9sZXMiOiJbQURNSU5dIiwiaWF0IjoxNzI2NjQ0NjQzLCJleHAiOjYxNzI2MzIwMDAwfQ.cdymNrbZHNUDK6VbA9JRdbBH3rnpZCscDLzQ57kJ2aAkVj1KlWQYLPTBeO5TCgENndRpGPS6Jh8mv0uj1OqHiw',
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
}
