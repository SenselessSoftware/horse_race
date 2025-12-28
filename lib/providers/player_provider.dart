import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:player_model/player.dart';

class PlayerProvider with ChangeNotifier {
  static const String _playersKey = 'players';
  List<Player> _players = [];

  List<Player> get players => _players;

  PlayerProvider() {
    _loadPlayers();
  }

  void setPlayers(List<Player> newPlayers) {
    _players = newPlayers;
    savePlayers();
    notifyListeners();
  }

  Future<void> _loadPlayers() async {
    final prefs = await SharedPreferences.getInstance();
    final playersJson = prefs.getString(_playersKey);
    if (playersJson != null) {
      final List<dynamic> decodedPlayers = json.decode(playersJson);
      _players = decodedPlayers.map((playerMap) => Player.fromMap(playerMap)).toList();
      notifyListeners();
    }
  }

  Future<void> savePlayers() async {
    final prefs = await SharedPreferences.getInstance();
    final playersJson = json.encode(_players.map((player) => player.toMap()).toList());
    await prefs.setString(_playersKey, playersJson);
  }

  void addPlayer(Player player) {
    _players.add(player);
    savePlayers();
    notifyListeners();
  }

  void updatePlayer(int index, Player player) {
    if (index >= 0 && index < _players.length) {
      _players[index] = player;
      savePlayers();
      notifyListeners();
    }
  }

  void updateScoresForWinners(List<Player> winners, int winValue) {
    for (var winner in winners) {
      final playerIndex = _players.indexWhere((p) => p.id == winner.id);
      if (playerIndex != -1) {
        _players[playerIndex].score += winValue;
      }
    }
    savePlayers();
    notifyListeners();
  }

  void deletePlayer(int index) {
    _players.removeAt(index);
    savePlayers();
    notifyListeners();
  }

  void clearAllScores() {
    for (var player in _players) {
      player.score = 0;
    }
    savePlayers();
    notifyListeners();
  }
}
