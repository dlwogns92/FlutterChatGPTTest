import 'package:chat_gpt_sdk/src/model/usage.dart';
import 'package:json_annotation/json_annotation.dart';
import 'choices.dart';
part 'edit_res.g.dart';

@JsonSerializable()
class EditRes {
  final String id;
  final String object;
  final int created;
  final String model;
  final List<Choices> choices;
  final Usage usage;

  EditRes(
      this.id, this.object, this.created, this.model, this.choices, this.usage);

  factory EditRes.fromJson(Map<String, dynamic> data) =>
      _$EditResFromJson(data);
  Map<String, dynamic> toJson() => _$EditResToJson(this);
}
