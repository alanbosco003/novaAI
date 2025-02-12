import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:nova_ai/logic/bloc/album/album_bloc.dart';
import 'package:nova_ai/logic/bloc/album/album_event.dart';
import 'package:nova_ai/logic/bloc/album/album_state.dart';
import 'package:nova_ai/presentation/widgets/album_list.dart';
import 'package:nova_ai/presentation/widgets/error_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  void initState() {
    super.initState();
    context.read<AlbumBloc>().add(FetchAlbums());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Albums")),
      body: BlocBuilder<AlbumBloc, AlbumState>(
        builder: (context, state) {
          if (state is AlbumLoading) {
            return const Center(child: CircularProgressIndicator());
          } else if (state is AlbumError) {
            return ErrorView(message: state.message);
          } else if (state is AlbumSuccess) {
            return AlbumList(albums: state.albums);
          }
          return const SizedBox(); // Default empty state
        },
      ),
    );
  }
}
