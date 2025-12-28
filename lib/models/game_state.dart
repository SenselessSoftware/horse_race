
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:horse_race/providers/player_provider.dart';
import 'package:horse_race/services/settings_service.dart';
import 'package:player_model/player.dart';

import 'horse.dart';

class GameState with ChangeNotifier {
  final PlayerProvider playerProvider;
  final SettingsService _settingsService = SettingsService();

  GameState({required this.playerProvider});

  final List<Horse> horses = [
    Horse(id: '1', name: 'Horse 1', imagePath: 'assets/images/hr1.png'),
    Horse(id: '2', name: 'Horse 2', imagePath: 'assets/images/hr2.png'),
    Horse(id: '3', name: 'Horse 3', imagePath: 'assets/images/hr3.png'),
    Horse(id: '4', name: 'Horse 4', imagePath: 'assets/images/hr4.png'),
    Horse(id: '5', name: 'Horse 5', imagePath: 'assets/images/hr5.png'),
    Horse(id: '6', name: 'Horse 6', imagePath: 'assets/images/hr6.png'),
  ];

  final Map<String, String?> playerHorseSelection = {};
  List<int> diceRolls = [];

  void selectHorse(String playerId, String horseId) {
    playerHorseSelection[playerId] = horseId;
    notifyListeners();
  }

  void clearSelections() {
    playerHorseSelection.clear();
    notifyListeners();
  }

  void startRace() {
    for (var horse in horses) {
      horse.position = 0;
    }
    diceRolls.clear();
    notifyListeners();
  }

  void rollDiceAndMoveHorses() async {
    if (winners.isNotEmpty) return;

    final random = Random();
    final dice1 = random.nextInt(6) + 1;
    final dice2 = random.nextInt(6) + 1;
    final dice3 = random.nextInt(6) + 1;

    diceRolls = [dice1, dice2, dice3];

    moveHorse(dice1);
    moveHorse(dice2);
    moveHorse(dice3);

    if (winners.isNotEmpty) {
      final winValue = await _settingsService.getHorseRaceWinValue();
      playerProvider.updateScoresForWinners(winningPlayers, winValue);
    }

    notifyListeners();
  }

  void moveHorse(int horseNumber) {
    if (horseNumber >= 1 && horseNumber <= horses.length) {
      horses[horseNumber - 1].position++;
    }
  }

  void resetRace() {
    for (var horse in horses) {
      horse.position = 0;
    }
    diceRolls.clear();
    notifyListeners();
  }

  List<Horse> get winners {
    return horses.where((horse) => horse.position >= 8).toList();
  }

  List<Player> get winningPlayers {
    if (winners.isEmpty) return [];

    final winningHorseIds = winners.map((h) => h.id).toSet();
    return playerProvider.players.where((player) {
      return winningHorseIds.contains(playerHorseSelection[player.id]);
    }).toList();
  }
}
