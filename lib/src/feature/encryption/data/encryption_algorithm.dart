import 'dart:io' as io;

import '../model/encryption_progress.dart';
import 'encryption_algorithms/dart_aes.dart';
import 'encryption_algorithms/native_aes.dart';

enum EncryptionAlgorithm {
  dartAesAsync(
    'Dart Asynchronous AES',
    'Does not affect the event loop',
    $EncryptionAlgorithmDartAES.async,
  ),

  dartAesIsolate(
    'Dart Isolated AES',
    'Performed in a separate isolator',
    $EncryptionAlgorithmDartAES.isolate,
  ),

  nativeAesAsync(
    'Native Asynchronous AES',
    'Does not affect the event loop',
    $EncryptionAlgorithmNativeAES.async,
  );

  const EncryptionAlgorithm(this.name, this.description, this._encrypt);

  static Stream<EncryptionProgress> encrypt(
    io.File source,
    String key,
    EncryptionAlgorithm algorithm, {
    Future<void> Function(io.File encrypted)? out,
  }) =>
      algorithm._encrypt(source, key, out: out);

  final String name;
  final String description;

  final Stream<EncryptionProgress> Function(io.File source, String key, {Future<void> Function(io.File encrypted)? out})
      _encrypt;
}
