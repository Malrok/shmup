import 'dart:math';
import 'dart:ui';

import 'package:flame/components.dart';
import 'package:flame/palette.dart';

class PlayerShip extends PositionComponent implements JoystickListener {
  static const speed = 64.0;
  static const squareSize = 12.0;

  double currentSpeed = 0;
  bool isMoving = false;

  static Paint white = BasicPalette.white.paint();

  PlayerShip() {
    x = 100;
    y = 100;
  }

  @override
  void render(Canvas c) {
    super.render(c);

    c.drawRect(size.toRect(), white);
  }

  @override
  void update(double dt) {
    super.update(dt);
    if (isMoving) {
      _moveFromAngle(dt);
    }
  }

  @override
  void onMount() {
    super.onMount();
    size.setValues(squareSize, squareSize);
    anchor = Anchor.center;
  }

  @override
  void joystickAction(JoystickActionEvent event) {
    // TODO: implement joystickAction
  }

  @override
  void joystickChangeDirectional(JoystickDirectionalEvent event) {
    isMoving = event.directional != JoystickMoveDirectional.idle;
    if (isMoving) {
      angle = event.angle;
      currentSpeed = speed * event.intensity;
    }
  }

  void _moveFromAngle(double dt) {
    final delta = Vector2(cos(angle), sin(angle)) * (currentSpeed * dt);
    position.add(delta);
  }
}
