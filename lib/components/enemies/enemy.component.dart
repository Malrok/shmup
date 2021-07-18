import 'package:flame/components.dart';
import 'package:flame/geometry.dart';
import 'package:flame/palette.dart';
import 'package:flutter/painting.dart';
import 'package:shmup/components/player/ship.component.dart';
import 'package:shmup/engine/presenter.dart';

typedef MoveEnemyFunction(EnemyShip ship, double dt);

class EnemyShip extends PositionComponent with Hitbox, Collidable {
  static const speed = 96.0;
  static const squareSize = 24.0;
  static Paint white = BasicPalette.white.paint();

  double currentSpeed = 0;

  final MoveEnemyFunction _moveEnemyFunction;

  EnemyShip(Vector2 position, this._moveEnemyFunction) {
    this.position = position;
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
    _moveEnemyFunction(this, dt);
  }

  @override
  void onMount() {
    super.onMount();
    size.setValues(squareSize, squareSize);
    anchor = Anchor.center;
  }

  @override
  void onCollision(Set<Vector2> points, Collidable other) {
    if (other is PlayerShip) {
      // if (this.x < 0) this.x = 0;
      // if (this.x > other.width) this.x = other.width;
      // if (this.y < 0) this.y = 0;
      // if (this.y > this.gameRef.maxY()) this.y = other.height;
    }
    if (other is ScreenCollidable) {
      if (this.y > other.size.y) ShmupPresenter.instance.enemyDestroyed(this);
    }
  }
}
