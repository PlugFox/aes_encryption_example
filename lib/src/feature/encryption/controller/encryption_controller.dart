import '../../../common/data/controller.dart';
import '../../../common/util/error_util.dart';
import '../data/encryption_algorithm.dart';
import '../data/encryption_repository.dart';
import '../model/encryption_progress.dart';
import 'encryption_state.codegen.dart';

/// {@template encryption_controller}
/// EncryptionController class
/// {@endtemplate}
class EncryptionController extends Controller<EncryptionState> {
  /// {@macro encryption_controller}
  EncryptionController({required IEncryptionRepository repository})
      : _repository = repository,
        super(const EncryptionState.idle());

  final IEncryptionRepository _repository;

  Future<void> encrypt(EncryptionAlgorithm algorithm) => handle((setState) async {
        try {
          setState(const EncryptionState.processing(progress: EncryptionProgress(0)));
          await for (final progress in _repository.encrypt(algorithm)) {
            setState(EncryptionState.processing(progress: progress));
          }
          setState(const EncryptionState.successful());
        } on Object catch (error) {
          setState(EncryptionState.error(message: ErrorUtil.formatMessage(error)));
          rethrow;
        } finally {
          setState(const EncryptionState.idle());
        }
      });
}
