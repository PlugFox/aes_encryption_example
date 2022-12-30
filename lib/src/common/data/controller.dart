import 'package:flutter/foundation.dart' show Listenable, ValueListenable, VoidCallback, ChangeNotifier;
import 'package:meta/meta.dart';

import '../util/logging.dart';

typedef SetState<State extends Object> = void Function(State state);

/// Selector from [Listenable]
typedef ChangeNotifierSelector<Controller extends Listenable, Value> = Value Function(
  Controller controller,
);

/// Filter for [Listenable]
typedef ChangeNotifierFilter<Value> = bool Function(Value prev, Value next);

abstract class Controller<State extends Object> with ChangeNotifier {
  Controller(State initialState) : _$state = initialState;

  /// The current state of the controller
  @nonVirtual
  State get state => _$state;
  State _$state;

  /// Whether the controller is currently handling a request
  @nonVirtual
  bool get isProcessing => _$isProcessing;
  bool _$isProcessing = false;

  @nonVirtual
  @protected
  void setState(State state) {
    _$state = state;
    notifyListeners();
  }

  @nonVirtual
  @protected
  Future<void> handle(Future<void> Function(SetState<State> setState) handler) async {
    // For throttling handle calls
    if (_$isProcessing) return;
    _$isProcessing = true;
    notifyListeners();
    try {
      await handler(setState);
    } on Object catch (error, stackTrace) {
      // TODO: Rethrow all errors to global observer, instead of logging them
      // Matiunin Mikhail <plugfox@gmail.com>, 30 December 2022
      severe(error, stackTrace, 'Error "$error" while handling controller $runtimeType');
    } finally {
      _$isProcessing = false;
      notifyListeners();
    }
  }

  @protected
  @nonVirtual
  @override
  void notifyListeners() => super.notifyListeners();

  /// Transform [Listenable] in to [ValueListenable]
  @nonVirtual
  ValueListenable<Value> select<Value>(
    ChangeNotifierSelector<Controller<State>, Value> selector, [
    ChangeNotifierFilter<Value>? test,
  ]) =>
      _ValueListenableView<Controller<State>, Value>(this, selector, test);
}

@sealed
class _ValueListenableView<Controller extends Listenable, Value> with ChangeNotifier implements ValueListenable<Value> {
  _ValueListenableView(
    Controller controller,
    ChangeNotifierSelector<Controller, Value> selector,
    ChangeNotifierFilter<Value>? test,
  )   : _controller = controller,
        _selector = selector,
        _test = test;

  final Controller _controller;
  final ChangeNotifierSelector<Controller, Value> _selector;
  final ChangeNotifierFilter<Value>? _test;

  @override
  Value get value => hasListeners ? _$value : _selector(_controller);

  late Value _$value;

  void _update() {
    final newValue = _selector(_controller);
    if (identical(_$value, newValue)) return;
    if (!(_test?.call(_$value, newValue) ?? true)) return;
    _$value = newValue;
    notifyListeners();
  }

  @override
  void addListener(VoidCallback listener) {
    if (!hasListeners) {
      _$value = _selector(_controller);
      _controller.addListener(_update);
    }
    super.addListener(listener);
  }

  @override
  void removeListener(VoidCallback listener) {
    super.removeListener(listener);
    if (!hasListeners) _controller.removeListener(_update);
  }

  @override
  void dispose() {
    _controller.removeListener(_update);
    super.dispose();
  }
}
