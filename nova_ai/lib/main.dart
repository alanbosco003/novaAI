import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:nova_ai/core/database/database_service.dart';
import 'package:nova_ai/core/repository/album_repository.dart';
import 'package:nova_ai/core/repository/image_repository.dart';
import 'package:nova_ai/data/services/album_service.dart';
import 'package:nova_ai/logic/bloc/album/album_bloc.dart';
import 'package:nova_ai/presentation/screens/home_screen.dart';

void main() async {
  const String imageBoxName = 'imageBox';
  WidgetsFlutterBinding.ensureInitialized();

  await DatabaseService.incrementLaunchCount(); // Track app opens

  print("Launch Count after increment: ${DatabaseService.getLaunchCount()}");

  runApp(const MyApp()); // Now run the app
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (context) => AlbumBloc(
            AlbumService(
              AlbumRepository(),
              ImageRepository(),
            ),
          ),
        ),
      ],
      child: MaterialApp(
        title: 'Flutter Demo',
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
          useMaterial3: true,
        ),
        home: const HomeScreen(),
      ),
    );
  }
}
