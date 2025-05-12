// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';
import 'dart:io';

import 'package:scrcpygui/models/companion_server/data/auth_payload.dart';

class AuthdClient {
  final Socket socket;
  final AuthPayload authPayload;
  late String clientAddress;

  AuthdClient(this.socket, this.authPayload) {
    clientAddress = socket.remoteAddress.address;
  }
}

class BlockedClient {
  final String clientAddress;
  final String deviceName;
  final String deviceModel;

  BlockedClient(
      {required this.clientAddress,
      required this.deviceName,
      required this.deviceModel});

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'clientAddress': clientAddress,
      'deviceName': deviceName,
      'deviceModel': deviceModel,
    };
  }

  factory BlockedClient.fromMap(Map<String, dynamic> map) {
    return BlockedClient(
      clientAddress: map['clientAddress'] as String,
      deviceName: map['deviceName'] as String,
      deviceModel: map['deviceModel'] as String,
    );
  }

  String toJson() => json.encode(toMap());

  factory BlockedClient.fromJson(String source) =>
      BlockedClient.fromMap(json.decode(source) as Map<String, dynamic>);
}
