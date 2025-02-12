class Album {
  final int id;
  final String title;

  Album({required this.id, required this.title});

  // ✅ Convert Album object to JSON (Map<String, dynamic>)
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
    };
  }

  // ✅ Convert JSON (Map<String, dynamic>) to Album object
  factory Album.fromJson(Map<String, dynamic> json) {
    return Album(
      id: json['id'],
      title: json['title'],
    );
  }
}
