import 'package:equatable/equatable.dart';
import '../../domain/entities/game_session.dart';

abstract class GameState extends Equatable {
  const GameState();

  @override
  List<Object?> get props => [];
}

class GameInitial extends GameState {}

class GameLoading extends GameState {}

class GameActive extends GameState {
  final GameSession session;

  const GameActive(this.session);

  @override
  List<Object?> get props => [session];
}

class GameCompleted extends GameState {
  final GameSession session;

  const GameCompleted(this.session);

  @override
  List<Object?> get props => [session];
}

class GameError extends GameState {
  final String message;

  const GameError(this.message);

  @override
  List<Object?> get props => [message];
}

class GameExported extends GameState {
  const GameExported();

  @override
  List<Object?> get props => [];
}
