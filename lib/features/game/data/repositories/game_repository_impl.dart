import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:path_provider/path_provider.dart';
import 'package:share_plus/share_plus.dart';
import 'package:uuid/uuid.dart';
import '../../domain/entities/game_session.dart';
import '../../domain/entities/turn.dart';
import '../../domain/repositories/game_repository.dart';
import '../models/game_session_model.dart';
import '../../../../core/utils/pdf_generator.dart';

class GameRepositoryImpl implements GameRepository {
  final PdfGenerator _pdfGenerator = PdfGenerator();
  
  // In-memory storage for the active session
  GameSession? _currentSession;

  @override
  Future<GameSession> createSession() async {
    final id = const Uuid().v4().substring(0, 8); // Short ID for readability
    _currentSession = GameSession(id: id, turns: const []);
    return _currentSession!;
  }

  @override
  Future<GameSession> addTurn(String sessionId, Turn turn) async {
    if (_currentSession != null && _currentSession!.id == sessionId) {
      final updatedTurns = List<Turn>.from(_currentSession!.turns)..add(turn);
      _currentSession = _currentSession!.copyWith(turns: updatedTurns);
      return _currentSession!;
    }
    throw Exception('Session not found');
  }

  @override
  Future<GameSession?> getSession(String sessionId) async {
    if (_currentSession != null && _currentSession!.id == sessionId) {
      return _currentSession;
    }
    return null;
  }

  @override
  Future<XFile> exportSessionJson(GameSession session) async {
    final model = GameSessionModel.fromEntity(session);
    final jsonString = jsonEncode(model.toJson());
    final bytes = utf8.encode(jsonString);
    
    if (kIsWeb) {
      return XFile.fromData(
        Uint8List.fromList(bytes),
        mimeType: 'application/json',
        name: 'game_${session.id}.json',
      );
    } else {
      final directory = await getTemporaryDirectory();
      final file = File('${directory.path}/game_${session.id}.json');
      await file.writeAsBytes(bytes);
      return XFile(file.path, mimeType: 'application/json', name: 'game_${session.id}.json');
    }
  }

  @override
  Future<GameSession> importSessionJson(XFile xFile) async {
    final jsonString = await xFile.readAsString();
    final jsonMap = jsonDecode(jsonString);
    final model = GameSessionModel.fromJson(jsonMap);
    final session = model.toEntity();
    _currentSession = session; // Set as current
    return session;
  }

  @override
  Future<XFile> exportSessionToPdf(GameSession session) async {
    final bytes = await _pdfGenerator.generate(session);
    
    if (kIsWeb) {
      return XFile.fromData(
        bytes,
        mimeType: 'application/pdf',
        name: 'game_session_${session.id}.pdf',
      );
    } else {
      final output = await getTemporaryDirectory();
      final file = File('${output.path}/game_session_${session.id}.pdf');
      await file.writeAsBytes(bytes);
      return XFile(file.path, mimeType: 'application/pdf', name: 'game_session_${session.id}.pdf');
    }
  }
}
