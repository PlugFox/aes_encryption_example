// ignore_for_file: one_member_abstracts
import 'dart:async';
import 'dart:io' as io;

import 'package:file_picker/file_picker.dart' as file_picker;
import 'package:flutter_file_dialog/flutter_file_dialog.dart' as file_dialog;
import 'package:path/path.dart' as path;

import '../model/encryption_progress.dart';
import '../model/exceptions.dart';
import 'encryption_algorithm.dart';

abstract class IEncryptionRepository {
  /// Pick a existed file from the file system
  /// Throws [FilePickerException] if no file was selected
  Future<io.File> pickFile();

  /// Save the [file] to the file system with dialog
  /// Throws [FilePickerException] if no file was selected
  Future<void> saveFile(io.File file);

  /// This function encrypts the [source] file using the [algorithm] (e.g. AES Galois/Counter Mode (GCM))
  /// and returns a stream of [EncryptionProgress] objects,
  /// which provide information about the progress of the encryption process.
  /// The [EncryptionProgress] object has two fields: `value` (a double between 0 and 1) and `message` (a string).
  ///
  /// ## Parameters
  /// - [source]    : an [io.File] object representing the file to be encrypted.
  /// - [key]       : a string that is used as the secret key for the encryption process.
  ///                 The key must be 128, 192, or 256 bits long.
  /// - [algorithm] : an [EncryptionAlgorithm] object that represents the encryption algorithm to be used.
  /// - [out]       : an optional callback function that takes an [io.File] object as its parameter.
  ///                 This function is called with the encrypted file as its parameter
  ///                 when the encryption process is complete.
  ///
  /// ## Return value
  /// A stream of [EncryptionProgress] objects that provide information about the progress of the encryption process.
  Stream<EncryptionProgress> encrypt(
    io.File source,
    String key,
    EncryptionAlgorithm algorithm, {
    Future<void> Function(io.File encrypted)? out,
  });
}

// TODO: split by data providers
// Matiunin Mikhail <plugfox@gmail.com>, 30 December 2022
class EncryptionRepositoryImpl implements IEncryptionRepository {
  @override
  Future<io.File> pickFile() async {
    await file_picker.FilePicker.platform.clearTemporaryFiles();
    final result = await file_picker.FilePicker.platform.pickFiles();
    final path = result?.paths.single;
    if (path == null) throw const FilePickerException('No file selected');
    return io.File(path);
  }

  @override
  Future<void> saveFile(io.File file) async {
    final params = file_dialog.SaveFileDialogParams(fileName: path.basename(file.path), sourceFilePath: file.path);
    final result = await file_dialog.FlutterFileDialog.saveFile(params: params);
    if (result == null) throw const FilePickerException('File not saved');
  }

  @override
  Stream<EncryptionProgress> encrypt(
    io.File source,
    String key,
    EncryptionAlgorithm algorithm, {
    Future<void> Function(io.File encrypted)? out,
  }) =>
      EncryptionAlgorithm.encrypt(source, key, algorithm, out: out);
}
