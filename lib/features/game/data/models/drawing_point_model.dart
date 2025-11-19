import 'package:flutter/material.dart';
import 'package:json_annotation/json_annotation.dart';
import '../../domain/entities/drawing_point.dart';

part 'drawing_point_model.g.dart';

@JsonSerializable()
class DrawingPointModel extends DrawingPoint {
  final double dx;
  final double dy;
  final int colorValue;
  final double strokeWidth;

  DrawingPointModel({
    required this.dx,
    required this.dy,
    required this.colorValue,
    required this.strokeWidth,
  }) : super(
          offset: const Offset(0, 0), // Placeholder, overridden by dx/dy logic if needed, but we use dx/dy for serialization
          paint: Paint(), // Placeholder
        );

  factory DrawingPointModel.fromEntity(DrawingPoint point) {
    return DrawingPointModel(
      dx: point.offset.dx,
      dy: point.offset.dy,
      colorValue: point.paint.color.value,
      strokeWidth: point.paint.strokeWidth,
    );
  }

  DrawingPoint toEntity() {
    return DrawingPoint(
      offset: Offset(dx, dy),
      paint: Paint()
        ..color = Color(colorValue)
        ..strokeWidth = strokeWidth
        ..strokeCap = StrokeCap.round,
    );
  }

  factory DrawingPointModel.fromJson(Map<String, dynamic> json) =>
      _$DrawingPointModelFromJson(json);

  Map<String, dynamic> toJson() => _$DrawingPointModelToJson(this);
}
