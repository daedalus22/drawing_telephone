import 'package:equatable/equatable.dart';
import 'drawing_point.dart';

abstract class Turn extends Equatable {
  final String id;
  final String playerName;
  final DateTime timestamp;

  const Turn({
    required this.id,
    required this.playerName,
    required this.timestamp,
  });

  @override
  List<Object?> get props => [id, playerName, timestamp];
}

class DrawingTurn extends Turn {
  final List<DrawingPoint?> points; // Null indicates a break in the line

  const DrawingTurn({
    required super.id,
    required super.playerName,
    required super.timestamp,
    required this.points,
  });

  @override
  List<Object?> get props => [...super.props, points];
}

class GuessTurn extends Turn {
  final String guess;

  const GuessTurn({
    required super.id,
    required super.playerName,
    required super.timestamp,
    required this.guess,
  });

  @override
  List<Object?> get props => [...super.props, guess];
}
