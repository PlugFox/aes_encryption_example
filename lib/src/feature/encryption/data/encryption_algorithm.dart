import 'package:meta/meta.dart';

@immutable
abstract class EncryptionAlgorithm {
  const EncryptionAlgorithm();

  abstract final String name;
  abstract final String description;

  static const EncryptionAlgorithm aesSync = EncryptionAlgorithmAESSync();
  static const EncryptionAlgorithm aesAsync = EncryptionAlgorithmAESAsync();
  static const EncryptionAlgorithm aesIsolate = EncryptionAlgorithmAESIsolate();

  static const List<EncryptionAlgorithm> values = <EncryptionAlgorithm>[
    aesSync,
    aesAsync,
    aesIsolate,
  ];

  @override
  String toString() => name;

  Future<void> _encrypt();
}

@sealed
abstract class Encryptor {
  const Encryptor._();

  static Future<void> encrypt(EncryptionAlgorithm algorithm) => algorithm._encrypt();
}

class EncryptionAlgorithmAESSync extends EncryptionAlgorithm {
  const EncryptionAlgorithmAESSync();

  @override
  String get name => 'Synchronous AES encryption';

  @override
  String get description => 'Affects the event loop';

  @override
  Future<void> _encrypt() async {}
}

class EncryptionAlgorithmAESAsync extends EncryptionAlgorithm {
  const EncryptionAlgorithmAESAsync();

  @override
  String get name => 'Asynchronous AES encryption';

  @override
  String get description => 'Does not affect the event loop';

  @override
  Future<void> _encrypt() => const EncryptionAlgorithmAESSync()._encrypt();
}

class EncryptionAlgorithmAESIsolate extends EncryptionAlgorithm {
  const EncryptionAlgorithmAESIsolate();

  @override
  String get name => 'Isolated AES encryption';

  @override
  String get description => 'Performed in a separate isolator';

  @override
  Future<void> _encrypt() => const EncryptionAlgorithmAESSync()._encrypt();
}
