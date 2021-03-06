import 'package:flame/components.dart';
import 'package:flame/extensions.dart';
import 'package:flame/game.dart';
import 'package:shmup/engine/engine.presenter.dart';

class ShmupGame extends BaseGame with HasDraggableComponents, HasCollidables {
  @override
  Future<void> onLoad() async {
    await EnginePresenter.instance.onLoad();
  }

  @override
  void render(Canvas canvas) {
    EnginePresenter.instance.render(canvas);

    super.render(canvas);
  }

  @override
  void update(double dt) {
    EnginePresenter.instance.update(dt);
    super.update(dt);
  }

  double maxY() {
    return this.canvasSize.y; // - _joystick.;
  }
}
