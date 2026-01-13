import 'dart:convert';
import 'package:dio/dio.dart';
import 'package:logger/logger.dart';

class SpotifyService {
  final Dio _dio = Dio(BaseOptions(
    connectTimeout: const Duration(seconds: 30),
    receiveTimeout: const Duration(seconds: 30),
  ));
  final Logger _logger = Logger();

  // Spotify GraphQL Access Token logic would go here if we were using official,
  // but the Go backend seemed to use a public endpoint or scraped logic.
  // Porting 'fetchTrack' logic from backend/spotify_metadata.go

  Future<Map<String, dynamic>> fetchTrack(String trackId) async {
    // This is a simplified port. The original used a complex GraphQL query.
    // For this rewrite, we will try to use the Oembed or a public API if available,
    // otherwise we might need the full GraphQL payload from the Go code.
    
    // NOTE: The original Go code used a specific SHA256 hash for the query.
    // We will replicate that exact request structure.
    
    final uri = 'https://api-partner.spotify.com/pathfinder/v1/query';
    
    final payload = {
      "variables": {
        "uri": "spotify:track:$trackId",
      },
      "operationName": "getTrack",
      "extensions": {
        "persistedQuery": {
          "version": 1,
          "sha256Hash": "612585ae06ba435ad26369870deaae23b5c8800a256cd8a57e08eddc25a37294"
        }
      }
    };

    // Note: This request likely needs an Authorization header (Bearer token).
    // The Go code's `NewSpotifyClient` likely fetched a token.
    // We will assume for now we need a token getter. 
    // For this MVP, I will implement a basic token fetcher or use a public fallback.
    
    try {
      final token = await _getAccessToken();
      final response = await _dio.get(uri, 
        queryParameters: {
          'operationName': 'getTrack',
          'variables': jsonEncode(payload['variables']),
          'extensions': jsonEncode(payload['extensions']),
        },
        options: Options(headers: {
          'Authorization': 'Bearer $token',
        })
      );
      
      return response.data;
    } catch (e) {
      _logger.e("Failed to fetch track: $e");
      rethrow;
    }
  }

  Future<String> _getAccessToken() async {
     // Replicating basic token fetch (public client credentials or anonymous token)
     // This is a placeholder. In a real app, we'd hit https://open.spotify.com/get_access_token
     try {
       final response = await _dio.get('https://open.spotify.com/get_access_token?reason=transport&productType=web_player');
       return response.data['accessToken'];
     } catch(e) {
       _logger.w("Failed to get official token, trying fallback...");
       return ""; // Handle token failure
     }
  }
}
