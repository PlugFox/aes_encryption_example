import 'dart:ui' as ui;

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../controller/encryption_controller.dart';
import '../data/encryption_algorithm.dart';
import '../model/encryption_progress.dart';
import 'encryption_scope.dart';

/// {@template encryption_form}
/// EncryptionForm widget
/// {@endtemplate}
class EncryptionForm extends StatefulWidget {
  /// {@macro encryption_form}
  const EncryptionForm({super.key});

  @override
  State<EncryptionForm> createState() => _EncryptionFormState();
}

class _EncryptionFormState extends State<EncryptionForm> with _ProgressMixin {
  final ValueNotifier<EncryptionAlgorithm?> _algorithmNotifier = ValueNotifier<EncryptionAlgorithm?>(null);

  @override
  void dispose() {
    _algorithmNotifier.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => ValueListenableBuilder<bool>(
        valueListenable: _processingListenable,
        builder: (context, inProgress, _) => Stack(
          alignment: Alignment.center,
          children: <Widget>[
            Positioned.fill(child: _FormContent(algorithmNotifier: _algorithmNotifier, inProgress: inProgress)),
            Positioned.fill(child: _ProgressBarrier(inProgress: inProgress)),
          ],
        ),
      );
}

mixin _ProgressMixin on State<EncryptionForm> {
  double get progress => _progressListenable.value.value;
  late final EncryptionController _controller;
  late final ValueListenable<bool> _processingListenable;
  late final ValueListenable<EncryptionProgress> _progressListenable;

  @override
  void initState() {
    super.initState();
    _controller = EncryptionScope.controllerOf(context)..addListener(_onStateChanged);
    _processingListenable = _controller.select<bool>(
      (controller) => controller.isProcessing,
      (prev, next) => prev != next,
    );
    _progressListenable = _controller.select<EncryptionProgress>(
      (controller) => controller.state.progress,
      (prev, next) => prev != next,
    );
  }

  @override
  void dispose() {
    _controller
      ..removeListener(_onStateChanged)
      ..dispose();
    super.dispose();
  }

  void _onStateChanged() => _controller.state.mapOrNull<void>(
        processing: (state) {
          HapticFeedback.selectionClick().ignore();
        },
        successful: (state) {
          HapticFeedback.heavyImpact().ignore();
          ScaffoldMessenger.maybeOf(context)?.showSnackBar(
            SnackBar(
              content: Text(state.message),
              duration: const Duration(seconds: 10),
            ),
          );
        },
        error: (state) {
          HapticFeedback.heavyImpact().ignore();
          ScaffoldMessenger.maybeOf(context)?.showSnackBar(
            SnackBar(
              content: Text(state.message),
              backgroundColor: Colors.red,
              duration: const Duration(seconds: 10),
            ),
          );
        },
      );
}

class _FormContent extends StatelessWidget {
  const _FormContent({
    required this.algorithmNotifier,
    required this.inProgress,
  });

  final bool inProgress;
  final ValueNotifier<EncryptionAlgorithm?> algorithmNotifier;

  @override
  Widget build(BuildContext context) => Center(
        child: SingleChildScrollView(
          child: Card(
            elevation: 8,
            margin: const EdgeInsets.all(16),
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 16),
              child: ValueListenableBuilder<EncryptionAlgorithm?>(
                valueListenable: algorithmNotifier,
                builder: (context, currentAlgorithm, _) => Column(
                  mainAxisSize: MainAxisSize.min,
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    Text(
                      'Select the encryption option to use',
                      style: Theme.of(context).textTheme.labelLarge,
                    ),
                    const SizedBox(height: 8),
                    // TODO: Secret key (16 chars, only numbers and text)
                    // Matiunin Mikhail <plugfox@gmail.com>, 30 December 2022
                    ...EncryptionAlgorithm.values.map<Widget>(
                      (algorithm) => RadioListTile<EncryptionAlgorithm>(
                        title: Text(algorithm.name, style: Theme.of(context).textTheme.labelMedium),
                        subtitle: Text(algorithm.description, style: Theme.of(context).textTheme.labelSmall),
                        value: algorithm,
                        groupValue: currentAlgorithm,
                        onChanged: (value) {
                          algorithmNotifier.value = value;
                          HapticFeedback.selectionClick().ignore();
                        },
                      ),
                    ),
                    const Divider(
                      height: 24,
                      thickness: 1,
                      indent: 16,
                      endIndent: 16,
                    ),
                    ElevatedButton(
                      onPressed: currentAlgorithm == null || inProgress
                          ? null
                          : () {
                              // TODO: pass secret key
                              // Matiunin Mikhail <plugfox@gmail.com>, 30 December 2022
                              EncryptionScope.encrypt(context, '0123456789abcdef', currentAlgorithm);
                              HapticFeedback.mediumImpact().ignore();
                            },
                      child: const Text('Encrypt'),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      );
}

class _ProgressBarrier extends StatelessWidget {
  const _ProgressBarrier({
    required this.inProgress,
  });

  final bool inProgress;

  @override
  Widget build(BuildContext context) => AbsorbPointer(
        absorbing: inProgress,
        child: Stack(
          children: [
            Positioned.fill(
              child: RepaintBoundary(
                child: AnimatedSwitcher(
                  duration: const Duration(milliseconds: 350),
                  child: inProgress
                      ? RepaintBoundary(
                          child: ClipRect(
                            child: BackdropFilter(
                              filter: ui.ImageFilter.blur(sigmaX: 2, sigmaY: 2),
                              child: ColoredBox(
                                color: Colors.black.withOpacity(0.5),
                                child: const SizedBox.expand(),
                              ),
                            ),
                          ),
                        )
                      : const SizedBox.shrink(),
                ),
              ),
            ),
            Positioned.fill(
              child: AnimatedSwitcher(
                duration: const Duration(milliseconds: 650),
                transitionBuilder: (child, animation) => FadeTransition(
                  opacity: animation,
                  child: ScaleTransition(
                    scale: Tween<double>(begin: 0, end: 1).animate(animation),
                    alignment: Alignment.center,
                    child: child,
                  ),
                ),
                child: inProgress ? const _ProgressIndicator() : const SizedBox.shrink(),
              ),
            ),
          ],
        ),
      );
}

// TODO: Replace with custom progress indicator, with percent and always rotation
// Matiunin Mikhail <plugfox@gmail.com>, 30 December 2022
class _ProgressIndicator extends StatelessWidget {
  const _ProgressIndicator();

  @override
  Widget build(BuildContext context) => Center(
        child: SizedBox.square(
          dimension: 128,
          child: RepaintBoundary(
            child: ValueListenableBuilder<EncryptionProgress>(
              valueListenable: context.findAncestorStateOfType<_EncryptionFormState>()?._progressListenable ??
                  const AlwaysStoppedAnimation<EncryptionProgress>(EncryptionProgress(0)),
              builder: (context, progress, _) => CircularProgressIndicator(
                value: progress.value.clamp(0.0, 1.0),
                strokeWidth: 16,
              ),
            ),
          ),
        ),
      );
}
