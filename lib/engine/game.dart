import 'package:flame/components.dart';
import 'package:flame/game.dart';
import 'package:shmup/components/player/ship.dart';
import 'package:shmup/engine/joystick.dart';

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
  }

  double maxY() {
    return this.canvasSize.y; // - _joystick.;
  }
}