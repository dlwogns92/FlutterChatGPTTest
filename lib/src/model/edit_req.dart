import 'package:json_annotation/json_annotation.dart';
part 'edit_req.g.dart';

@JsonSerializable()
class EditReq {
  final String model;
  final String input;
  final String instruction;
  final int n;
  final double temperature;
  final double top_p;

  EditReq({required this.model, this.input = "", required this.instruction, this.n = 1, this.temperature = 1, this.top_p = 1});

  factory EditReq.fromJson(Map<String,dynamic> data) => _$EditReqFromJson(data);
   Map<String,dynamic> toJson() => _$EditReqToJson(this);

}