import 'package:flame/game.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:shmup/engine/engine.presenter.dart';
import 'package:shmup/engine/shmup.game.dart';
import 'package:shmup/widgets/launch.widget.dart';

Future<void> main() async {
  ShmupGame shmupGame = ShmupGame();

  await EnginePresenter.instance.init(shmupGame);

  WidgetsFlutterBinding.ensureInitialized();

  SystemChrome.setEnabledSystemUIOverlays([]);

  runApp(
    MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        body: GameWidget(
          game: shmupGame,
          overlayBuilderMap: {
            LaunchWidget.name: (BuildContext context, ShmupGame game) {
              return LaunchWidget(() => EnginePresenter.instance.loadLevel(1));
            }
          },
          initialActiveOverlays: [LaunchWidget.name],
        ),
      ),
    ),
  );
}
