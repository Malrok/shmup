import 'package:flutter/painting.dart';
import 'package:shmup/engine/engine.presenter.dart';
import 'package:shmup/engine/widgets/game.widget.dart';

class ScoreDisplay {
  final ShmupGame game;
  late TextPainter painter;
  late TextStyle textStyle;
  late Offset position;

  int? _score;

  ScoreDisplay(this.game) {
    painter = TextPainter(
      textAlign: TextAlign.start,
      textDirection: TextDirection.ltr,
    );

    textStyle = TextStyle(
      color: Color(0xffffffff),
      fontSize: 12,
    );

    position = Offset.zero;
  }

  void render(Canvas c) {
    painter.paint(c, position);
  }

  void update(double t) {
    if (_score != EnginePresenter.instance.score) {
      _score = EnginePresenter.instance.score;
      painter.text = TextSpan(
        text: 'Score ${_score.toString()}',
        style: textStyle,
      );

      painter.layout();

      position = Offset(
        (game.canvasSize.x / 8) - (painter.width / 2),
        (game.canvasSize.y * .025) - (painter.height / 2),
      );
    }
  }
}
