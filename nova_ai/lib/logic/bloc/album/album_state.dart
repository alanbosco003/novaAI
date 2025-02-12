import 'package:equatable/equatable.dart';
import '../../../data/models/album_model.dart';
import '../../../data/models/image_model.dart';

abstract class AlbumState extends Equatable {
  @override
  List<Object?> get props => [];
}

class AlbumLoading extends AlbumState {}

class AlbumSuccess extends AlbumState {
  final Map<Album, List<ImageModel>> albums;

  AlbumSuccess(this.albums);

  @override
  List<Object?> get props => [albums];
}

class AlbumError extends AlbumState {
  final String message;

  AlbumError(this.message);

  @override
  List<Object?> get props => [message];
}
