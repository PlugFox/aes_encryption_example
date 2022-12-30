import '../../../common/data/controller.dart';
import '../../../common/util/error_util.dart';
import '../../../common/util/logging.dart';
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

  Future<void> encrypt(String key, EncryptionAlgorithm algorithm) => handle((setState) async {
        try {
          setState(const EncryptionState.processing(progress: EncryptionProgress(0)));
          final source = await _repository.pickFile();
          final stream = _repository.encrypt(source, key, algorithm, out: _repository.saveFile);
          await for (final progress in stream) {
            config(' * ${progress.percent.toString().padLeft(3, ' ')}% | ${progress.message}');
            setState(EncryptionState.processing(progress: progress));
          }
          setState(EncryptionState.successful(message: state.progress.message, progress: state.progress));
        } on Object catch (error) {
          setState(EncryptionState.error(message: ErrorUtil.formatMessage(error)));
          rethrow;
        } finally {
          setState(const EncryptionState.idle());
        }
      });
}
