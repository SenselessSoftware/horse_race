import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:player_model/screens/player_setup_screen.dart' as pkg;
import 'package:horse_race/screens/race_screen.dart';
import '../providers/player_provider.dart';
import '../screens/settings_screen.dart';
import '../services/settings_service.dart';


class PlayerSetupScreenWrapper extends StatelessWidget {
  const PlayerSetupScreenWrapper({super.key});

  @override
  Widget build(BuildContext context) {
    final playerProvider = Provider.of<PlayerProvider>(context);
//    final settingsService = Provider.of<SettingsService>(context, listen: false);

    return pkg.PlayerSetupScreen(
      players: playerProvider.players,
      onPlayersUpdated: (updatedPlayers) {
        for (int i = 0; i < updatedPlayers.length; i++) {
          if (i < playerProvider.players.length) {
            playerProvider.updatePlayer(i, updatedPlayers[i]);
          } else {
            playerProvider.addPlayer(updatedPlayers[i]);
          }
        }
      },
      onContinue: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => const RaceScreen(),
          ),
        );
      },
      startingScore: 0,
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