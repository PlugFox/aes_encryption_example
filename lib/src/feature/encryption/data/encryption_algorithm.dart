import 'package:meta/meta.dart';

@immutable
abstract class EncryptionAlgorithm {
  const EncryptionAlgorithm();

  static const EncryptionAlgorithm aesSync = EncryptionAlgorithmAESSync();
  static const EncryptionAlgorithm aesAsync = EncryptionAlgorithmAESAsync();
  static const EncryptionAlgorithm aesIsolate = EncryptionAlgorithmAESIsolate();

  static const List<EncryptionAlgorithm> values = <EncryptionAlgorithm>[
    aesSync,
    aesAsync,
    aesIsolate,
  ];

  abstract final String name;
  abstract final String description;

  static Future<void> encrypt(EncryptionAlgorithm algorithm) => algorithm._encrypt();

  Future<void> _encrypt();

  @override
  String toString() => name;
}

@sealed
class EncryptionAlgorithmAESSync extends EncryptionAlgorithm {
  const EncryptionAlgorithmAESSync();

  @override
  String get name => 'Synchronous AES encryption';

  @override
  String get description => 'Affects the event loop';

  @override
  Future<void> _encrypt() async {}
}

@sealed
class EncryptionAlgorithmAESAsync extends EncryptionAlgorithm {
  const EncryptionAlgorithmAESAsync();

  @override
  String get name => 'Asynchronous AES encryption';

  @override
  String get description => 'Does not affect the event loop';

  @override
  Future<void> _encrypt() => const EncryptionAlgorithmAESSync()._encrypt();
}

@sealed
class EncryptionAlgorithmAESIsolate extends EncryptionAlgorithm {
  const EncryptionAlgorithmAESIsolate();

  @override
  String get name => 'Isolated AES encryption';

  @override
  String get description => 'Performed in a separate isolator';

  @override
  Future<void> _encrypt() => const EncryptionAlgorithmAESSync()._encrypt();
}
