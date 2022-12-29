import 'encryption_algorithms/aes.dart';

enum EncryptionAlgorithm {
  aesSync('Synchronous AES encryption', 'Affects the event loop', $EncryptionAlgorithmAES.sync),
  aesAsync('Asynchronous AES encryption', 'Does not affect the event loop', $EncryptionAlgorithmAES.async),
  aesIsolate('Isolated AES encryption', 'Performed in a separate isolator', $EncryptionAlgorithmAES.isolate);

  const EncryptionAlgorithm(this.name, this.description, this._encrypt);

  static Future<void> encrypt(EncryptionAlgorithm algorithm) => algorithm._encrypt();

  final String name;
  final String description;

  final Future<void> Function() _encrypt;
}
