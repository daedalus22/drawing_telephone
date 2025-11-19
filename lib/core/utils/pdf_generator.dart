import 'dart:typed_data';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import '../../features/game/domain/entities/game_session.dart';
import '../../features/game/domain/entities/turn.dart';

class PdfGenerator {
  Future<Uint8List> generate(GameSession session) async {
    final pdf = pw.Document();

    pdf.addPage(
      pw.MultiPage(
        pageFormat: PdfPageFormat.a4,
        build: (pw.Context context) {
          return [
            pw.Header(
              level: 0,
              child: pw.Text('Drawing Telephone Game - Session ${session.id}'),
            ),
            ...session.turns.map((turn) {
              return pw.Container(
                margin: const pw.EdgeInsets.only(bottom: 20),
                child: _buildTurnWidget(turn),
              );
            }),
          ];
        },
      ),
    );

    return pdf.save();
  }

  pw.Widget _buildTurnWidget(Turn turn) {
    if (turn is GuessTurn) {
      return pw.Column(
        crossAxisAlignment: pw.CrossAxisAlignment.start,
        children: [
          pw.Text('Player: ${turn.playerName}',
              style: pw.TextStyle(fontWeight: pw.FontWeight.bold)),
          pw.Text('Guessed: ${turn.guess}'),
          pw.Divider(),
        ],
      );
    } else if (turn is DrawingTurn) {
      return pw.Column(
        crossAxisAlignment: pw.CrossAxisAlignment.start,
        children: [
          pw.Text('Player: ${turn.playerName}',
              style: pw.TextStyle(fontWeight: pw.FontWeight.bold)),
          pw.Container(
            height: 200,
            decoration: pw.BoxDecoration(border: pw.Border.all()),
            child: pw.CustomPaint(
              size: const PdfPoint(400, 200),
              painter: (canvas, size) {
                if (turn.points.isEmpty) return;

                // Calculate bounding box
                double minX = double.infinity;
                double minY = double.infinity;
                double maxX = double.negativeInfinity;
                double maxY = double.negativeInfinity;

                bool hasPoints = false;
                for (var point in turn.points) {
                  if (point != null) {
                    hasPoints = true;
                    if (point.offset.dx < minX) minX = point.offset.dx;
                    if (point.offset.dy < minY) minY = point.offset.dy;
                    if (point.offset.dx > maxX) maxX = point.offset.dx;
                    if (point.offset.dy > maxY) maxY = point.offset.dy;
                  }
                }

                if (!hasPoints) return;

                final double drawingWidth = maxX - minX;
                final double drawingHeight = maxY - minY;

                // Target size (matches the container size defined above)
                const double targetWidth = 400;
                const double targetHeight = 200;
                const double padding = 10;

                // Calculate scale to fit
                double scaleX = (targetWidth - padding * 2) / drawingWidth;
                double scaleY = (targetHeight - padding * 2) / drawingHeight;
                double scale = scaleX < scaleY ? scaleX : scaleY;

                // Center the drawing
                double offsetX =
                    (targetWidth - drawingWidth * scale) / 2 - minX * scale;
                double offsetY =
                    (targetHeight - drawingHeight * scale) / 2 - minY * scale;

                // Draw lines
                for (int i = 0; i < turn.points.length - 1; i++) {
                  final p1 = turn.points[i];
                  final p2 = turn.points[i + 1];

                  if (p1 != null && p2 != null) {
                    canvas.drawLine(
                      p1.offset.dx * scale + offsetX,
                      p1.offset.dy * scale + offsetY,
                      p2.offset.dx * scale + offsetX,
                      p2.offset.dy * scale + offsetY,
                    );
                    canvas.setStrokeColor(PdfColors.black);
                    canvas.setLineWidth(2); // Fixed line width for PDF
                    canvas.strokePath();
                  } else if (p1 != null && p2 == null) {
                    // Draw a dot for single points
                    canvas.drawEllipse(p1.offset.dx * scale + offsetX,
                        p1.offset.dy * scale + offsetY, 2, 2);
                    canvas.setFillColor(PdfColors.black);
                    canvas.fillPath();
                  }
                }
              },
            ),
          ),
          pw.Divider(),
        ],
      );
    }
    return pw.Container();
  }
}
