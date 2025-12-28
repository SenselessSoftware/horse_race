import 'package:horse_race/screens/race_screen.dart';

import '../providers/player_provider.dart';
import '../screens/settings_screen.dart';
import 'package:flutter/material.dart';
import 'package:player_model/screens/player_setup_screen.dart' as pkg;
import 'package:provider/provider.dart';

class PlayerSetupScreenWrapper extends StatelessWidget {
  const PlayerSetupScreenWrapper({super.key});

  @override
  Widget build(BuildContext context) {
    final playerProvider = Provider.of<PlayerProvider>(context);

    return pkg.PlayerSetupScreen(
      players: playerProvider.players,
      onPlayersUpdated: (updatedPlayers) {
        playerProvider.setPlayers(updatedPlayers);
      },
      onContinue: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => const RaceScreen(),
          ),
        );
      },
      onSettingsPressed: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => const SettingsScreen(),
          ),
        );
      },
    );
  }
}
