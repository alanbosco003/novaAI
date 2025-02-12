import 'package:flutter/material.dart';
import 'package:nova_ai/data/models/album_model.dart';
import 'package:nova_ai/data/models/image_model.dart';

class AlbumTile extends StatelessWidget {
  final Album album;
  final List<ImageModel> images;

  const AlbumTile({super.key, required this.album, required this.images});

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    double imageWidth = screenWidth / 3; // 3 images visible at a time

    return SizedBox(
      height: MediaQuery.of(context).size.height /
          4.1, // 4 albums visible at a time
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.only(bottom: 10, left: 5),
            child: Text(
              album.title,
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
          ),
          SizedBox(
            height: 100,
            child: images.isEmpty
                ? const Center(
                    child: Text("No images available")) // ✅ Prevent crash
                : ListView.builder(
                    scrollDirection: Axis.horizontal,
                    itemCount: 1000, // Large number for infinite scroll effect
                    itemBuilder: (context, index) {
                      final image = images[index % images.length]; // ✅ Safe now
                      return Padding(
                        padding: const EdgeInsets.only(right: 5),
                        child: SizedBox(
                          width: imageWidth,
                          child: Image.memory(
                            image.imageBytes,
                            fit: BoxFit.cover,
                          ),
                        ),
                      );
                    },
                  ),
          ),
          const Padding(
            padding: EdgeInsets.all(8.0),
            child: Divider(
              thickness: 2,
              color: Colors.grey,
            ),
          )
        ],
      ),
    );
  }
}
