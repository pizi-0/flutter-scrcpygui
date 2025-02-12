import 'dart:convert';

// ignore_for_file: public_member_api_docs, sort_constructors_first
class ScrcpyApp {
  final String name;
  final String packageName;

  ScrcpyApp({required this.name, required this.packageName});

  @override
  bool operator ==(covariant ScrcpyApp other) {
    if (identical(this, other)) return true;

    return other.name == name && other.packageName == packageName;
  }

  @override
  int get hashCode => name.hashCode ^ packageName.hashCode;

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'name': name,
      'packageName': packageName,
    };
  }

  factory ScrcpyApp.fromMap(Map<String, dynamic> map) {
    return ScrcpyApp(
      name: map['name'] as String,
      packageName: map['packageName'] as String,
    );
  }

  String toJson() => json.encode(toMap());

  factory ScrcpyApp.fromJson(String source) =>
      ScrcpyApp.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() => 'ScrcpyApp(name: $name, packageName: $packageName)';
}
