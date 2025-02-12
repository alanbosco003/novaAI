import 'dart:typed_data';

class ImageModel {
  final int id;
  final int albumId;
  final String title;
  final Uint8List imageBytes; // Store image as bytes

  ImageModel({
    required this.id,
    required this.albumId,
    required this.title,
    required this.imageBytes,
  });

  // Convert object to Map for SQLite
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'albumId': albumId,
      'title': title,
      'imageBytes': imageBytes, // Save bytes to DB
    };
  }

  // Convert Map from SQLite to ImageModel
  factory ImageModel.fromJson(Map<String, dynamic> json) {
    return ImageModel(
      id: json['id'],
      albumId: json['albumId'],
      title: json['title'],
      imageBytes: json['imageBytes'], // Load bytes from DB
    );
  }
}
