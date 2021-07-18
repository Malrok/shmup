import 'package:json_annotation/json_annotation.dart';

part 'enemy.model.g.dart';

@JsonSerializable()
class EnemyModel {
  int energy;
  String sprite;
  int score;
  double startx;
  double starty;
  double speed;
  double size;

  EnemyModel({
    required this.energy,
    required this.sprite,
    required this.score,
    required this.startx,
    required this.starty,
    required this.speed,
    required this.size,
  });

  factory EnemyModel.fromJson(Map<String, dynamic> json) => _$EnemyModelFromJson(json);

  Map<String, dynamic> toJson() => _$EnemyModelToJson(this);
}
