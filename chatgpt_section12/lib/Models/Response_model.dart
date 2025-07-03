import 'package:chatgpt_section12/Models/Choices.dart';
import 'package:chatgpt_section12/Models/Usage.dart';

class ResponseModel {
  ResponseModel(
      {this.id,
      this.object,
      this.created,
      this.model,
      this.choices,
      this.usage});

  final String? id;
  final String? object;
  final String? created;
  final String? model;
  final Choices? choices;
  final Usage? usage;

  factory ResponseModel.fromJson(Map<String, dynamic>? json) {
    return ResponseModel(
      id: json?["id"].toString(),
      object: json?['object'].toString(),
      created: json?['created'].toString(),
      model: json?['model'].toString(),
      choices: Choices.fromJson(json?['choices'][0]),
      usage: Usage.fromJson(json?['usage'][0]),
    );
  }

  Map<String, dynamic>? toJson() => {
        "id": this.id,
        "object": this.object,
        "created": this.created,
        "model": this.model,
        "choices": this.choices,
        "usage": this.usage,
      };
}
