import 'package:flame/components.dart';
import 'package:flame/game.dart';
import 'package:shmup/components/enemies/enemy.dart';
import 'package:shmup/components/player/ship.dart';
import 'package:shmup/engine/joystick.dart';
import 'package:shmup/engine/move_functions/simple_move_function.dart';

class ShmupGame extends BaseGame with HasDraggableComponents, HasCollidables {
  bool running = true;

  late PlayerShip _playerShip;
  late Joystick _joystick;

  @override
  Future<void> onLoad() async {
    print(this.canvasSize);

    _playerShip = PlayerShip(this);

    _joystick = Joystick(this);
    _joystick.addObserver(_playerShip);

    add(_playerShip);
    add(_joystick);
    add(ScreenCollidable());
    add(EnemyShip(Vector2(this.canvasSize.y / 2, 0), this, simpleMoveFunction));
  }

  double maxY() {
    return this.canvasSize.y; // - _joystick.;
  }
}