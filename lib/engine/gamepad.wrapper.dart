import 'dart:math';

import 'package:flame/components.dart';
import 'package:flame_gamepad/flame_gamepad.dart';
import 'package:flutter/services.dart';

const FLAME_MAPPING = {
  GAMEPAD_DPAD_UP: JoystickMoveDirectional.moveUp,
  GAMEPAD_DPAD_DOWN: JoystickMoveDirectional.moveDown,
  GAMEPAD_DPAD_LEFT: JoystickMoveDirectional.moveLeft,
  GAMEPAD_DPAD_RIGHT: JoystickMoveDirectional.moveRight,
  GAMEPAD_BUTTON_A: '',
  GAMEPAD_BUTTON_B: '',
  GAMEPAD_BUTTON_X: '',
  GAMEPAD_BUTTON_Y: '',
  GAMEPAD_BUTTON_L1: '',
  GAMEPAD_BUTTON_R1: '',
  GAMEPAD_BUTTON_L2: '',
  GAMEPAD_BUTTON_R2: '',
  GAMEPAD_BUTTON_START: '',
  GAMEPAD_BUTTON_SELECT: ''
};

const DIRECTION_ANGLE = {
  JoystickMoveDirectional.moveUp: 3 * pi / 2,
  JoystickMoveDirectional.moveDown: pi / 2,
  JoystickMoveDirectional.moveLeft: pi,
  JoystickMoveDirectional.moveRight: 2 * pi
};

class GamepadWrapper {
  final List<JoystickListener> _observers = [];

  Future<bool> init() async {
    bool isConnected;

    try {
      isConnected = await FlameGamepad.isGamepadConnected;
    } on PlatformException {
      isConnected = false;
    }

    if (isConnected) _start();

    return isConnected;
  }

  void _start() {
    FlameGamepad()
      ..setListener((String evtType, String key) {
        if (evtType == GAMEPAD_BUTTON_DOWN) {
          switch (key) {
            case GAMEPAD_DPAD_UP:
            case GAMEPAD_DPAD_DOWN:
            case GAMEPAD_DPAD_LEFT:
            case GAMEPAD_DPAD_RIGHT:
              var directional = FLAME_MAPPING[key] as JoystickMoveDirectional;
              var angle = DIRECTION_ANGLE[directional]!.toDouble();
              _joystickChangeDirectional(
                  JoystickDirectionalEvent(directional: directional, intensity: 1, angle: angle));
              break;
            default:
            // _joystickAction(JoystickActionEvent(id: id, event: event));
          }
        } else {
          _joystickChangeDirectional(JoystickDirectionalEvent(directional: JoystickMoveDirectional.idle, intensity: 0));
        }
      });
  }

  void addObserver(JoystickListener listener) {
    _observers.add(listener);
  }

  void _joystickChangeDirectional(JoystickDirectionalEvent event) {
    _observers.forEach((o) => o.joystickChangeDirectional(event));
  }

  void _joystickAction(JoystickActionEvent event) {
    _observers.forEach((o) => o.joystickAction(event));
  }
}
