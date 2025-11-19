import 'package:equatable/equatable.dart';
import 'turn.dart';

enum GameStatus { waiting, active, completed }

class GameSession extends Equatable {
  final String id;
  final List<Turn> turns;
  final GameStatus status;

  const GameSession({
    required this.id,
    required this.turns,
    this.status = GameStatus.waiting,
  });

  GameSession copyWith({
    String? id,
    List<Turn>? turns,
    GameStatus? status,
  }) {
    return GameSession(
      id: id ?? this.id,
      turns: turns ?? this.turns,
      status: status ?? this.status,
    );
  }

  @override
  List<Object?> get props => [id, turns, status];
}
