// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'temprature_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

TempratureModel _$TempratureModelFromJson(Map<String, dynamic> json) {
  return TempratureModel(
    message: json['message'] as String,
    temprature: (json['temprature'] as num)?.toDouble(),
    defaultTemp: (json['default_temp'] as num)?.toDouble(),
  );
}

Map<String, dynamic> _$TempratureModelToJson(TempratureModel instance) =>
    <String, dynamic>{
      'message': instance.message,
      'temprature': instance.temprature,
      'default_temp': instance.defaultTemp,
    };
