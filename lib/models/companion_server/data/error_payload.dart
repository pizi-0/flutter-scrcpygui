// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

class ErrorPayload {
  final String message;
  ErrorPayload({required this.message});

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'message': message,
    };
  }

  factory ErrorPayload.fromMap(Map<String, dynamic> map) {
    return ErrorPayload(
      message: map['message'] as String,
    );
  }

  String toJson() => json.encode(toMap());

  factory ErrorPayload.fromJson(String source) =>
      ErrorPayload.fromMap(json.decode(source) as Map<String, dynamic>);
}
