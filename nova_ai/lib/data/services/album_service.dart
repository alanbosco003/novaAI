import 'package:nova_ver_1/core/repository/album_repository.dart';
import 'package:nova_ver_1/core/repository/image_repository.dart';

import '../../data/models/album_model.dart';
import '../../data/models/image_model.dart';

class AlbumService {
  final AlbumRepository albumRepository;
  final ImageRepository imageRepository;

  AlbumService(this.albumRepository, this.imageRepository);

  Future<Map<Album, List<ImageModel>>> fetchAlbumsWithImages() async {
    final albums = await albumRepository.fetchAlbums();
    Map<Album, List<ImageModel>> albumData = {};

    for (var album in albums) {
      final images = await imageRepository.fetchImages(album.id);
      albumData[album] = images;
    }

    return albumData;
  }
}
