// ignore_for_file: public_member_api_docs, sort_constructors_first
class ProcessOutput {
  final String command;
  final String stdout;
  final String stderr;
  final int exitCode;

  ProcessOutput({
    required this.command,
    required this.stdout,
    required this.stderr,
    required this.exitCode,
  });

  @override
  String toString() {
    return 'ProcessOutput(command: $command, stdout: $stdout, stderr: $stderr, exitCode: $exitCode)';
  }
}
