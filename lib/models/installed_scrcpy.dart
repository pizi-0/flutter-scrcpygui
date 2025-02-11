// ignore_for_file: public_member_api_docs, sort_constructors_first
class InstalledScrcpy {
  final String version;
  final String path;

  InstalledScrcpy({required this.version, required this.path});

  @override
  bool operator ==(covariant InstalledScrcpy other) {
    if (identical(this, other)) return true;

    return other.version == version && other.path == path;
  }

  @override
  int get hashCode => version.hashCode ^ path.hashCode;
}
