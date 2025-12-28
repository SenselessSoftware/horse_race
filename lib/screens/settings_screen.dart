import '../providers/player_provider.dart';
import '../services/settings_service.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  final SettingsService _settingsService = SettingsService();
  final TextEditingController _horseRaceWinValueController = TextEditingController();
  final TextEditingController _diceRollDelayController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _loadSettings();
  }

  Future<void> _loadSettings() async {
    final horseRaceWinValue = await _settingsService.getHorseRaceWinValue();
    _horseRaceWinValueController.text = horseRaceWinValue.toString();
    final diceRollDelay = await _settingsService.getDiceRollDelay();
    _diceRollDelayController.text = diceRollDelay.toString();
  }

  Future<void> _saveSettings() async {
    final horseRaceWinValue = int.tryParse(_horseRaceWinValueController.text) ?? 1;
    await _settingsService.setHorseRaceWinValue(horseRaceWinValue);
    final diceRollDelay = int.tryParse(_diceRollDelayController.text) ?? 3;
    await _settingsService.setDiceRollDelay(diceRollDelay);
  }

  void _showResetScoresConfirmationDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Reset All Scores?'),
        content: const Text('Are you sure you want to reset all player scores? This action cannot be undone.'),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
            },
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              final playerProvider = Provider.of<PlayerProvider>(context, listen: false);
              playerProvider.clearAllScores();
              Navigator.of(context).pop();
            },
            child: const Text('Reset'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Settings'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: _horseRaceWinValueController,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(
                labelText: 'Horse Race Win Value',
              ),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: _diceRollDelayController,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(
                labelText: 'Dice Roll Delay (seconds)',
              ),
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: () {
                _saveSettings();
                Navigator.pop(context);
              },
              child: const Text('Save'),
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: _showResetScoresConfirmationDialog,
              style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
              child: const Text('Reset All Scores'),
            ),
          ],
        ),
      ),
    );
  }
}
