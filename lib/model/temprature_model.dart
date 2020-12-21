import 'package:json_annotation/json_annotation.dart';

part 'temprature_model.g.dart';

@JsonSerializable()
class TempratureModel {
  String message;
  double temprature;

  @JsonKey(name: "default_temp")
  double defaultTemp;

  TempratureModel({this.message, this.temprature, this.defaultTemp});

  factory TempratureModel.fromJson(Map<String, dynamic> json) =>
      _$TempratureModelFromJson(json);

  Map<String, dynamic> toJson() => _$TempratureModelToJson(this);

  TempratureModel.withError(String error) : message = error;
}
