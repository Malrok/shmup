import 'package:json_annotation/json_annotation.dart';
import 'package:shmup/models/enemy.model.dart';

part 'level.model.g.dart';

@JsonSerializable()
class LevelModel {
  @JsonKey(ignore: true)
  late int number;

  Iterable<EnemyModel> enemies;

  LevelModel({
    required this.enemies,
  });

  factory LevelModel.fromJson(Map<String, dynamic> json) => _$LevelModelFromJson(json);

  Map<String, dynamic> toJson() => _$LevelModelToJson(this);
}
