
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'models/game_state.dart';
import 'providers/player_provider.dart';
import 'screens/player_setup_screen_wrapper.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => PlayerProvider(),
      child: Consumer<PlayerProvider>(
        builder: (context, playerProvider, child) => ChangeNotifierProvider(
          create: (context) => GameState(playerProvider: playerProvider),
          child: MaterialApp(
            title: 'Horse Race',
            theme: ThemeData(
              primarySwatch: Colors.blue,
            ),
            home: const PlayerSetupScreenWrapper(),
          ),
        ),
      ),
    );
  }
}
