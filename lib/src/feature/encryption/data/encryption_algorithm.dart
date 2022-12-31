import 'dart:io' as io;

import '../model/encryption_progress.dart';
import 'encryption_algorithms/dart_aes_async.dart';
import 'encryption_algorithms/dart_aes_isolate.dart';
import 'encryption_algorithms/flutter_aes_async.dart';

enum EncryptionAlgorithm {
  dartAesAsync(
    'Dart Asynchronous AES',
    'Does not affect the event loop',
    $dartAesAsync,
  ),

  dartAesIsolate(
    'Dart Isolated AES',
    'Performed in a separate isolator',
    $dartAesIsolate,
  ),

  nativeAesAsync(
    'Flutter Asynchronous AES',
    'Does not affect the event loop',
    $flutterAesAsync,
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
