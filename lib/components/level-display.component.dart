import 'package:flutter/painting.dart';
import 'package:shmup/engine/engine.presenter.dart';
import 'package:shmup/engine/shmup.game.dart';

class LevelDisplay {
  final ShmupGame game;
  late TextPainter painter;
  late TextStyle textStyle;
  late Offset position;

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

  void render(Canvas c) {
    painter.paint(c, position);
  }

  void update(double t) {
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
