import 'dart:math';
import 'dart:ui';

import 'package:flame/components.dart';
import 'package:flame/geometry.dart';
import 'package:flame/palette.dart';
import 'package:shmup/engine/widgets/game.widget.dart';

class PlayerShip extends PositionComponent with Hitbox, Collidable implements JoystickListener, HasGameRef<ShmupGame> {
  static const speed = 128.0;
  static const squareSize = 12.0;
  static Paint white = BasicPalette.white.paint();

  double currentSpeed = 0;
  bool isMoving = false;

  PlayerShip(this.gameRef) {
    x = this.gameRef.canvasSize.x / 2;
    y = this.gameRef.canvasSize.y - this.gameRef.canvasSize.y * 0.1;

    addShape(HitboxRectangle());
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

  @override
  void onCollision(Set<Vector2> points, Collidable other) {
    if (other is ScreenCollidable) {
      if (this.x < 0) this.x = 0;
      if (this.x > other.width) this.x = other.width;
      if (this.y < 0) this.y = 0;
      if (this.y > this.gameRef.maxY()) this.y = other.height;
    }
  }

  @override
  ShmupGame gameRef;

  @override
  bool get hasGameRef => true;
}
