import 'dart:convert';
import 'package:dio/dio.dart';
import 'package:logger/logger.dart';

class SongLinkService {
  final Dio _dio = Dio();
  final Logger _logger = Logger();

  Future<String?> getTidalUrl(String spotifyId) async {
    final spotifyUrl = 'https://open.spotify.com/track/$spotifyId';
    final modSpotifyUrl = Uri.encodeComponent(spotifyUrl);
    final apiUrl = 'https://api.song.link/v1-alpha.1/links?url=$modSpotifyUrl';

    try {
      final response = await _dio.get(apiUrl);
      if (response.statusCode == 200) {
        final data = response.data;
        final links = data['linksByPlatform'];
        if (links != null && links.containsKey('tidal')) {
           return links['tidal']['url'];
        }
      }
    } catch (e) {
      _logger.e("SongLink lookup failed: $e");
    }
    return null;
  }
}
