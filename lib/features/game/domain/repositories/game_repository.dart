import 'package:share_plus/share_plus.dart';
import '../entities/game_session.dart';
import '../entities/turn.dart';

abstract class GameRepository {
  Future<GameSession> createSession();
  Future<GameSession> addTurn(String sessionId, Turn turn);
  Future<GameSession?> getSession(String sessionId);
  Future<XFile> exportSessionToPdf(GameSession session);
  Future<XFile> exportSessionJson(GameSession session);
  Future<GameSession> importSessionJson(XFile file);
}
