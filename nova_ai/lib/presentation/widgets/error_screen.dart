import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:nova_ai/logic/bloc/album/album_bloc.dart';
import 'package:nova_ai/logic/bloc/album/album_event.dart';

class ErrorView extends StatelessWidget {
  final String message;

  const ErrorView({super.key, required this.message});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(Icons.error, color: Colors.red, size: 50),
          const SizedBox(height: 10),
          Text(message,
              style: const TextStyle(color: Colors.red, fontSize: 16)),
          const SizedBox(height: 10),
          ElevatedButton(
            onPressed: () {
              context.read<AlbumBloc>().add(FetchAlbums()); // Retry fetching
            },
            child: const Text("Retry"),
          ),
        ],
      ),
    );
  }
}
