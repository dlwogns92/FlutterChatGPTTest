// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'edit_req.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

EditReq _$EditReqFromJson(Map<String, dynamic> json) => EditReq(
      model: json['model'] as String,
      input: json['input'] as String? ?? "",
      instruction: json['instruction'] as String,
      n: json['n'] as int? ?? 1,
      temperature: (json['frequency_penalty'] as num?)?.toDouble() ?? 1.0,
      top_p: (json['top_p'] as num?)?.toDouble() ?? 1.0
    );

Map<String, dynamic> _$EditReqToJson(EditReq instance) =>
    <String, dynamic>{
      'model': instance.model,
      'input': instance.input,
      'instruction': instance.instruction,
      'n': instance.n,
      'temperature': instance.temperature,
      'top_p': instance.top_p
    };
