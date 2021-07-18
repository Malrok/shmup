
import 'package:flame/components.dart';
import 'package:shmup/components/enemy.component.dart';
import 'package:shmup/components/ship.component.dart';
import 'package:shmup/engine/move_functions/simple_move_function.dart';
import 'package:shmup/engine/widgets/game.widget.dart';
import 'package:shmup/engine/widgets/joystick.widget.dart';
import 'package:shmup/models/level.model.dart';
import 'package:shmup/screens/launch.screen.dart';

enum GameStates { ready, playing, paused }

class EnginePresenter {
  static EnginePresenter? _instance;

  static get instance {
    if (_instance == null) {
      _instance = EnginePresenter._();
    }
    return _instance;
  }

  late ShmupGame _game;

  GameStates _state = GameStates.ready;
  late PlayerShip _playerShip;
  late Joystick _joystick;
  late LevelModel _currentLevel;

  EnginePresenter._();

  Future<void> init(ShmupGame game) async {
    this._game = game;
  }

  Future<void> onLoad() async {
    this._setState(GameStates.ready);
  }

  Future<void> loadLevel() async {
    _currentLevel = LevelModel(number: 1, enemies: 1);

    _playerShip = PlayerShip(_game);

    _joystick = Joystick(_game);
    _joystick.addObserver(_playerShip);

    _game.components.clear();

    _game.add(_playerShip);
    _game.add(_joystick);
    _game.add(ScreenCollidable());

    EnemyShip enemy = EnemyShip(Vector2(_game.canvasSize.y / 2, 0), simpleMoveFunction);


    _game.add(enemy);

    this._setState(GameStates.playing);
  }

  bool isPlaying() {
    return this._state == GameStates.playing;
  }

  void enemyDestroyed(EnemyShip enemy) {
    _game.components.remove(enemy);
    _currentLevel.enemies = _currentLevel.enemies - 1;

    if (_currentLevel.enemies == 0) this._setState(GameStates.ready);
  }

  void _setState(GameStates newState) {
    this._state = newState;
    switch (_state) {
      case GameStates.ready:
        _game.overlays.add(LaunchScreen.name);
        break;
      case GameStates.playing:
        _game.overlays.remove(LaunchScreen.name);
        break;
      case GameStates.paused:
        // TODO: Handle this case.
        break;
    }
  }
}
