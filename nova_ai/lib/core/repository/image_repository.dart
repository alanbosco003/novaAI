import 'dart:typed_data';
import 'package:dio/dio.dart';
import 'package:nova_ai/core/database/database_service.dart';
import '../../data/models/image_model.dart';
import 'package:http/http.dart' as http;

class ImageRepository {
  final Dio _dio = Dio(BaseOptions(
      baseUrl:
          "https://my-express-a2szfa4jo-alanbosco003s-projects.vercel.app/"));

  Future<List<ImageModel>> fetchImages(int albumId) async {
    try {
      // ✅ First, try loading from cache
      final cachedImages = await DatabaseService.getImages(albumId);
      if (cachedImages.isNotEmpty) {
        print("✅ Using cached images for album $albumId");
        return cachedImages;
      }

      // ⚠️ If no cache, fetch from API
      print("⚠️ Fetching fresh images for album $albumId...");
      final response =
          await _dio.get('/photos', queryParameters: {'albumId': albumId});

      List<ImageModel> images = [];
      for (var json in response.data) {
        // Download the image
        Uint8List imageBytes = await _downloadImage(json['url']);

        // Convert JSON to ImageModel with bytes
        images.add(ImageModel(
          id: json['id'],
          albumId: json['albumId'],
          title: json['title'],
          imageBytes: imageBytes,
        ));
      }

      // ✅ Save to cache
      await DatabaseService.saveImages(albumId, images);

      return images;
    } catch (e) {
      print("❌ Failed to fetch images: $e");
      return [];
    }
  }

  // Helper method to download image bytes
  Future<Uint8List> _downloadImage(String imageUrl) async {
    final response = await http.get(Uri.parse(imageUrl));
    if (response.statusCode == 200) {
      return response.bodyBytes; // Convert image to bytes
    } else {
      throw Exception("Failed to load image");
    }
  }
}
