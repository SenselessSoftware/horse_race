
import 'dart:async';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../models/game_state.dart';
import '../providers/player_provider.dart';
import '../services/settings_service.dart';
import '../widgets/player_widget.dart';

class RaceScreen extends StatefulWidget {
  const RaceScreen({super.key});

  @override
  State<RaceScreen> createState() => _RaceScreenState();
}

class _RaceScreenState extends State<RaceScreen> {
  final SettingsService _settingsService = SettingsService();
  Timer? _timer;
  int _countdown = 3;
  bool _raceStarted = false;

  @override
  void initState() {
    super.initState();
    _loadCountdown();
  }

  Future<void> _loadCountdown() async {
    final countdown = await _settingsService.getDiceRollDelay();
    setState(() {
      _countdown = countdown;
    });
  }

  void _startTimer() async {
    final diceRollDelay = await _settingsService.getDiceRollDelay();
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (mounted) {
        setState(() {
          if (_countdown == 1) {
            final gameState = Provider.of<GameState>(context, listen: false);
            if (gameState.winners.isEmpty) {
              gameState.rollDiceAndMoveHorses();
              _countdown = diceRollDelay;
            } else {
              _timer?.cancel();
            }
          } else {
            _countdown--;
          }
        });
      }
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final gameState = Provider.of<GameState>(context);
    final playerProvider = Provider.of<PlayerProvider>(context);
    final winners = gameState.winners;
    final winningPlayers = gameState.winningPlayers;

    if (winners.isNotEmpty) {
      _timer?.cancel();
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('The Race Is On!'),
      ),
      body: Container(
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage("assets/images/racetrack.png"),
            fit: BoxFit.cover,
          ),
        ),
        child: Column(
          children: [
            Expanded(
              child: Row(
                children: [
                  SizedBox(
                    width: 120,
                    child: Column(
                      children: [
                        const Text("Players", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                        Expanded(
                          child: ListView.builder(
                            itemCount: playerProvider.players.length,
                            itemBuilder: (context, index) {
                              final player = playerProvider.players[index];
                              final isWinner = winningPlayers.contains(player);
                              return Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Container(
                                  decoration: isWinner
                                      ? BoxDecoration(
                                          border: Border.all(color: Colors.yellow, width: 3),
                                          borderRadius: BorderRadius.circular(8.0),
                                        )
                                      : null,
                                  child: Column(
                                    children: [
                                      PlayerWidget(player: player),
                                      Text('${player.name}: ${player.score}'),
                                    ],
                                  ),
                                ),
                              );
                            },
                          ),
                        ),
                      ],
                    ),
                  ),
                  const VerticalDivider(),
                  Expanded(
                    child: Column(
                      children: gameState.horses.map((horse) {
                        return Expanded(
                          child: Padding(
                            padding: const EdgeInsets.symmetric(
                                vertical: 2.0, horizontal: 8.0),
                            child: DragTarget<String>(
                              builder: (context, candidateData, rejectedData) {
                                return LayoutBuilder(builder: (context, constraints) {
                                  final trackWidth = constraints.maxWidth;
                                  final iconSize = constraints.maxHeight;

                                  return Stack(
                                    alignment: Alignment.centerLeft,
                                    children: [
                                      Container(
                                        height: iconSize,
                                        width: trackWidth,
                                        decoration: BoxDecoration(
                                          color: Colors.transparent,
                                          borderRadius: BorderRadius.circular(8.0),
                                        ),
                                      ),
                                      Positioned(
                                        left: (horse.position / 8) *
                                            (trackWidth - iconSize),
                                        child: SizedBox(
                                          width: iconSize,
                                          height: iconSize,
                                          child: Image.asset(
                                            horse.imagePath,
                                            fit: BoxFit.contain,
                                          ),
                                        ),
                                      ),
                                    ],
                                  );
                                });
                              },
                              onAccept: (data) {
                                if (!_raceStarted) {
                                  gameState.selectHorse(data, horse.id);
                                }
                              },
                            ),
                          ),
                        );
                      }).toList(),
                    ),
                  ),
                ],
              ),
            ),
            if (winners.isNotEmpty)
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  children: [
                    Text(
                      winners.length > 1
                          ? 'It\'s a tie between ${winners.map((h) => h.name).join(', ')}!'
                          : '${winners.first.name} wins!',
                      style: Theme.of(context).textTheme.headlineMedium,
                      textAlign: TextAlign.center,
                    ),
                    if (winningPlayers.isNotEmpty)
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text(
                          'Winners: ${winningPlayers.map((p) => p.name).join(', ')}',
                          style: Theme.of(context).textTheme.titleLarge,
                          textAlign: TextAlign.center,
                        ),
                      ),
                    ElevatedButton(
                      onPressed: () {
                        gameState.resetRace();
                        setState(() {
                          _raceStarted = false;
                          _loadCountdown();
                        });
                      },
                      child: const Text('Finish'),
                    ),
                  ],
                ),
              )
            else if (_raceStarted)
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      'Next roll in... $_countdown',
                      style: Theme.of(context).textTheme.headlineMedium,
                    ),
                    if (gameState.diceRolls.isNotEmpty)
                      Padding(
                        padding: const EdgeInsets.only(left: 16.0),
                        child: Row(
                          children: gameState.diceRolls.map((roll) {
                            final horse = gameState.horses[roll - 1];
                            return Padding(
                              padding: const EdgeInsets.symmetric(horizontal: 2.0),
                              child: Image.asset(
                                horse.imagePath,
                                height: 30,
                                width: 30,
                              ),
                            );
                          }).toList(),
                        ),
                      ),
                  ],
                ),
              )
            else
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: ElevatedButton(
                  onPressed: gameState.playerHorseSelection.isNotEmpty
                      ? () {
                          setState(() {
                            _raceStarted = true;
                          });
                          _startTimer();
                        }
                      : null,
                  child: const Text('Start Race'),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
