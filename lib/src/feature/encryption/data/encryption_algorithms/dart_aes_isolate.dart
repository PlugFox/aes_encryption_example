import 'dart:async';
import 'dart:io' as io;
import 'dart:isolate';
import 'dart:typed_data' as td;

import 'package:cryptography/cryptography.dart' as cryptography;
import 'package:intl/intl.dart' as intl;
import 'package:meta/meta.dart';
import 'package:path/path.dart' as path;
import 'package:path_provider/path_provider.dart' as path_provider;

import '../../../../common/util/chunker.dart';
import '../../model/encryption_progress.dart';

// --- Constants --- //

/// Buffer size in bytes.
const int _$buffer = 1024 * 1024; // 1 MB

/// Initialization vector (iv, salt, nonce) length in bytes.
const int _$nonceLength = 16;

/// Message authentication code (mac, tag, etc) length in bytes.
const int _$macLength = 16;

// --- File encryption alghorithm --- //

Stream<EncryptionProgress> $dartAesIsolate(
  io.File sourceFile,
  String key, {
  Future<void> Function(io.File encrypted)? out,
}) {
  final stopwatch = Stopwatch()..start();
  final controller = StreamController<EncryptionProgress>();
  Isolate? isolate;
  ReceivePort? receivePort;
  void progress(double value, [String message = 'Encryption in progress']) =>
      controller.add(EncryptionProgress(value, message));
  Future<void>(() async {
    try {
      progress(0, 'Preparing to encrypt file "${path.basename(sourceFile.path)}"');

      assert([128, 192, 256].contains(key.length * 8), 'Key length must be 128, 192, or 256 bits');
      assert(128 == _$nonceLength * 8, 'Nonce length should be 128 bits');
      assert(128 == _$macLength * 8, 'MAC length must be 128 bits');
      assert(sourceFile.existsSync(), 'File does not exist');

      progress(.02, 'Preparing files');

      // --- Prepare files --- //
      final tempDir = await path_provider.getTemporaryDirectory();
      final tempFile = io.File(path.join(tempDir.path, path.basename('${sourceFile.path}.tmp')));
      final encryptedFile = io.File(path.join(tempDir.path, path.basename('${sourceFile.path}.enc')));
      await Future.wait<void>(<Future<void>>[
        if (tempFile.existsSync()) tempFile.delete(),
        if (encryptedFile.existsSync()) encryptedFile.delete(),
      ]);

      progress(.03, 'Spawning isolate');
      final completer = Completer<void>();
      receivePort = ReceivePort()
        ..listen((Object? message) {
          if (message is EncryptionProgress) {
            if (message.value == 1) {
              completer.complete();
              return;
            }
            controller.add(message);
          } else if (message is _IsolateError) {
            controller.addError(message.error, message.stackTrace);
          } else {
            completer.completeError(
              UnsupportedError('Unknown message type: ${message.runtimeType}'),
              StackTrace.current,
            );
          }
        });
      isolate = await Isolate.spawn(
        _$isolateEntryPoint,
        _IsolateArg(
          sendPort: receivePort!.sendPort,
          sourceFile: sourceFile,
          tempFile: tempFile,
          encryptedFile: encryptedFile,
          key: key,
        ),
      );
      await completer.future;

      if (await encryptedFile.length() < await sourceFile.length()) {
        throw StateError('Encrypted file size is smaller than source file size');
      }

      progress(
        1,
        'Successfully encrypted "${path.basename(encryptedFile.path)}" in ${stopwatch.elapsedMilliseconds} ms',
      );
      out?.call(encryptedFile).ignore();
    } on Object catch (error, stackTrace) {
      controller.addError(error, stackTrace);
    } finally {
      controller.close().ignore();
      isolate?.kill();
      stopwatch.stop();
    }
  });
  return controller.stream;
}

@immutable
class _IsolateArg {
  const _IsolateArg({
    required this.sendPort,
    required this.sourceFile,
    required this.tempFile,
    required this.encryptedFile,
    required this.key,
  });

  final SendPort sendPort;
  final io.File sourceFile;
  final io.File tempFile;
  final io.File encryptedFile;
  final String key;
}

@immutable
class _IsolateError {
  factory _IsolateError(Object error, StackTrace stackTrace) {
    if (error is _IsolateError) return error;
    return _IsolateError._(Error.safeToString(error), stackTrace.toString());
  }
  const _IsolateError._(this.error, this._stackTraceString);

  final Object error;
  final String _stackTraceString;
  StackTrace get stackTrace => StackTrace.fromString(_stackTraceString);
}

Future<void> _$isolateEntryPoint(_IsolateArg arg) async {
  void progress(double value, [String message = 'Encryption in progress']) =>
      arg.sendPort.send(EncryptionProgress(value, message));
  final sourceFile = arg.sourceFile;
  final tempFile = arg.tempFile;
  final encryptedFile = arg.encryptedFile;
  final key = arg.key;

  try {
    // --- Init algorithm & secret key --- //

    progress(.05, 'Initializing AES Galois/Counter Mode algorithm and secret key');
    final algorithm = cryptography.AesGcm.with128bits(nonceLength: _$nonceLength);
    final secretKey = await algorithm.newSecretKeyFromBytes(key.codeUnits);
    final totalBytes = await sourceFile.length();
    final format = intl.NumberFormat.compact();

    // --- Write to temp file --- //

    progress(.1, 'Writing to temporary file');
    final sink = tempFile.openWrite(mode: io.FileMode.writeOnly);

    var encryptedBytes = .0;
    double evalEncryptionProgress() => .1 + (encryptedBytes / (totalBytes * 1.2));
    await sourceFile
        .openRead()
        .chunker(_$buffer)
        .map<td.Uint8List>((bytes) {
          encryptedBytes += bytes.length;
          progress(
            evalEncryptionProgress(),
            'Encrypting ${format.format(encryptedBytes)} out of ${format.format(totalBytes)} bytes',
          );
          return bytes;
        })
        .asyncMap<cryptography.SecretBox>(
          (bytes) async => algorithm.encrypt(
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

    progress(.9, 'Flushing and closing temporary file');

    await sink.flush();
    await sink.close();

    // --- Move temp file to encrypted file --- //

    progress(.95, 'Moving temporary file to encrypted file');

    await tempFile.rename(encryptedFile.path);

    progress(1, 'Successfully encrypted "${path.basename(encryptedFile.path)}"');
    // --- Done --- //
  } on Object catch (error, stackTrace) {
    arg.sendPort.send(_IsolateError(error, stackTrace));
  } finally {
    //Isolate.current.kill();
  }
}
