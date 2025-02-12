import 'package:flutter_bloc/flutter_bloc.dart';
import 'album_event.dart';
import 'album_state.dart';
import '../../../data/services/album_service.dart';

class AlbumBloc extends Bloc<AlbumEvent, AlbumState> {
  final AlbumService albumService;

  AlbumBloc(this.albumService) : super(AlbumLoading()) {
    on<FetchAlbums>(_onFetchAlbums);
  }

  Future<void> _onFetchAlbums(
      FetchAlbums event, Emitter<AlbumState> emit) async {
    try {
      emit(AlbumLoading());
      final albumsWithImages = await albumService.fetchAlbumsWithImages();
      emit(AlbumSuccess(albumsWithImages));
    } catch (e) {
      emit(AlbumError("Failed to fetch albums: ${e.toString()}"));
    }
  }
}
