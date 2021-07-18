import 'package:flame/game.dart';
import 'package:flutter/material.dart';
import 'package:shmup/engine/presenter.dart';
import 'package:shmup/engine/widgets/game.widget.dart';
import 'package:shmup/screens/launch.dart';

Future<void> main() async {
  ShmupGame shmupGame = ShmupGame();

  await ShmupPresenter.instance.init(shmupGame);

  runApp(
    MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        body: GameWidget(
          game: shmupGame,
          overlayBuilderMap: {
            LaunchScreen.name: (BuildContext context, ShmupGame game) {
              return LaunchScreen(() => ShmupPresenter.instance.loadLevel());
            }
          },
          initialActiveOverlays: [LaunchScreen.name],
        ),
      ),
    ),
  );
}
