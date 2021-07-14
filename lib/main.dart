import 'package:flame/game.dart';
import 'package:flutter/material.dart';
import 'package:shmup/engine/game.dart';

void main() {
  runApp(
    GameWidget(
      game: ShmupGame(),
    ),
  );
}