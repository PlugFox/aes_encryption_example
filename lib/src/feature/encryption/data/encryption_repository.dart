// ignore_for_file: one_member_abstracts

import '../model/encryption_progress.dart';
import 'encryption_algorithm.dart';

abstract class IEncryptionRepository {
  Stream<EncryptionProgress> encrypt(EncryptionAlgorithm algorithm);
}

class EncryptionRepositoryImpl implements IEncryptionRepository {
  @override
  Stream<EncryptionProgress> encrypt(EncryptionAlgorithm algorithm) async* {
    yield const EncryptionProgress(0);
    await Encryptor.encrypt(algorithm);

    for (var i = 0; i < 20; i++) {
      await Future<void>.delayed(const Duration(milliseconds: 250));
      yield EncryptionProgress((i + 1) / 20);
    }
    yield const EncryptionProgress(1);
  }
}
