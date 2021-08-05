import 'package:flutter/painting.dart';
import 'package:shmup/engine/engine.presenter.dart';
import 'package:shmup/engine/widgets/game.widget.dart';

class LivesDisplay {
  final ShmupGame game;
  late TextPainter painter;
  late TextStyle textStyle;
  late Offset position;

  int? _lives;

  LivesDisplay(this.game) {
    painter = TextPainter(
      textAlign: TextAlign.end,
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
    if (_lives != EnginePresenter.instance.lives) {
      _lives = EnginePresenter.instance.lives;
      painter.text = TextSpan(
        text: 'Lives ${_lives.toString()}',
        style: textStyle,
      );

      painter.layout();

      position = Offset(
        (7 * game.canvasSize.x / 8) - (painter.width / 2),
        (game.canvasSize.y * .025) - (painter.height / 2),
      );
    }
  }
}
