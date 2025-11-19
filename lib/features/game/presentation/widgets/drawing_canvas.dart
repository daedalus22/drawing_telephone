import 'dart:ui' as ui;
import 'package:flutter/material.dart';
import '../../domain/entities/drawing_point.dart';

class DrawingCanvas extends StatelessWidget {
  final List<DrawingPoint?> points;
  final bool shouldScaleToFit;

  const DrawingCanvas({
    super.key,
    required this.points,
    this.shouldScaleToFit = false,
  });

  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      painter: _DrawingPainter(points, shouldScaleToFit: shouldScaleToFit),
      size: Size.infinite,
    );
  }
}

class _DrawingPainter extends CustomPainter {
  final List<DrawingPoint?> points;
  final bool shouldScaleToFit;

  _DrawingPainter(this.points, {this.shouldScaleToFit = false});

  @override
  void paint(Canvas canvas, Size size) {
    if (points.isEmpty) return;

    if (shouldScaleToFit) {
      _applyScaleToFit(canvas, size);
    }

    for (int i = 0; i < points.length - 1; i++) {
      if (points[i] != null && points[i + 1] != null) {
        canvas.drawLine(
          points[i]!.offset,
          points[i + 1]!.offset,
          points[i]!.paint,
        );
      } else if (points[i] != null && points[i + 1] == null) {
        canvas.drawPoints(
          ui.PointMode.points,
          [points[i]!.offset],
          points[i]!.paint,
        );
      }
    }
  }

  void _applyScaleToFit(Canvas canvas, Size size) {
    if (points.isEmpty) return;

    double minX = double.infinity;
    double minY = double.infinity;
    double maxX = double.negativeInfinity;
    double maxY = double.negativeInfinity;

    bool hasPoints = false;
    for (var point in points) {
      if (point != null) {
        hasPoints = true;
        if (point.offset.dx < minX) minX = point.offset.dx;
        if (point.offset.dy < minY) minY = point.offset.dy;
        if (point.offset.dx > maxX) maxX = point.offset.dx;
        if (point.offset.dy > maxY) maxY = point.offset.dy;
      }
    }

    if (!hasPoints) return;

    // Add some padding around the drawing
    const double padding = 20.0;
    final double drawingWidth = maxX - minX;
    final double drawingHeight = maxY - minY;

    // Avoid division by zero if drawing is a single point
    if (drawingWidth == 0 || drawingHeight == 0) {
      // Center the single point
      final double offsetX = size.width / 2 - minX;
      final double offsetY = size.height / 2 - minY;
      canvas.translate(offsetX, offsetY);
      return;
    }

    final double scaleX = (size.width - padding * 2) / drawingWidth;
    final double scaleY = (size.height - padding * 2) / drawingHeight;

    // Use the smaller scale to fit both dimensions
    double scale = scaleX < scaleY ? scaleX : scaleY;

    // Limit scale up to avoid pixelation if drawing is tiny, but allow scaling down
    // Actually, for vector-like drawing, scaling up is fine, but let's limit it reasonably
    // to avoid massive strokes if they drew a tiny dot.
    // For now, let's just fit it.

    // Calculate centering offsets
    final double scaledWidth = drawingWidth * scale;
    final double scaledHeight = drawingHeight * scale;

    final double offsetX = (size.width - scaledWidth) / 2 - minX * scale;
    final double offsetY = (size.height - scaledHeight) / 2 - minY * scale;

    canvas.translate(offsetX, offsetY);
    canvas.scale(scale);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}
