import 'package:freezed_annotation/freezed_annotation.dart';

import '../model/encryption_progress.dart';

part 'encryption_state.codegen.freezed.dart';

@freezed
class EncryptionState with _$EncryptionState {
  const EncryptionState._();

  /// Idling state
  const factory EncryptionState.idle({
    @Default(EncryptionProgress(1, 'Idle')) final EncryptionProgress progress,
    @Default('Idle') final String message,
  }) = IdleEncryptionState;

  /// Processing
  const factory EncryptionState.processing({
    required final EncryptionProgress progress,
    @Default('Processing') final String message,
  }) = ProcessingEncryptionState;

  /// Successful
  const factory EncryptionState.successful({
    @Default(EncryptionProgress(1, 'Successful')) final EncryptionProgress progress,
    @Default('Successful') final String message,
  }) = SuccessfulEncryptionState;

  /// An error has occurred
  const factory EncryptionState.error({
    @Default(EncryptionProgress(0, 'An error has occurred')) final EncryptionProgress progress,
    @Default('An error has occurred') final String message,
  }) = ErrorEncryptionState;

  /// Has data
  //bool get hasData => data != null;

  /// If an error has occurred
  bool get hasError => maybeMap<bool>(orElse: () => false, error: (_) => true);

  /// Is in idle state
  bool get isIdling => !isProcessing;

  /// Is in progress state
  bool get isProcessing => maybeMap<bool>(orElse: () => false, processing: (_) => true);
}
