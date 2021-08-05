import 'dart:math';
import 'dart:ui';

import 'package:flame/components.dart';
import 'package:flame/geometry.dart';
import 'package:flame/palette.dart';
import 'package:shmup/components/bullet.component.dart';
import 'package:shmup/components/enemy.component.dart';
import 'package:shmup/engine/engine.presenter.dart';
import 'package:shmup/engine/widgets/game.widget.dart';
import 'package:shmup/models/weapon.model.dart';

class PlayerShip extends PositionComponent with Hitbox, Collidable implements JoystickListener, HasGameRef<ShmupGame> {
  static const speed = 128.0;
  static const squareSize = 12.0;
  static Paint white = BasicPalette.white.paint();

  double currentSpeed = 0;
  bool isMoving = false;
  late Weapon _weapon;

  PlayerShip(this.gameRef) {
    resetPosition();
    addShape(HitboxRectangle());
    _weapon = Weapon(1, 3);
  }

  @override
  void onMount() {
    super.onMount();
    size.setValues(squareSize, squareSize);
    anchor = Anchor.center;
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
    _pullTrigger(dt);
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

  @override
  void onCollision(Set<Vector2> points, Collidable other) {
    if (other is ScreenCollidable) {
      if (this.x < 0) this.x = 0;
      if (this.x > other.width) this.x = other.width;
      if (this.y < 0) this.y = 0;
      if (this.y > this.gameRef.maxY()) this.y = other.height;
    }
    if (other is EnemyShip) {
      EnginePresenter.instance.shipDestroyed();
    }
  }

  @override
  ShmupGame gameRef;

  @override
  bool get hasGameRef => true;

  void resetPosition() {
    x = this.gameRef.canvasSize.x / 2;
    y = this.gameRef.canvasSize.y - this.gameRef.canvasSize.y * 0.1;
  }

  void _moveFromAngle(double dt) {
    final delta = Vector2(cos(angle), sin(angle)) * (currentSpeed * dt);
    position.add(delta);
  }

  void _pullTrigger(double dt) {
    if (_weapon.shouldTrigger(dt)) {
      this.gameRef.add(Bullet(position, Vector2(0, -256), this._weapon.damage, this.gameRef));
    }
  }
}
