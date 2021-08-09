import 'package:flame/components.dart';
import 'package:flame/effects.dart';
import 'package:flame/geometry.dart';
import 'package:flame/palette.dart';
import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'package:shmup/components/bullet.component.dart';
import 'package:shmup/engine/engine.presenter.dart';
import 'package:shmup/engine/shmup.game.dart';
import 'package:shmup/models/enemy.model.dart';
import 'package:shmup/models/path.model.dart';

typedef MoveEnemyFunction(EnemyShip ship, double dt);

class EnemyShip extends PositionComponent with Hitbox, Collidable implements HasGameRef<ShmupGame> {
  static Paint white = BasicPalette.white.paint();

  EnemyModel model;

  EnemyShip(this.gameRef, this.model) {
    addShape(HitboxRectangle());

    this.position = position;
    this.x = model.startx * gameRef.size.x;
    this.y = model.starty * gameRef.size.y;

    for (PathModel pathModel in model.paths) {
      addEffect(MoveEffect(
        path: [
          Vector2(
            pathModel.vectorx * gameRef.size.x,
            pathModel.vectory * gameRef.size.y,
          ),
        ],
        speed: model.speed,
      ));
    }
  }

  @override
  void render(Canvas c) {
    super.render(c);

    c.drawRect(size.toRect(), white);
  }

  @override
  void onMount() {
    super.onMount();
    size.setValues(model.size, model.size);
    anchor = Anchor.center;
  }

  @override
  void onCollision(Set<Vector2> points, Collidable other) {
    if (other is ScreenCollidable) {
      if (this.y > other.size.y) EnginePresenter.instance.enemyDestroyed(this, false);
    }
    if (other is Bullet) {
      this.model.energy -= other.power;
      if (this.model.energy <= 0) EnginePresenter.instance.enemyDestroyed(this, true);
    }
  }

  @override
  ShmupGame gameRef;

  @override
  bool get hasGameRef => true;
}
