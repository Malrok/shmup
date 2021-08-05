import 'package:shmup/models/enemy.model.dart';

class LevelModel {
  List<EnemyModel> enemies;

  LevelModel({
    required this.enemies,
  });

  factory LevelModel.fromJson(Map<String, dynamic> json) {
    List<EnemyModel> enemies = [];
    List<dynamic> jsonEnemies = json['enemies'];
    for (int index = 0; index < jsonEnemies.length; index++) {
      enemies.add(EnemyModel.fromJson(index, jsonEnemies[index] as Map<String, dynamic>));
    }
    return LevelModel(enemies: enemies);
  }
}
