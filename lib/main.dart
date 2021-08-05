import 'package:flame/game.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:shmup/engine/engine.presenter.dart';
import 'package:shmup/engine/widgets/game.widget.dart';
import 'package:shmup/screens/launch.screen.dart';

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
            LaunchScreen.name: (BuildContext context, ShmupGame game) {
              return LaunchScreen(() => EnginePresenter.instance.loadLevel(1));
            }
          },
          initialActiveOverlays: [LaunchScreen.name],
        ),
      ),
    ),
  );
}
