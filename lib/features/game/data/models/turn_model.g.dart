// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'turn_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

TurnModel _$TurnModelFromJson(Map<String, dynamic> json) => TurnModel(
      id: json['id'] as String,
      playerName: json['playerName'] as String,
      timestamp: DateTime.parse(json['timestamp'] as String),
      type: json['type'] as String,
      points: (json['points'] as List<dynamic>?)
          ?.map((e) => DrawingPointModel.fromJson(e as Map<String, dynamic>))
          .toList(),
      guess: json['guess'] as String?,
    );

Map<String, dynamic> _$TurnModelToJson(TurnModel instance) => <String, dynamic>{
      'id': instance.id,
      'playerName': instance.playerName,
      'timestamp': instance.timestamp.toIso8601String(),
      'type': instance.type,
      'points': instance.points,
      'guess': instance.guess,
    };
