// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'edit_res.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

EditRes _$EditResFromJson(Map<String, dynamic> json) => EditRes(
      json['id'] as String,
      json['object'] as String,
      json['created'] as int,
      json['model'] as String,
      (json['choices'] as List<dynamic>)
          .map((e) => Choices.fromJson(e as Map<String, dynamic>))
          .toList(),
      Usage.fromJson(json['usage'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$EditResToJson(EditRes instance) =>
    <String, dynamic>{
      'id': instance.id,
      'object': instance.object,
      'created': instance.created,
      'model': instance.model,
      'choices': instance.choices,
      'usage': instance.usage,
    };
