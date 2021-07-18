// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'level.model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

LevelModel _$LevelModelFromJson(Map<String, dynamic> json) {
  return LevelModel(
    enemies: (json['enemies'] as List<dynamic>)
        .map((e) => EnemyModel.fromJson(e as Map<String, dynamic>)),
  );
}

Map<String, dynamic> _$LevelModelToJson(LevelModel instance) =>
    <String, dynamic>{
      'enemies': instance.enemies.toList(),
    };
