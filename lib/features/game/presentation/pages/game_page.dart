import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../domain/entities/game_session.dart';
import '../../domain/entities/turn.dart';
import '../bloc/game_bloc.dart';
import '../bloc/game_state.dart';
import 'drawing_page.dart';
import 'guessing_page.dart';
import 'summary_page.dart';

class GamePage extends StatelessWidget {
  const GamePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: BlocBuilder<GameBloc, GameState>(
          builder: (context, state) {
            if (state is GameActive) {
              return Text('Round ${state.session.turns.length + 1}');
            }
            return const Text('Game');
          },
        ),
      ),
      body: BlocBuilder<GameBloc, GameState>(
        builder: (context, state) {
          if (state is GameActive) {
            return _buildActiveGame(context, state.session);
          } else if (state is GameCompleted) {
            return const SummaryPage();
          }
          return const Center(child: CircularProgressIndicator());
        },
      ),
    );
  }

  Widget _buildActiveGame(BuildContext context, GameSession session) {
    if (session.turns.isEmpty) {
      // First turn: Draw something
      return const DrawingPage(previousGuess: null);
    }

    final lastTurn = session.turns.last;
    if (lastTurn is DrawingTurn) {
      // Previous was drawing, now guess
      return GuessingPage(drawingTurn: lastTurn);
    } else if (lastTurn is GuessTurn) {
      // Previous was guess, now draw
      return DrawingPage(previousGuess: lastTurn.guess);
    }

    return const Center(child: Text('Unknown state'));
  }
}
