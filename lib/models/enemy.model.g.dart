// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'enemy.model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

EnemyModel _$EnemyModelFromJson(Map<String, dynamic> json) {
  return EnemyModel(
    energy: json['energy'] as int,
    sprite: json['sprite'] as String,
    score: json['score'] as int,
    startx: (json['startx'] as num).toDouble(),
    starty: (json['starty'] as num).toDouble(),
    speed: (json['speed'] as num).toDouble(),
    size: (json['size'] as num).toDouble(),
  );
}

Map<String, dynamic> _$EnemyModelToJson(EnemyModel instance) =>
    <String, dynamic>{
      'energy': instance.energy,
      'sprite': instance.sprite,
      'score': instance.score,
      'startx': instance.startx,
      'starty': instance.starty,
      'speed': instance.speed,
      'size': instance.size,
    };
