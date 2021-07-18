
import 'dart:convert';

import 'package:flame/components.dart';
import 'package:flutter/services.dart';
import 'package:shmup/components/enemy.component.dart';
import 'package:shmup/components/ship.component.dart';
import 'package:shmup/engine/widgets/game.widget.dart';
import 'package:shmup/engine/widgets/joystick.widget.dart';
import 'package:shmup/models/enemy.model.dart';
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
    _playerShip = PlayerShip(_game);

    _joystick = Joystick(_game);
    _joystick.addObserver(_playerShip);

    this._setState(GameStates.ready);
  }

  Future<void> loadLevel(int number) async {
    String data = await rootBundle.loadString('assets/levels/level$number.json');
    Map<String, dynamic> json = jsonDecode(data);

    _currentLevel = LevelModel.fromJson(json);
    _currentLevel.number = number;

    _playerShip.resetPosition();

    _game.components.clear();

    _game.add(_playerShip);
    _game.add(_joystick);
    _game.add(ScreenCollidable());

    for (EnemyModel enemyModel in _currentLevel.enemies) {
      _game.add(EnemyShip(enemyModel));
    }

    this._setState(GameStates.playing);
  }

  bool isPlaying() {
    return this._state == GameStates.playing;
  }

  void enemyDestroyed(EnemyShip enemy) {
    _game.components.remove(enemy);

    _currentLevel.enemies.toList().remove(enemy.model);

    if (_currentLevel.enemies.isEmpty) this._setState(GameStates.ready);
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
