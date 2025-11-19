import 'package:equatable/equatable.dart';
import 'package:share_plus/share_plus.dart';
import '../../domain/entities/drawing_point.dart';

abstract class GameEvent extends Equatable {
  const GameEvent();

  @override
  List<Object?> get props => [];
}

class StartGame extends GameEvent {}

class SubmitDrawing extends GameEvent {
  final List<DrawingPoint?> points;
  final String playerName;

  const SubmitDrawing(this.points, this.playerName);

  @override
  List<Object?> get props => [points, playerName];
}

class SubmitGuess extends GameEvent {
  final String guess;
  final String playerName;

  const SubmitGuess(this.guess, this.playerName);

  @override
  List<Object?> get props => [guess, playerName];
}

class ShareSession extends GameEvent {}

class ExportPdf extends GameEvent {}

class ImportSession extends GameEvent {
  final XFile file;

  const ImportSession(this.file);

  @override
  List<Object?> get props => [file];
}

class EndGame extends GameEvent {}
