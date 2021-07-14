import 'package:flame/components.dart';
import 'package:flame/game.dart';
import 'package:flame/gestures.dart';
import 'package:shmup/components/player/ship.dart';
import 'package:shmup/engine/joystick.dart';

class ShmupGame extends BaseGame with MultiTouchDragDetector, HasDraggableComponents {
  bool running = true;

  late PlayerShip _playerShip = PlayerShip();
  late Joystick _joystick;

  @override
  Future<void> onLoad() async {
    _joystick = Joystick(this);
    _joystick.addObserver(_playerShip);

    add(_playerShip);
    add(_joystick);
  }

  // @override
  // void onReceiveDrag(DragUpdateInfo drag) {
  //   joystick.onReceiveDrag(drag);
  //   super.onReceiveDrag(drag);
  // }

  // @override
  // void onPanUpdate(DragUpdateInfo info) {
  //   final delta = details.delta;
  //   final size = game.screenSize
  //   double translateX = delta.dx;
  //   double translateY = delta.dy;
  //   // Make sure that the player never goes outside of the screen in the X-axis
  //   if (playerRect.right + delta.dx >= size.width) {
  //     translateX = size.width - playerRect.right;
  //   } else if (playerRect.left + delta.dx <= 0) {
  //     translateX = -playerRect.left;
  //   }
  //   // Make sure that the player never goes outside of the screen in the Y-axis
  //   if (playerRect.bottom + delta.dy >= size.height) {
  //     translateY = size.height - playerRect.bottom;
  //   } else if (playerRect.top + delta.dy <= 0) {
  //     translateY = -playerRect.top;
  //   }
  //   playerRect = playerRect.translate(translateX, translateY)
  // }
}