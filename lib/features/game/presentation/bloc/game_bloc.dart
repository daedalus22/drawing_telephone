import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:share_plus/share_plus.dart';
import 'package:uuid/uuid.dart';
import '../../domain/entities/game_session.dart';
import '../../domain/entities/turn.dart';
import '../../domain/repositories/game_repository.dart';
import 'game_event.dart';
import 'game_state.dart';

class GameBloc extends Bloc<GameEvent, GameState> {
  final GameRepository repository;

  GameBloc({required this.repository}) : super(GameInitial()) {
    on<StartGame>(_onStartGame);
    on<SubmitDrawing>(_onSubmitDrawing);
    on<SubmitGuess>(_onSubmitGuess);
    on<ShareSession>(_onShareSession);
    on<ExportPdf>(_onExportPdf);
    on<ImportSession>(_onImportSession);
    on<EndGame>(_onEndGame);
  }

  Future<void> _onStartGame(StartGame event, Emitter<GameState> emit) async {
    emit(GameLoading());
    try {
      final session = await repository.createSession();
      emit(GameActive(session));
    } catch (e) {
      emit(GameError(e.toString()));
    }
  }

  Future<void> _onSubmitDrawing(SubmitDrawing event, Emitter<GameState> emit) async {
    final currentState = state;
    if (currentState is GameActive) {
      try {
        final turn = DrawingTurn(
          id: const Uuid().v4(),
          playerName: event.playerName,
          timestamp: DateTime.now(),
          points: event.points,
        );
        final updatedSession = await repository.addTurn(currentState.session.id, turn);
        _emitNextState(updatedSession, emit);
      } catch (e) {
        emit(GameError(e.toString()));
      }
    }
  }

  Future<void> _onSubmitGuess(SubmitGuess event, Emitter<GameState> emit) async {
    final currentState = state;
    if (currentState is GameActive) {
      try {
        final turn = GuessTurn(
          id: const Uuid().v4(),
          playerName: event.playerName,
          timestamp: DateTime.now(),
          guess: event.guess,
        );
        final updatedSession = await repository.addTurn(currentState.session.id, turn);
        _emitNextState(updatedSession, emit);
      } catch (e) {
        emit(GameError(e.toString()));
      }
    }
  }

  void _emitNextState(GameSession session, Emitter<GameState> emit) {
    if (session.turns.length >= 5) {
      emit(GameCompleted(session));
    } else {
      emit(GameActive(session));
    }
  }

  Future<void> _onEndGame(EndGame event, Emitter<GameState> emit) async {
    final currentState = state;
    if (currentState is GameActive) {
      emit(GameCompleted(currentState.session));
    }
  }

  Future<void> _onShareSession(ShareSession event, Emitter<GameState> emit) async {
    final currentState = state;
    if (currentState is GameActive || currentState is GameCompleted) {
      try {
        final session = (currentState as dynamic).session as GameSession;
        final xFile = await repository.exportSessionJson(session);
        await Share.shareXFiles([xFile], text: 'Check out our drawing game!');
      } catch (e) {
        emit(GameError(e.toString()));
      }
    }
  }

  Future<void> _onExportPdf(ExportPdf event, Emitter<GameState> emit) async {
    final currentState = state;
    if (currentState is GameActive || currentState is GameCompleted) {
      try {
        final session = (currentState as dynamic).session as GameSession;
        final xFile = await repository.exportSessionToPdf(session);
        await Share.shareXFiles([xFile], text: 'Game Summary PDF');
        emit(GameExported());
        // Restore state after export
        if (currentState is GameActive) {
          emit(GameActive(session));
        } else {
          emit(GameCompleted(session));
        }
      } catch (e) {
        emit(GameError(e.toString()));
      }
    }
  }

  Future<void> _onImportSession(ImportSession event, Emitter<GameState> emit) async {
    emit(GameLoading());
    try {
      final session = await repository.importSessionJson(event.file);
      emit(GameActive(session));
    } catch (e) {
      emit(GameError(e.toString()));
    }
  }
}
