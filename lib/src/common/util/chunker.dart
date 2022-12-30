import 'dart:async';
import 'dart:math' as math;
import 'dart:typed_data' as td;

import 'package:meta/meta.dart';

/// {@template chunker}
/// Chunker stream transformer
/// {@endtemplate}
@immutable
class Chunker extends StreamTransformerBase<List<int>, td.Uint8List> {
  /// {@macro chunker}
  const Chunker(this.chunkSize);

  /// Chunk size
  final int chunkSize;

  @override
  Stream<td.Uint8List> bind(Stream<List<int>> stream) {
    final controller = stream.isBroadcast
        ? StreamController<td.Uint8List>.broadcast(sync: true)
        : StreamController<td.Uint8List>(sync: true);
    return (controller..onListen = () => _onListen(stream, controller)).stream;
  }

  void _onListen(
    Stream<List<int>> stream,
    StreamController<td.Uint8List> controller,
  ) {
    final sink = controller.sink;
    final subscription = stream.listen(null, cancelOnError: false);
    controller.onCancel = subscription.cancel;
    if (!stream.isBroadcast) {
      controller
        ..onPause = subscription.pause
        ..onResume = subscription.resume;
    }

    final bytes = td.BytesBuilder();
    final onData = _$onData(bytes, sink, subscription.pause, subscription.resume);
    subscription
      ..onData(onData)
      ..onError(sink.addError)
      ..onDone(() {
        if (bytes.isNotEmpty) sink.add(bytes.takeBytes());
        sink.close();
      });
  }

  void Function(List<int> data) _$onData(
    td.BytesBuilder bytes,
    StreamSink<td.Uint8List> sink,
    void Function([Future<void>? resumeSignal]) pause,
    void Function() resume,
  ) =>
      (List<int> data) {
        try {
          final dataLength = data.length;
          for (var offset = 0; offset < data.length; offset += chunkSize) {
            final end = math.min<int>(offset + chunkSize, dataLength);
            final to = math.min<int>(end, offset + chunkSize - bytes.length);
            bytes.add(data.sublist(offset, to));
            if (to != end) {
              sink.add(bytes.takeBytes());
              bytes.add(data.sublist(to, end));
            }
            if (bytes.length == chunkSize) {
              sink.add(bytes.takeBytes());
            }
          }
        } on Object catch (error, stackTrace) {
          sink.addError(error, stackTrace);
        }
      };
}

/// Chunker extension methods.
/// sourceStream.Chunker<T>()
extension ChunkerX on Stream<List<int>> {
  /// {@macro chunker}
  Stream<td.Uint8List> chunker(int size) => transform(Chunker(size));
}
