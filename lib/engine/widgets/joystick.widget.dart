import 'package:flame/components.dart';
import 'package:flame/game.dart';
import 'package:flutter/material.dart';

class Joystick extends JoystickComponent {
  Joystick(BaseGame gameRef)
      : super(
          gameRef: gameRef,
          directional: JoystickDirectional(),
          actions: [
            JoystickAction(
              actionId: 1,
              color: Colors.blueGrey,
            ),
          ],
        );
}
