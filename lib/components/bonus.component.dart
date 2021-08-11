import 'dart:ui';

import 'package:flame/components.dart';
import 'package:flame/geometry.dart';
import 'package:flame/palette.dart';
import 'package:shmup/components/player_ship.component.dart';
import 'package:shmup/engine/engine.presenter.dart';

enum BonusTypes {
  speed,
  power,
  gun,
  bomb
}

extension BonusColor on BonusTypes {
  Paint getColor() {
    Paint paint;
    switch (this) {
      case BonusTypes.speed:
        paint = BasicPalette.magenta.paint();
        break;
      case BonusTypes.power:
        paint = BasicPalette.blue.paint();
        break;
      case BonusTypes.gun:
        paint = BasicPalette.green.paint();
        break;
      case BonusTypes.bomb:
        paint = BasicPalette.red.paint();
        break;
    }
    return paint;
  }
}

extension BonusBoost on BonusTypes {
  double getBoost() {
    double boost;
    switch (this) {
      case BonusTypes.speed:
        boost = 24;
        break;
      case BonusTypes.power:
        boost = 2;
        break;
      case BonusTypes.gun:
        boost = -1;
        break;
      case BonusTypes.bomb:
        boost = 1;
        break;
    }
    return boost;
  }
}


class Bonus extends PositionComponent with Hitbox, Collidable {
  static const bonusSize = 24.0;

  late BonusTypes type;

  Bonus(this.type, double x, double y) {
    addShape(HitboxRectangle());

    this.position = position;
    this.x = x;
    this.y = y;
  }

  @override
  void render(Canvas c) {
    super.render(c);

    c.drawCircle(Offset(0, 0), bonusSize, type.getColor());
  }

  @override
  void update(double dt) {
    final delta = Vector2(0, EnginePresenter.instance.gameSpeed * dt);
    position.add(delta);

    super.update(dt);
  }

  @override
  void onMount() {
    super.onMount();
    size.setValues(bonusSize, bonusSize);
    anchor = Anchor.center;
  }

  @override
  void onCollision(Set<Vector2> points, Collidable other) {
    if (other is ScreenCollidable) {
      if (this.y > other.size.y) EnginePresenter.instance.removeBonus(this, false);
    }
    if (other is PlayerShip) {
      EnginePresenter.instance.removeBonus(this, true);
    }
  }
}
