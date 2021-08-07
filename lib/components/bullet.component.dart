import 'package:flame/components.dart';
import 'package:flame/geometry.dart';
import 'package:flame/palette.dart';
import 'package:flutter/painting.dart';
import 'package:shmup/components/enemy.component.dart';
import 'package:shmup/engine/shmup.game.dart';

class Bullet extends PositionComponent with Hitbox, Collidable implements HasGameRef<ShmupGame> {
  static const bulletSize = 4.0;
  static Paint white = BasicPalette.white.paint();

  Vector2 _direction;
  double power;

  Bullet(Vector2 position, this._direction, this.power, this.gameRef) {
    this.position = position;
    addShape(HitboxCircle());
  }

  @override
  void onMount() {
    super.onMount();
    size.setValues(bulletSize, bulletSize);
    anchor = Anchor.center;
  }

  @override
  void render(Canvas c) {
    super.render(c);

    c.drawCircle(Offset(0, 0), bulletSize, white);
  }

  @override
  void update(double dt) {
    super.update(dt);
    position.add(this._direction * dt);
  }

  @override
  void onCollision(Set<Vector2> points, Collidable other) {
    if (other is ScreenCollidable) {
      if (this.x < 0 || this.x > this.gameRef.size.x || this.y < 0 || this.y > this.gameRef.size.y) {
        this.gameRef.components.remove(this);
      }
    }
    if (other is EnemyShip) {
      this.gameRef.components.remove(this);
    }
  }

  @override
  ShmupGame gameRef;

  @override
  bool get hasGameRef => true;
}
