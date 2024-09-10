// import 'dart:convert';

// import 'package:flutter/foundation.dart';

// class Config {
//   final String name;
//   final List<String> args;

//   Config({
//     required this.name,
//     required this.args,
//   });

//   Config copyWith({
//     String? name,
//     List<String>? args,
//   }) {
//     return Config(
//       name: name ?? this.name,
//       args: args ?? this.args,
//     );
//   }

//   Map<String, dynamic> toMap() {
//     return {
//       'name': name,
//       'args': args,
//     };
//   }

//   factory Config.fromMap(Map<String, dynamic> map) {
//     return Config(
//       name: map['name'] ?? '',
//       args: List<String>.from(map['args']),
//     );
//   }

//   String toJson() => json.encode(toMap());

//   factory Config.fromJson(String source) => Config.fromMap(json.decode(source));

//   @override
//   String toString() => 'Config(name: $name, args: $args)';

//   @override
//   bool operator ==(Object other) {
//     if (identical(this, other)) return true;

//     return other is Config &&
//         other.name == name &&
//         listEquals(other.args, args);
//   }

//   @override
//   int get hashCode => name.hashCode ^ args.hashCode;
// }
