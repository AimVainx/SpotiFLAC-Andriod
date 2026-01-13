import 'package:dio/dio.dart';
import 'package:path_provider/path_provider.dart';
import 'dart:io';

class DownloadService {
  final Dio _dio = Dio();

  Future<String?> downloadFile(String url, String fileName, Function(int, int) onProgress) async {
    try {
      final dir = await getApplicationDocumentsDirectory(); // Or getExternalStorageDirectory on Android
      final savePath = '${dir.path}/$fileName';
      
      await _dio.download(
        url, 
        savePath,
        onReceiveProgress: onProgress,
      );
      
      return savePath;
    } catch (e) {
      print("Download failed: $e");
      return null;
    }
  }
}
