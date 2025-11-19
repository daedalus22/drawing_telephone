import 'package:json_annotation/json_annotation.dart';
import '../../domain/entities/turn.dart';
import 'drawing_point_model.dart';

part 'turn_model.g.dart';

@JsonSerializable()
class TurnModel {
  final String id;
  final String playerName;
  final DateTime timestamp;
  final String type; // 'drawing' or 'guess'
  final List<DrawingPointModel>? points;
  final String? guess;

  TurnModel({
    required this.id,
    required this.playerName,
    required this.timestamp,
    required this.type,
    this.points,
    this.guess,
  });

  factory TurnModel.fromEntity(Turn turn) {
    if (turn is DrawingTurn) {
      return TurnModel(
        id: turn.id,
        playerName: turn.playerName,
        timestamp: turn.timestamp,
        type: 'drawing',
        points: turn.points
            .map((p) => p != null ? DrawingPointModel.fromEntity(p) : null)
            .whereType<DrawingPointModel>() // Filter out nulls for simplicity in this basic model, or handle nulls if needed for line breaks
            .toList(), 
            // Note: Handling nulls in a list for JSON can be tricky. 
            // For now, let's assume we might need a better structure for paths if we want to support multiple strokes perfectly.
            // A better approach for paths: List<List<DrawingPointModel>> for strokes.
            // But sticking to the current entity structure:
            // We'll just store non-null points for now or use a special "break" point.
      );
    } else if (turn is GuessTurn) {
      return TurnModel(
        id: turn.id,
        playerName: turn.playerName,
        timestamp: turn.timestamp,
        type: 'guess',
        guess: turn.guess,
      );
    }
    throw Exception('Unknown Turn type');
  }
  
  // Revised approach for DrawingTurn to support strokes:
  // The Entity has List<DrawingPoint?>.
  // We can serialize this as a List<Map<String, dynamic>?>.
  
  factory TurnModel.fromJson(Map<String, dynamic> json) => _$TurnModelFromJson(json);
  Map<String, dynamic> toJson() => _$TurnModelToJson(this);

  Turn toEntity() {
    if (type == 'drawing') {
      return DrawingTurn(
        id: id,
        playerName: playerName,
        timestamp: timestamp,
        points: points?.map((p) => p.toEntity()).toList() ?? [],
      );
    } else {
      return GuessTurn(
        id: id,
        playerName: playerName,
        timestamp: timestamp,
        guess: guess ?? '',
      );
    }
  }
}
