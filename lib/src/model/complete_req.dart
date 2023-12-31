import 'package:json_annotation/json_annotation.dart';
part 'complete_req.g.dart';

@JsonSerializable()
class CompleteReq {
  final String prompt;
  final String model;
  final double temperature;
  final int max_tokens;
  final double top_p;
  final double frequency_penalty;
  final double presence_penalty;
  /// ### example use it
  /// - ["You:"]
  ///Q: Who is Batman?
  ///A: Batman is a fictional comic book character.
  /// - Chat bot
  /// [" Human:", " AI:"]
  final List<String>? stop;

  CompleteReq({required this.prompt, required this.model,  this.temperature = .3, this.max_tokens = 100, this.top_p = 1.0, this.frequency_penalty = .0 , this.presence_penalty = .0,this.stop});

  factory CompleteReq.fromJson(Map<String,dynamic> data) => _$CompleteReqFromJson(data);
   Map<String,dynamic> toJson() => _$CompleteReqToJson(this);

}