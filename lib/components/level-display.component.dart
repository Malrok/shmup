import 'package:flutter/painting.dart';
import 'package:shmup/engine/engine.presenter.dart';
import 'package:shmup/engine/shmup.game.dart';

class LevelDisplay {
  static const double TIME_OUT = 2;

  final ShmupGame game;
  late TextPainter painter;
  late TextStyle textStyle;
  late Offset position;

  late double _currentTime = -1;
  int? _levelNumber;

  LevelDisplay(this.game) {
    painter = TextPainter(
      textAlign: TextAlign.end,
      textDirection: TextDirection.ltr,
    );

    textStyle = TextStyle(
      color: Color(0xffffffff),
      fontSize: 48,
    );

    position = Offset.zero;
  }

  initialize() {
    _currentTime = TIME_OUT;
  }

  void render(Canvas c) {
    if (_currentTime > -1) {
      painter.paint(c, position);
    }
  }

  void update(double t) {
    if (_currentTime > -1) {
      _currentTime -= t;
      if (_currentTime <= 0) _currentTime = -1;
    }
    if (_levelNumber != EnginePresenter.instance.currentLevelNumber) {
      _levelNumber = EnginePresenter.instance.currentLevelNumber;
      painter.text = TextSpan(
        text: 'Level ${_levelNumber.toString()}',
        style: textStyle,
      );

      painter.layout();

      position = Offset(
        (game.canvasSize.x / 2) - (painter.width / 2),
        (game.canvasSize.y / 2) - (painter.height / 2),
      );
    }
  }
}
