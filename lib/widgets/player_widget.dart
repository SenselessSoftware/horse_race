import 'dart:io';

import 'package:flutter/material.dart';
import 'package:horse_race/models/horse.dart';
import 'package:player_model/player.dart';
import 'package:provider/provider.dart';

import '../models/game_state.dart';

class PlayerWidget extends StatelessWidget {
  final Player player;

  const PlayerWidget({super.key, required this.player});

  @override
  Widget build(BuildContext context) {
    final gameState = Provider.of<GameState>(context);
    final horseId = gameState.playerHorseSelection[player.id];

    // Find the selected horse from the game state.
    Horse? selectedHorse;
    if (horseId != null) {
      // Using a simple loop to be safe, as .firstWhere could throw an error.
      for (final horse in gameState.horses) {
        if (horse.id == horseId) {
          selectedHorse = horse;
          break;
        }
      }
    }

    ImageProvider getImage() {
      if (player.imagePath.startsWith('assets')) {
        // Reverting to use local images from the main project's assets.
        return AssetImage(player.imagePath);
      } else {
        // Images from camera/gallery are loaded as files.
        return FileImage(File(player.imagePath));
      }
    }

    return LayoutBuilder(builder: (context, constraints) {
      final size = constraints.maxWidth;

      return Draggable<String>(
        data: player.id,
        feedback: Image(image: getImage(), width: size, height: size),
        childWhenDragging: Container(
          width: size,
          height: size,
          color: Colors.grey,
        ),
        child: Stack(
          children: [
            // Main player avatar image
            Image(image: getImage(), width: size, height: size),

            // If a horse is selected, show its image as a small overlay.
            if (selectedHorse != null)
              Positioned(
                right: 0,
                bottom: 0,
                child: Container(
                  width: size * 0.5,
                  height: size * 0.5,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    border: Border.all(color: Colors.white, width: 2),
                    image: DecorationImage(
                      image: AssetImage(selectedHorse.imagePath),
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
              ),
          ],
        ),
      );
    });
  }
}
