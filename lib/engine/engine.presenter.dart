import 'dart:convert';
import 'dart:math';

import 'package:flame/components.dart';
import 'package:flame/extensions.dart';
import 'package:flutter/services.dart';
import 'package:shmup/components/bonus.component.dart';
import 'package:shmup/components/enemy_ship.component.dart';
import 'package:shmup/components/level-display.component.dart';
import 'package:shmup/components/lives-display.component.dart';
import 'package:shmup/components/score-display.component.dart';
import 'package:shmup/components/player_ship.component.dart';
import 'package:shmup/engine/shmup.game.dart';
import 'package:shmup/components/joystick.component.dart';
import 'package:shmup/models/enemy.model.dart';
import 'package:shmup/models/level.model.dart';
import 'package:shmup/widgets/launch.widget.dart';

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
  late ScoreDisplay _scoreDisplay;
  late LivesDisplay _livesDisplay;
  late LevelDisplay _levelDisplay;

  late int lives;
  late int score;
  late int currentLevelNumber;
  late int gameSpeed = 64;

  LevelModel? _currentLevel;
  double _levelTimeElapsed = 0;
  double _bonusChances = 0.5;

  EnginePresenter._();

  Future<void> init(ShmupGame game) async {
    _game = game;

    lives = 3;
    score = 0;
  }

  Future<void> onLoad() async {
    _playerShip = PlayerShip(_game);

    _joystick = Joystick(_game);
    _joystick.addObserver(_playerShip);

    _scoreDisplay = ScoreDisplay(_game);
    _livesDisplay = LivesDisplay(_game);
    _levelDisplay = LevelDisplay(_game);

    _setState(GameStates.ready);
  }

  void render(Canvas canvas) {
    if (_state == GameStates.playing) {
      _scoreDisplay.render(canvas);
      _livesDisplay.render(canvas);
      _levelDisplay.render(canvas);
    }
  }

  void update(double dt) {
    if (_state == GameStates.playing) {
      _levelTimeElapsed += dt;

      _scoreDisplay.update(dt);
      _livesDisplay.update(dt);
      _levelDisplay.update(dt);

      for (EnemyModel enemyModel in _currentLevel!.enemies) {
        if (enemyModel.timestamp < _levelTimeElapsed && !enemyModel.hasBeenSet) {
          enemyModel.hasBeenSet = true;
          _game.add(EnemyShip(_game, enemyModel));
        }
      }
    }
  }

  Future<void> loadLevel(int number) async {
    currentLevelNumber = number;
    _levelTimeElapsed = 0;

    _levelDisplay.initialize();

    String data = await rootBundle.loadString('assets/levels/level$currentLevelNumber.json');
    Map<String, dynamic> json = jsonDecode(data);

    _currentLevel = LevelModel.fromJson(json);

    _playerShip.resetPosition();

    _game.components.clear();

    _game.add(_playerShip);
    _game.add(_joystick);
    _game.add(ScreenCollidable());

    _setState(GameStates.playing);
  }

  bool isPlaying() {
    return _state == GameStates.playing;
  }

  void enemyDestroyed(EnemyShip enemy, bool byPlayer) {
    if (byPlayer) {
      score += enemy.model.score;
      generateBonus(enemy.x, enemy.y);
    }

    _game.components.remove(enemy);

    _currentLevel!.enemies.removeWhere((element) => element.id == enemy.model.id);

    if (_currentLevel!.enemies.isEmpty) {
      if (currentLevelNumber < GAME_LEVELS) {
        loadLevel(currentLevelNumber + 1);
      } else {
        _setState(GameStates.ready);
      }
    }
  }

  void generateBonus(double x, double y) {
    Random random = Random();
    if (random.nextDouble() <= _bonusChances) {
      double dice = random.nextDouble();
      BonusTypes type;

      if (dice >= 0.75) {
        type = BonusTypes.speed;
      } else if (dice >= 0.5) {
        type = BonusTypes.power;
      } else if (dice >= 0.25) {
        type = BonusTypes.gun;
      } else {
        type = BonusTypes.bomb;
      }

      _game.components.add(Bonus(type, x, y));
    }
  }

  void removeBonus(Bonus bonus, bool consumed) {
    _game.components.remove(bonus);

    if (consumed) {
      switch (bonus.type) {
        case BonusTypes.speed:
          _playerShip.maxSpeed += bonus.type.getBoost();
          break;
        case BonusTypes.power:
          _playerShip.weapon.damage += bonus.type.getBoost();
          break;
        case BonusTypes.gun:
          // TODO: Handle this case.
          break;
        case BonusTypes.bomb:
          // TODO: Handle this case.
          break;
      }
    }
  }

  void shipDestroyed() {
    lives--;
    if (lives < 0) {
      _setState(GameStates.ready);
    } else {
      loadLevel(currentLevelNumber);
    }
  }

  void _setState(GameStates newState) {
    _state = newState;
    switch (_state) {
      case GameStates.ready:
        _currentLevel = null;
        _levelTimeElapsed = 0;
        _game.overlays.add(LaunchWidget.name);
        break;
      case GameStates.playing:
        _game.overlays.remove(LaunchWidget.name);
        break;
      case GameStates.paused:
        // TODO: Handle this case.
        break;
    }
  }
}
