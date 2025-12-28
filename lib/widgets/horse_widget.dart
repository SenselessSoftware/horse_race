
import 'package:flutter/material.dart';

import '../models/horse.dart';

class HorseWidget extends StatelessWidget {
  final Horse horse;

  const HorseWidget({super.key, required this.horse});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Image.asset(
        horse.imagePath,
        fit: BoxFit.contain,
      ),
    );
  }
}
