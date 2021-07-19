import 'package:json_annotation/json_annotation.dart';

part 'path.model.g.dart';

@JsonSerializable()
class PathModel {
  double vectorx;
  double vectory;

  PathModel({
    required this.vectorx,
    required this.vectory,
  });

  factory PathModel.fromJson(Map<String, dynamic> json) => _$PathModelFromJson(json);

  Map<String, dynamic> toJson() => _$PathModelToJson(this);
}
