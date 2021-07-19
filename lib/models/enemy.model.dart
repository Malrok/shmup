import 'package:shmup/models/path.model.dart';

class EnemyModel {
  int id;
  int energy;
  String sprite;
  int score;
  double startx;
  double starty;
  double speed;
  double size;
  Iterable<PathModel> paths;

  EnemyModel({
    required this.id,
    required this.energy,
    required this.sprite,
    required this.score,
    required this.startx,
    required this.starty,
    required this.speed,
    required this.size,
    required this.paths,
  });

  factory EnemyModel.fromJson(int id, Map<String, dynamic> json) => EnemyModel(
        id: id,
        energy: json['energy'] as int,
        sprite: json['sprite'] as String,
        score: json['score'] as int,
        startx: (json['startx'] as num).toDouble(),
        starty: (json['starty'] as num).toDouble(),
        speed: (json['speed'] as num).toDouble(),
        size: (json['size'] as num).toDouble(),
        paths: (json['paths'] as List<dynamic>)
            .map<PathModel>((e) => PathModel.fromJson(e as Map<String, dynamic>))
            .toList(),
      );
}
