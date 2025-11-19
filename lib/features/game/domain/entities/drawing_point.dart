import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';

class DrawingPoint extends Equatable {
  final Offset offset;
  final Paint paint;

  const DrawingPoint({
    required this.offset,
    required this.paint,
  });

  @override
  List<Object?> get props => [offset, paint];
}
