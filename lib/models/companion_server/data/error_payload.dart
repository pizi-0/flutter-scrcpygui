// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

class ErrorPayload {
  final String message;
  final ErrorType type;

  ErrorPayload({required this.message, required this.type});

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'message': message,
      'type': ErrorType.values.indexOf(type),
    };
  }

  factory ErrorPayload.fromMap(Map<String, dynamic> map) {
    return ErrorPayload(
      message: map['message'] as String,
      type: ErrorType.values[map['type'] as int],
    );
  }

  String toJson() => json.encode(toMap());

  factory ErrorPayload.fromJson(String source) =>
      ErrorPayload.fromMap(json.decode(source) as Map<String, dynamic>);
}

enum ErrorType {
  generic,
  request,
  blocked,
  invalidAuth,
}
