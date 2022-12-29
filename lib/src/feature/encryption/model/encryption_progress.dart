import 'package:meta/meta.dart';

@sealed
@immutable
class EncryptionProgress with Comparable<EncryptionProgress> {
  const EncryptionProgress(this.value, [this.message = 'Encryption in progress']);

  final double value;
  final String message;
  int get percent => (value * 100).clamp(0, 100).truncate();

  @override
  int compareTo(covariant EncryptionProgress other) => value.compareTo(other.value);

  @override
  int get hashCode => value.hashCode;

  @override
  bool operator ==(Object other) => identical(this, other) || (other is EncryptionProgress && value == other.value);

  @override
  String toString() => '$percent%';
}
