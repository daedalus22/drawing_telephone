// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'drawing_point_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

DrawingPointModel _$DrawingPointModelFromJson(Map<String, dynamic> json) =>
    DrawingPointModel(
      dx: (json['dx'] as num).toDouble(),
      dy: (json['dy'] as num).toDouble(),
      colorValue: (json['colorValue'] as num).toInt(),
      strokeWidth: (json['strokeWidth'] as num).toDouble(),
    );

Map<String, dynamic> _$DrawingPointModelToJson(DrawingPointModel instance) =>
    <String, dynamic>{
      'dx': instance.dx,
      'dy': instance.dy,
      'colorValue': instance.colorValue,
      'strokeWidth': instance.strokeWidth,
    };
