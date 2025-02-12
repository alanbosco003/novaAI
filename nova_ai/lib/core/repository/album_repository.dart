import 'package:dio/dio.dart';
import '../database/database_service.dart';
import '../../data/models/album_model.dart';

class AlbumRepository {
  final Dio _dio =
      Dio(BaseOptions(baseUrl: "https://jsonplaceholder.typicode.com"));

  Future<List<Album>> fetchAlbums() async {
    int launchCount = await DatabaseService.getLaunchCount();
    print("Launch Count: $launchCount");

    // Load from cache if app is opened less than 4 times
    if (launchCount < 4) {
      final cachedAlbums = await DatabaseService.getAlbums();
      print("Cached Albums Count: ${cachedAlbums.length}");

      if (cachedAlbums.isNotEmpty) {
        print("✅ Using Cached Data");
        return cachedAlbums;
      }
    }

    // Fetch fresh data on 4th launch
    print("⚠️ Fetching fresh data from API...");
    final response = await _dio.get('/albums', queryParameters: {'_limit': 4});
    final List<Album> albums =
        (response.data as List).map((json) => Album.fromJson(json)).toList();

    // Save new data
    await DatabaseService.saveAlbums(albums);
    await DatabaseService.resetLaunchCount();

    return albums;
  }
}
