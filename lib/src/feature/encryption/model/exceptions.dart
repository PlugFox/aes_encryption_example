import 'package:meta/meta.dart';

@immutable
class EncryptionException implements Exception {
  const EncryptionException([this.message = 'Encryption error']);

  final String message;

  @override
  String toString() => message;
}

@immutable
class FilePickerException implements Exception {
  const FilePickerException(this.message);

  final String message;

  @override
  String toString() => message;
}
