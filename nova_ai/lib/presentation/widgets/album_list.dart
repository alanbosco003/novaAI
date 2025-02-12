import 'package:flutter/material.dart';
import '../../data/models/album_model.dart';
import '../../data/models/image_model.dart';

class AlbumList extends StatelessWidget {
  final Map<Album, List<ImageModel>> albums;

  const AlbumList({super.key, required this.albums});

  @override
  Widget build(BuildContext context) {
    final albumEntries = albums.entries.toList();
    final loopedAlbums = albumEntries.take(4).toList();

    return SizedBox(
      height: MediaQuery.of(context).size.height,
      child: ListView.builder(
        itemCount: 1000, // Large number to simulate infinite scrolling
        itemBuilder: (context, index) {
          final album = loopedAlbums[index % loopedAlbums.length].key;
          final images = loopedAlbums[index % loopedAlbums.length].value;
          return AlbumTile(album: album, images: images);
        },
      ),
    );
  }
}
