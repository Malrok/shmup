import 'package:flame/components.dart';
import 'package:flame/extensions.dart';
import 'package:flame/game.dart';
import 'package:shmup/components/lives-display.component.dart';
import 'package:shmup/components/score-display.component.dart';
import 'package:shmup/engine/engine.presenter.dart';

class ShmupGame extends BaseGame with HasDraggableComponents, HasCollidables {
  late ScoreDisplay _scoreDisplay;
  late LivesDisplay _livesDisplay;

  @override
  Future<void> onLoad() async {
    await EnginePresenter.instance.onLoad();
    _scoreDisplay = ScoreDisplay(this);
    _livesDisplay = LivesDisplay(this);
  }

  @override
  void render(Canvas canvas) {
    if (EnginePresenter.instance.isPlaying()) {
      _scoreDisplay.render(canvas);
      _livesDisplay.render(canvas);

      super.render(canvas);
    }
  }

  @override
  void update(double dt) {
    EnginePresenter.instance.update(dt);
    _scoreDisplay.update(dt);
    _livesDisplay.update(dt);
    super.update(dt);
  }

  double maxY() {
    return this.canvasSize.y; // - _joystick.;
  }
}
