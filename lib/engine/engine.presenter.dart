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

const int GAME_LEVELS = 2;

class EnginePresenter {
  static EnginePresenter? _instance;

  static EnginePresenter get instance {
    if (_instance == null) {
      _instance = EnginePresenter._();
    }
    return _instance!;
  }

  late ShmupGame _game;

  GameStates _state = GameStates.ready;
  late PlayerShip _playerShip;
  late Joystick _joystick;
  late int lives;
  late int score;
  late int _currentLevelNumber;
  LevelModel? _currentLevel;
  double _levelTimeElapsed = 0;

  EnginePresenter._();

  Future<void> init(ShmupGame game) async {
    this._game = game;
    this.lives = 3;
    this.score = 0;
  }

  Future<void> onLoad() async {
    _playerShip = PlayerShip(_game);

    _joystick = Joystick(_game);
    _joystick.addObserver(_playerShip);

    this._setState(GameStates.ready);
  }

  void update(double dt) {
    if (_currentLevel != null) {
      _levelTimeElapsed += dt;

      for (EnemyModel enemyModel in _currentLevel!.enemies) {
        if (enemyModel.timestamp < _levelTimeElapsed && !enemyModel.hasBeenSet) {
          enemyModel.hasBeenSet = true;
          _game.add(EnemyShip(_game, enemyModel));
        }
      }
    }
  }

  Future<void> loadLevel(int number) async {
    _currentLevelNumber = number;
    _levelTimeElapsed = 0;

    String data = await rootBundle.loadString('assets/levels/level$_currentLevelNumber.json');
    Map<String, dynamic> json = jsonDecode(data);

    _currentLevel = LevelModel.fromJson(json);

    _playerShip.resetPosition();

    _game.components.clear();

    _game.add(_playerShip);
    _game.add(_joystick);
    _game.add(ScreenCollidable());

    this._setState(GameStates.playing);
  }

  bool isPlaying() {
    return this._state == GameStates.playing;
  }

  void enemyDestroyed(EnemyShip enemy) {
    _game.components.remove(enemy);

    score += enemy.model.score;

    _currentLevel!.enemies.removeWhere((element) => element.id == enemy.model.id);

    if (_currentLevel!.enemies.isEmpty) {
      if (_currentLevelNumber < GAME_LEVELS) {
        this.loadLevel(_currentLevelNumber + 1);
      } else {
        this._setState(GameStates.ready);
      }
    }
  }

  void shipDestroyed() {
    this.lives--;
    if (this.lives < 0) {
      this._setState(GameStates.ready);
    } else {
      this.loadLevel(_currentLevelNumber);
    }
  }

  void _setState(GameStates newState) {
    this._state = newState;
    switch (_state) {
      case GameStates.ready:
        _currentLevel = null;
        _levelTimeElapsed = 0;
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
