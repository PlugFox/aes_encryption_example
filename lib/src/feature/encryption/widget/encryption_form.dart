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
  final TextEditingController _secretKeyController = TextEditingController(text: '0123456789abcdef');

  @override
  void dispose() {
    _algorithmNotifier.dispose();
    _secretKeyController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => ValueListenableBuilder<bool>(
        valueListenable: _processingListenable,
        builder: (context, inProgress, _) => Stack(
          alignment: Alignment.center,
          children: <Widget>[
            Positioned.fill(
              child: _FormContent(
                algorithmNotifier: _algorithmNotifier,
                secretKey: _secretKeyController,
                inProgress: inProgress,
              ),
            ),
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
    required this.inProgress,
    required this.secretKey,
    required this.algorithmNotifier,
  });

  final bool inProgress;
  final TextEditingController secretKey;
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
                      'Encryption option',
                      style: Theme.of(context).textTheme.labelLarge?.copyWith(fontSize: 18),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 16),
                    ...EncryptionAlgorithm.values.map<Widget>(
                      (algorithm) => RadioListTile<EncryptionAlgorithm>(
                        title: Text(
                          algorithm.name,
                          style: Theme.of(context).textTheme.labelMedium?.copyWith(fontSize: 16),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                        subtitle: Text(
                          algorithm.description,
                          style: Theme.of(context).textTheme.labelSmall,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                        value: algorithm,
                        groupValue: currentAlgorithm,
                        onChanged: (value) {
                          algorithmNotifier.value = value;
                          HapticFeedback.selectionClick().ignore();
                        },
                      ),
                    ),
                    const Divider(height: 24, thickness: 1, indent: 16, endIndent: 16),
                    const SizedBox(height: 16),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      child: Center(
                        child: SizedBox(
                          width: 250,
                          child: TextField(
                            controller: secretKey,
                            expands: false,
                            maxLength: 16,
                            maxLines: 1,
                            textAlign: TextAlign.center,
                            keyboardType: TextInputType.visiblePassword,
                            enabled: !inProgress,
                            inputFormatters: <TextInputFormatter>[
                              FilteringTextInputFormatter.allow(RegExp('[0-9a-fA-F]')),
                            ],
                            decoration: const InputDecoration(
                              border: OutlineInputBorder(),
                              labelText: 'Secret key',
                              hintText: 'Secret key (16 chars)',
                            ),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 24),
                    Center(
                      child: SizedBox(
                        width: 250,
                        height: 64,
                        child: ValueListenableBuilder(
                          valueListenable: secretKey,
                          builder: (context, key, __) => ElevatedButton(
                            onPressed: currentAlgorithm == null || inProgress || key.text.length != 16
                                ? null
                                : () {
                                    EncryptionScope.encrypt(context, key.text, currentAlgorithm);
                                    HapticFeedback.mediumImpact().ignore();
                                  },
                            child: const Text('Encrypt', style: TextStyle(fontSize: 24)),
                          ),
                        ),
                      ),
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
