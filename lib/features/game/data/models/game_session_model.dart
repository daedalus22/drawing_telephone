import 'package:json_annotation/json_annotation.dart';
import '../../domain/entities/game_session.dart';
import 'turn_model.dart';

part 'game_session_model.g.dart';

@JsonSerializable()
class GameSessionModel {
  final String id;
  final List<TurnModel> turns;
  final String status;

  GameSessionModel({
    required this.id,
    required this.turns,
    required this.status,
  });

  factory GameSessionModel.fromEntity(GameSession session) {
    return GameSessionModel(
      id: session.id,
      turns: session.turns.map((t) => TurnModel.fromEntity(t)).toList(),
      status: session.status.name,
    );
  }

  factory GameSessionModel.fromJson(Map<String, dynamic> json) =>
      _$GameSessionModelFromJson(json);

  Map<String, dynamic> toJson() => _$GameSessionModelToJson(this);

  GameSession toEntity() {
    return GameSession(
      id: id,
      turns: turns.map((t) => t.toEntity()).toList(),
      status: GameStatus.values.firstWhere((e) => e.name == status),
    );
  }
}
