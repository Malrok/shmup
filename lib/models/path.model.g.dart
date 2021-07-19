// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'path.model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

PathModel _$PathModelFromJson(Map<String, dynamic> json) {
  return PathModel(
    vectorx: (json['vectorx'] as num).toDouble(),
    vectory: (json['vectory'] as num).toDouble(),
  );
}

Map<String, dynamic> _$PathModelToJson(PathModel instance) => <String, dynamic>{
      'vectorx': instance.vectorx,
      'vectory': instance.vectory,
    };
