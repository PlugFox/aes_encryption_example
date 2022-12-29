// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target

part of 'encryption_state.codegen.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#custom-getters-and-methods');

/// @nodoc
mixin _$EncryptionState {
  EncryptionProgress get progress => throw _privateConstructorUsedError;
  String get message => throw _privateConstructorUsedError;

  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(IdleEncryptionState value) idle,
    required TResult Function(ProcessingEncryptionState value) processing,
    required TResult Function(SuccessfulEncryptionState value) successful,
    required TResult Function(ErrorEncryptionState value) error,
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(IdleEncryptionState value)? idle,
    TResult? Function(ProcessingEncryptionState value)? processing,
    TResult? Function(SuccessfulEncryptionState value)? successful,
    TResult? Function(ErrorEncryptionState value)? error,
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(IdleEncryptionState value)? idle,
    TResult Function(ProcessingEncryptionState value)? processing,
    TResult Function(SuccessfulEncryptionState value)? successful,
    TResult Function(ErrorEncryptionState value)? error,
    required TResult orElse(),
  }) =>
      throw _privateConstructorUsedError;

  @JsonKey(ignore: true)
  $EncryptionStateCopyWith<EncryptionState> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $EncryptionStateCopyWith<$Res> {
  factory $EncryptionStateCopyWith(
          EncryptionState value, $Res Function(EncryptionState) then) =
      _$EncryptionStateCopyWithImpl<$Res, EncryptionState>;
  @useResult
  $Res call({EncryptionProgress progress, String message});
}

/// @nodoc
class _$EncryptionStateCopyWithImpl<$Res, $Val extends EncryptionState>
    implements $EncryptionStateCopyWith<$Res> {
  _$EncryptionStateCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? progress = null,
    Object? message = null,
  }) {
    return _then(_value.copyWith(
      progress: null == progress
          ? _value.progress
          : progress // ignore: cast_nullable_to_non_nullable
              as EncryptionProgress,
      message: null == message
          ? _value.message
          : message // ignore: cast_nullable_to_non_nullable
              as String,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$IdleEncryptionStateCopyWith<$Res>
    implements $EncryptionStateCopyWith<$Res> {
  factory _$$IdleEncryptionStateCopyWith(_$IdleEncryptionState value,
          $Res Function(_$IdleEncryptionState) then) =
      __$$IdleEncryptionStateCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({EncryptionProgress progress, String message});
}

/// @nodoc
class __$$IdleEncryptionStateCopyWithImpl<$Res>
    extends _$EncryptionStateCopyWithImpl<$Res, _$IdleEncryptionState>
    implements _$$IdleEncryptionStateCopyWith<$Res> {
  __$$IdleEncryptionStateCopyWithImpl(
      _$IdleEncryptionState _value, $Res Function(_$IdleEncryptionState) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? progress = null,
    Object? message = null,
  }) {
    return _then(_$IdleEncryptionState(
      progress: null == progress
          ? _value.progress
          : progress // ignore: cast_nullable_to_non_nullable
              as EncryptionProgress,
      message: null == message
          ? _value.message
          : message // ignore: cast_nullable_to_non_nullable
              as String,
    ));
  }
}

/// @nodoc

class _$IdleEncryptionState extends IdleEncryptionState {
  const _$IdleEncryptionState(
      {this.progress = const EncryptionProgress(1, 'Idle'),
      this.message = 'Idle'})
      : super._();

  @override
  @JsonKey()
  final EncryptionProgress progress;
  @override
  @JsonKey()
  final String message;

  @override
  String toString() {
    return 'EncryptionState.idle(progress: $progress, message: $message)';
  }

  @override
  bool operator ==(dynamic other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$IdleEncryptionState &&
            (identical(other.progress, progress) ||
                other.progress == progress) &&
            (identical(other.message, message) || other.message == message));
  }

  @override
  int get hashCode => Object.hash(runtimeType, progress, message);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$IdleEncryptionStateCopyWith<_$IdleEncryptionState> get copyWith =>
      __$$IdleEncryptionStateCopyWithImpl<_$IdleEncryptionState>(
          this, _$identity);

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(IdleEncryptionState value) idle,
    required TResult Function(ProcessingEncryptionState value) processing,
    required TResult Function(SuccessfulEncryptionState value) successful,
    required TResult Function(ErrorEncryptionState value) error,
  }) {
    return idle(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(IdleEncryptionState value)? idle,
    TResult? Function(ProcessingEncryptionState value)? processing,
    TResult? Function(SuccessfulEncryptionState value)? successful,
    TResult? Function(ErrorEncryptionState value)? error,
  }) {
    return idle?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(IdleEncryptionState value)? idle,
    TResult Function(ProcessingEncryptionState value)? processing,
    TResult Function(SuccessfulEncryptionState value)? successful,
    TResult Function(ErrorEncryptionState value)? error,
    required TResult orElse(),
  }) {
    if (idle != null) {
      return idle(this);
    }
    return orElse();
  }
}

abstract class IdleEncryptionState extends EncryptionState {
  const factory IdleEncryptionState(
      {final EncryptionProgress progress,
      final String message}) = _$IdleEncryptionState;
  const IdleEncryptionState._() : super._();

  @override
  EncryptionProgress get progress;
  @override
  String get message;
  @override
  @JsonKey(ignore: true)
  _$$IdleEncryptionStateCopyWith<_$IdleEncryptionState> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class _$$ProcessingEncryptionStateCopyWith<$Res>
    implements $EncryptionStateCopyWith<$Res> {
  factory _$$ProcessingEncryptionStateCopyWith(
          _$ProcessingEncryptionState value,
          $Res Function(_$ProcessingEncryptionState) then) =
      __$$ProcessingEncryptionStateCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({EncryptionProgress progress, String message});
}

/// @nodoc
class __$$ProcessingEncryptionStateCopyWithImpl<$Res>
    extends _$EncryptionStateCopyWithImpl<$Res, _$ProcessingEncryptionState>
    implements _$$ProcessingEncryptionStateCopyWith<$Res> {
  __$$ProcessingEncryptionStateCopyWithImpl(_$ProcessingEncryptionState _value,
      $Res Function(_$ProcessingEncryptionState) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? progress = null,
    Object? message = null,
  }) {
    return _then(_$ProcessingEncryptionState(
      progress: null == progress
          ? _value.progress
          : progress // ignore: cast_nullable_to_non_nullable
              as EncryptionProgress,
      message: null == message
          ? _value.message
          : message // ignore: cast_nullable_to_non_nullable
              as String,
    ));
  }
}

/// @nodoc

class _$ProcessingEncryptionState extends ProcessingEncryptionState {
  const _$ProcessingEncryptionState(
      {required this.progress, this.message = 'Processing'})
      : super._();

  @override
  final EncryptionProgress progress;
  @override
  @JsonKey()
  final String message;

  @override
  String toString() {
    return 'EncryptionState.processing(progress: $progress, message: $message)';
  }

  @override
  bool operator ==(dynamic other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$ProcessingEncryptionState &&
            (identical(other.progress, progress) ||
                other.progress == progress) &&
            (identical(other.message, message) || other.message == message));
  }

  @override
  int get hashCode => Object.hash(runtimeType, progress, message);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$ProcessingEncryptionStateCopyWith<_$ProcessingEncryptionState>
      get copyWith => __$$ProcessingEncryptionStateCopyWithImpl<
          _$ProcessingEncryptionState>(this, _$identity);

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(IdleEncryptionState value) idle,
    required TResult Function(ProcessingEncryptionState value) processing,
    required TResult Function(SuccessfulEncryptionState value) successful,
    required TResult Function(ErrorEncryptionState value) error,
  }) {
    return processing(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(IdleEncryptionState value)? idle,
    TResult? Function(ProcessingEncryptionState value)? processing,
    TResult? Function(SuccessfulEncryptionState value)? successful,
    TResult? Function(ErrorEncryptionState value)? error,
  }) {
    return processing?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(IdleEncryptionState value)? idle,
    TResult Function(ProcessingEncryptionState value)? processing,
    TResult Function(SuccessfulEncryptionState value)? successful,
    TResult Function(ErrorEncryptionState value)? error,
    required TResult orElse(),
  }) {
    if (processing != null) {
      return processing(this);
    }
    return orElse();
  }
}

abstract class ProcessingEncryptionState extends EncryptionState {
  const factory ProcessingEncryptionState(
      {required final EncryptionProgress progress,
      final String message}) = _$ProcessingEncryptionState;
  const ProcessingEncryptionState._() : super._();

  @override
  EncryptionProgress get progress;
  @override
  String get message;
  @override
  @JsonKey(ignore: true)
  _$$ProcessingEncryptionStateCopyWith<_$ProcessingEncryptionState>
      get copyWith => throw _privateConstructorUsedError;
}

/// @nodoc
abstract class _$$SuccessfulEncryptionStateCopyWith<$Res>
    implements $EncryptionStateCopyWith<$Res> {
  factory _$$SuccessfulEncryptionStateCopyWith(
          _$SuccessfulEncryptionState value,
          $Res Function(_$SuccessfulEncryptionState) then) =
      __$$SuccessfulEncryptionStateCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({EncryptionProgress progress, String message});
}

/// @nodoc
class __$$SuccessfulEncryptionStateCopyWithImpl<$Res>
    extends _$EncryptionStateCopyWithImpl<$Res, _$SuccessfulEncryptionState>
    implements _$$SuccessfulEncryptionStateCopyWith<$Res> {
  __$$SuccessfulEncryptionStateCopyWithImpl(_$SuccessfulEncryptionState _value,
      $Res Function(_$SuccessfulEncryptionState) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? progress = null,
    Object? message = null,
  }) {
    return _then(_$SuccessfulEncryptionState(
      progress: null == progress
          ? _value.progress
          : progress // ignore: cast_nullable_to_non_nullable
              as EncryptionProgress,
      message: null == message
          ? _value.message
          : message // ignore: cast_nullable_to_non_nullable
              as String,
    ));
  }
}

/// @nodoc

class _$SuccessfulEncryptionState extends SuccessfulEncryptionState {
  const _$SuccessfulEncryptionState(
      {this.progress = const EncryptionProgress(1, 'Successful'),
      this.message = 'Successful'})
      : super._();

  @override
  @JsonKey()
  final EncryptionProgress progress;
  @override
  @JsonKey()
  final String message;

  @override
  String toString() {
    return 'EncryptionState.successful(progress: $progress, message: $message)';
  }

  @override
  bool operator ==(dynamic other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$SuccessfulEncryptionState &&
            (identical(other.progress, progress) ||
                other.progress == progress) &&
            (identical(other.message, message) || other.message == message));
  }

  @override
  int get hashCode => Object.hash(runtimeType, progress, message);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$SuccessfulEncryptionStateCopyWith<_$SuccessfulEncryptionState>
      get copyWith => __$$SuccessfulEncryptionStateCopyWithImpl<
          _$SuccessfulEncryptionState>(this, _$identity);

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(IdleEncryptionState value) idle,
    required TResult Function(ProcessingEncryptionState value) processing,
    required TResult Function(SuccessfulEncryptionState value) successful,
    required TResult Function(ErrorEncryptionState value) error,
  }) {
    return successful(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(IdleEncryptionState value)? idle,
    TResult? Function(ProcessingEncryptionState value)? processing,
    TResult? Function(SuccessfulEncryptionState value)? successful,
    TResult? Function(ErrorEncryptionState value)? error,
  }) {
    return successful?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(IdleEncryptionState value)? idle,
    TResult Function(ProcessingEncryptionState value)? processing,
    TResult Function(SuccessfulEncryptionState value)? successful,
    TResult Function(ErrorEncryptionState value)? error,
    required TResult orElse(),
  }) {
    if (successful != null) {
      return successful(this);
    }
    return orElse();
  }
}

abstract class SuccessfulEncryptionState extends EncryptionState {
  const factory SuccessfulEncryptionState(
      {final EncryptionProgress progress,
      final String message}) = _$SuccessfulEncryptionState;
  const SuccessfulEncryptionState._() : super._();

  @override
  EncryptionProgress get progress;
  @override
  String get message;
  @override
  @JsonKey(ignore: true)
  _$$SuccessfulEncryptionStateCopyWith<_$SuccessfulEncryptionState>
      get copyWith => throw _privateConstructorUsedError;
}

/// @nodoc
abstract class _$$ErrorEncryptionStateCopyWith<$Res>
    implements $EncryptionStateCopyWith<$Res> {
  factory _$$ErrorEncryptionStateCopyWith(_$ErrorEncryptionState value,
          $Res Function(_$ErrorEncryptionState) then) =
      __$$ErrorEncryptionStateCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({EncryptionProgress progress, String message});
}

/// @nodoc
class __$$ErrorEncryptionStateCopyWithImpl<$Res>
    extends _$EncryptionStateCopyWithImpl<$Res, _$ErrorEncryptionState>
    implements _$$ErrorEncryptionStateCopyWith<$Res> {
  __$$ErrorEncryptionStateCopyWithImpl(_$ErrorEncryptionState _value,
      $Res Function(_$ErrorEncryptionState) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? progress = null,
    Object? message = null,
  }) {
    return _then(_$ErrorEncryptionState(
      progress: null == progress
          ? _value.progress
          : progress // ignore: cast_nullable_to_non_nullable
              as EncryptionProgress,
      message: null == message
          ? _value.message
          : message // ignore: cast_nullable_to_non_nullable
              as String,
    ));
  }
}

/// @nodoc

class _$ErrorEncryptionState extends ErrorEncryptionState {
  const _$ErrorEncryptionState(
      {this.progress = const EncryptionProgress(0, 'An error has occurred'),
      this.message = 'An error has occurred'})
      : super._();

  @override
  @JsonKey()
  final EncryptionProgress progress;
  @override
  @JsonKey()
  final String message;

  @override
  String toString() {
    return 'EncryptionState.error(progress: $progress, message: $message)';
  }

  @override
  bool operator ==(dynamic other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$ErrorEncryptionState &&
            (identical(other.progress, progress) ||
                other.progress == progress) &&
            (identical(other.message, message) || other.message == message));
  }

  @override
  int get hashCode => Object.hash(runtimeType, progress, message);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$ErrorEncryptionStateCopyWith<_$ErrorEncryptionState> get copyWith =>
      __$$ErrorEncryptionStateCopyWithImpl<_$ErrorEncryptionState>(
          this, _$identity);

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(IdleEncryptionState value) idle,
    required TResult Function(ProcessingEncryptionState value) processing,
    required TResult Function(SuccessfulEncryptionState value) successful,
    required TResult Function(ErrorEncryptionState value) error,
  }) {
    return error(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(IdleEncryptionState value)? idle,
    TResult? Function(ProcessingEncryptionState value)? processing,
    TResult? Function(SuccessfulEncryptionState value)? successful,
    TResult? Function(ErrorEncryptionState value)? error,
  }) {
    return error?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(IdleEncryptionState value)? idle,
    TResult Function(ProcessingEncryptionState value)? processing,
    TResult Function(SuccessfulEncryptionState value)? successful,
    TResult Function(ErrorEncryptionState value)? error,
    required TResult orElse(),
  }) {
    if (error != null) {
      return error(this);
    }
    return orElse();
  }
}

abstract class ErrorEncryptionState extends EncryptionState {
  const factory ErrorEncryptionState(
      {final EncryptionProgress progress,
      final String message}) = _$ErrorEncryptionState;
  const ErrorEncryptionState._() : super._();

  @override
  EncryptionProgress get progress;
  @override
  String get message;
  @override
  @JsonKey(ignore: true)
  _$$ErrorEncryptionStateCopyWith<_$ErrorEncryptionState> get copyWith =>
      throw _privateConstructorUsedError;
}
