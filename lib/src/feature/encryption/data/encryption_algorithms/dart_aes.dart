import 'dart:async';
import 'dart:io' as io;
import 'dart:typed_data' as td;

import 'package:cryptography/cryptography.dart' as cryptography;
import 'package:intl/intl.dart' as intl;
import 'package:meta/meta.dart';
import 'package:path/path.dart' as path;
import 'package:path_provider/path_provider.dart' as path_provider;

import '../../../../common/util/chunker.dart';
import '../../model/encryption_progress.dart';

@sealed
abstract class $EncryptionAlgorithmDartAES {
  const $EncryptionAlgorithmDartAES._();

  static Stream<EncryptionProgress> async(io.File source, String key,
          {Future<void> Function(io.File encrypted)? out}) =>
      _encryptFile(source, key, out: out);

  static Stream<EncryptionProgress> isolate(
    io.File source,
    String key, {
    Future<void> Function(io.File encrypted)? out,
  }) =>
      Stream<EncryptionProgress>.error(UnimplementedError());
}

// --- Constants --- //

/// Buffer size in bytes.
const int _$buffer = 1024 * 1024; // 1 MB

/// Initialization vector (iv, salt, nonce) length in bytes.
const int _$nonceLength = 16;

/// Message authentication code (mac, tag, etc) length in bytes.
const int _$macLength = 16;

// --- File encryption alghorithm --- //

Stream<EncryptionProgress> _encryptFile(
  io.File sourceFile,
  String key, {
  Future<void> Function(io.File encrypted)? out,
}) {
  final stopwatch = Stopwatch()..start();
  final controller = StreamController<EncryptionProgress>();
  Future<void>(() async {
    try {
      controller.add(EncryptionProgress(0, 'Preparing to encrypt file "${path.basename(sourceFile.path)}"'));

      assert([128, 192, 256].contains(key.length * 8), 'Key length must be 128, 192, or 256 bits');
      assert(128 == _$nonceLength * 8, 'Nonce length should be 128 bits');
      assert(128 == _$macLength * 8, 'MAC length must be 128 bits');
      assert(sourceFile.existsSync(), 'File does not exist');
      final totalBytes = await sourceFile.length();
      final format = intl.NumberFormat.compact();

      controller.add(const EncryptionProgress(.025, 'Preparing files'));

      // --- Prepare files --- //
      final tempDir = await path_provider.getTemporaryDirectory();

      final tempFile = io.File(path.join(tempDir.path, path.basename('${sourceFile.path}.tmp')));
      final encryptedFile = io.File(path.join(tempDir.path, path.basename('${sourceFile.path}.enc')));
      await Future.wait<void>(<Future<void>>[
        if (tempFile.existsSync()) tempFile.delete(),
        if (encryptedFile.existsSync()) encryptedFile.delete(),
      ]);

      // --- Init algorithm & secret key --- //

      controller.add(const EncryptionProgress(.05, 'Initializing AES Galois/Counter Mode algorithm and secret key'));
      final algorithm = cryptography.AesGcm.with128bits(nonceLength: _$nonceLength);
      final secretKey = await algorithm.newSecretKeyFromBytes(key.codeUnits);

      // --- Write to temp file --- //

      controller.add(const EncryptionProgress(.1, 'Writing to temporary file'));
      final sink = tempFile.openWrite(mode: io.FileMode.writeOnly);

      var encryptedBytes = .0;
      double evalEncryptionProgress() => .1 + (encryptedBytes / (totalBytes * 1.2));
      await sourceFile
          .openRead()
          .chunker(_$buffer)
          .map<td.Uint8List>((bytes) {
            encryptedBytes += bytes.length;
            controller.add(
              EncryptionProgress(
                evalEncryptionProgress(),
                'Encrypting ${format.format(encryptedBytes)} out of ${format.format(totalBytes)} bytes',
              ),
            );
            return bytes;
          })
          .asyncMap<cryptography.SecretBox>(
            (bytes) => algorithm.encrypt(
              bytes,
              secretKey: secretKey,
              nonce: algorithm.newNonce(),
            ),
          )
          .expand<List<int>>((element) sync* {
            yield element.nonce;
            yield element.cipherText;
            yield element.mac.bytes;
          })
          .forEach(sink.add);

      // --- Flush & Close temp file --- //

      controller.add(const EncryptionProgress(.9, 'Flushing and closing temporary file'));

      await sink.flush();
      await sink.close();

      // --- Move temp file to encrypted file --- //

      controller.add(const EncryptionProgress(.95, 'Moving temporary file to encrypted file'));

      await tempFile.rename(encryptedFile.path);

      controller.add(
        EncryptionProgress(
          1,
          'Successfully encrypted "${path.basename(encryptedFile.path)}" in ${stopwatch.elapsedMilliseconds} ms',
        ),
      );

      out?.call(encryptedFile).ignore();
    } on Object catch (error, stackTrace) {
      controller.addError(error, stackTrace);
      stopwatch.stop();
    } finally {
      await controller.close();
    }
  });
  return controller.stream;
}