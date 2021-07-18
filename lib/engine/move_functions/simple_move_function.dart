import 'package:flame/game.dart';
import 'package:shmup/components/enemies/enemy.component.dart';

void simpleMoveFunction(EnemyShip ship, double dt) {
  final delta = Vector2(0, EnemyShip.speed * dt);
  ship.position.add(delta);
}
