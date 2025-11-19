// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'game_session_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

GameSessionModel _$GameSessionModelFromJson(Map<String, dynamic> json) =>
    GameSessionModel(
      id: json['id'] as String,
      turns: (json['turns'] as List<dynamic>)
          .map((e) => TurnModel.fromJson(e as Map<String, dynamic>))
          .toList(),
      status: json['status'] as String,
    );

Map<String, dynamic> _$GameSessionModelToJson(GameSessionModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'turns': instance.turns,
      'status': instance.status,
    };
