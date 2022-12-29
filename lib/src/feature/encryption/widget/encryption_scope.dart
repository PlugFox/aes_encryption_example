import 'package:flutter/widgets.dart';

import '../controller/encryption_controller.dart';
import '../controller/encryption_state.codegen.dart';
import '../data/encryption_algorithm.dart';
import '../data/encryption_repository.dart';

/// {@template encryption_scope}
/// EncryptionScope widget
/// {@endtemplate}
class EncryptionScope extends StatefulWidget {
  /// {@macro encryption_scope}
  const EncryptionScope({
    required this.child,
    super.key,
  });

  /// The widget below this widget in the tree.
  final Widget child;

  static void encrypt(BuildContext context, EncryptionAlgorithm algorithm) =>
      _InheritedEncryptionScope.maybeOf(context, listen: false)?.controller.encrypt(algorithm).ignore();

  static EncryptionController controllerOf(BuildContext context) =>
      _InheritedEncryptionScope.of(context, listen: false).controller;

  static EncryptionState stateOf(BuildContext context) => _InheritedEncryptionScope.of(context, listen: true).state;

  @override
  State<EncryptionScope> createState() => _EncryptionScopeState();
}

/// State for widget EncryptionScope
class _EncryptionScopeState extends State<EncryptionScope> {
  final EncryptionController _controller = EncryptionController(repository: EncryptionRepositoryImpl());
  EncryptionState get encryptionState => _controller.state;

  /* #region Lifecycle */
  @override
  void initState() {
    _controller.addListener(_onStateChanged);
    super.initState();
  }

  @override
  void dispose() {
    _controller
      ..removeListener(_onStateChanged)
      ..dispose();
    super.dispose();
  }

  void _onStateChanged() => setState(() {});
  /* #endregion */

  @override
  Widget build(BuildContext context) => _InheritedEncryptionScope(
        state: encryptionState,
        controller: _controller,
        child: widget.child,
      );
}

/// Inherited widget for quick access in the element tree
class _InheritedEncryptionScope extends InheritedWidget {
  const _InheritedEncryptionScope({
    required this.state,
    required this.controller,
    required super.child,
  });

  final EncryptionState state;
  final EncryptionController controller;

  /// The state from the closest instance of this class
  /// that encloses the given context, if any.
  /// e.g. `EncryptionScope.maybeOf(context)`
  static _InheritedEncryptionScope? maybeOf(BuildContext context, {bool listen = true}) => listen
      ? context.dependOnInheritedWidgetOfExactType<_InheritedEncryptionScope>()
      : context.getElementForInheritedWidgetOfExactType<_InheritedEncryptionScope>()?.widget
          as _InheritedEncryptionScope?;

  static Never _notFoundInheritedWidgetOfExactType() => throw ArgumentError(
        'Out of scope, not found inherited widget '
            'a _InheritedEncryptionScope of the exact type',
        'out_of_scope',
      );

  /// The state from the closest instance of this class
  /// that encloses the given context.
  /// e.g. `EncryptionScope.of(context)`
  static _InheritedEncryptionScope of(BuildContext context, {bool listen = true}) =>
      maybeOf(context, listen: listen) ?? _notFoundInheritedWidgetOfExactType();

  @override
  bool updateShouldNotify(covariant _InheritedEncryptionScope oldWidget) => state != oldWidget.state;
}
