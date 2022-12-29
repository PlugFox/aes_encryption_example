enum EncryptionAlgorithm {
  aesSync('Synchronous AES encryption', 'Affects the event loop', _$algorithm),
  aesAsync('Asynchronous AES encryption', 'Does not affect the event loop', _$algorithm),
  aesIsolate('Isolated AES encryption', 'Performed in a separate isolator', _$algorithm);

  const EncryptionAlgorithm(this.name, this.description, this._encrypt);

  static Future<void> encrypt(EncryptionAlgorithm algorithm) => algorithm._encrypt();

  final String name;
  final String description;

  final Future<void> Function() _encrypt;
}

Future<void> _$algorithm() async {}
