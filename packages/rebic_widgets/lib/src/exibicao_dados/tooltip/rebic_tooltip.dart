import 'dart:async';

import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:rebic_core/rebic_core.dart';
import 'package:rebic_foundation/rebic_foundation.dart';

import '../../fundacao_layout/container/rebic_container.dart';
import '../../fundacao_layout/spacing/rebic_spacing.dart';
import '../../fundacao_layout/text/rebic_text.dart';

/// Dica textual de um elemento, como o `tooltip` dos controles do SAPUI5.
///
/// A dica com [message] abre junto de [child], na posição [placement] e centralizada
/// nele:
/// - com o ponteiro sobre o filho, após `motion.long`;
/// - com o foco do teclado no filho, sem atraso;
/// - com um toque longo.
///
/// Ela fecha quando o ponteiro sai (após `motion.short`, a menos que chegue à
/// dica), quando o filho perde o foco, com Esc ou com um toque fora. Permanece
/// enquanto o ponteiro está sobre ela, e só uma dica fica aberta por vez. A
/// mensagem é anunciada como a dica do próprio filho.
///
/// Precisa de um `Overlay` acima (o `RebicApp` fornece). Um filho com toque
/// longo próprio compete com o da dica.
///
/// ```dart
/// RebicTooltip(
///   message: 'Editar pedido',
///   child: EditarButton(),
/// )
/// ```
class RebicTooltip extends StatefulWidget {
  /// Cria a dica [message] de [child].
  const RebicTooltip({
    required this.message,
    required this.child,
    this.placement = RebicPlacement.bottom,
    this.excludeFromSemantics = false,
    super.key,
  }) : assert(message != '', 'message não pode ser vazia');

  /// Texto da dica.
  final String message;

  /// Elemento descrito pela dica.
  final Widget child;

  /// Posição preferida da dica em relação ao filho.
  final RebicPlacement placement;

  /// Se a mensagem fica fora da semântica, quando o filho já a anuncia como
  /// rótulo (ex.: um botão de ícone cujo rótulo é a própria dica).
  final bool excludeFromSemantics;

  @override
  State<RebicTooltip> createState() => _RebicTooltipState();
}

/// Largura máxima da dica em passos `spacing.xxxl`: 288 nos tokens de
/// referência, perto da largura usual de uma dica.
const _maxWidthSteps = 6;

class _RebicTooltipState extends State<RebicTooltip> {
  /// A dica aberta, para que só uma fique aberta por vez.
  static _RebicTooltipState? _open;

  final _controller = RebicAnchoredOverlayController();
  Timer? _showTimer;
  Timer? _hideTimer;
  bool _keyHandlerActive = false;

  RebicMotionTokens get _motion => RebicThemeData.of(context).motion;

  void _show() {
    _cancelTimers();
    if (_controller.isShowing) return;
    final open = _open;
    if (open != null && open != this) open._hide();
    _open = this;
    _controller.show();
    HardwareKeyboard.instance.addHandler(_handleKey);
    _keyHandlerActive = true;
  }

  void _hide() {
    _cancelTimers();
    if (_open == this) _open = null;
    if (_keyHandlerActive) {
      HardwareKeyboard.instance.removeHandler(_handleKey);
      _keyHandlerActive = false;
    }
    _controller.hide();
  }

  void _cancelTimers() {
    _showTimer?.cancel();
    _hideTimer?.cancel();
    _showTimer = _hideTimer = null;
  }

  /// Executa [action] após [delay], ou já, quando o atraso é zero.
  Timer? _after(Duration delay, VoidCallback action) {
    if (delay == Duration.zero) {
      action();
      return null;
    }
    return Timer(delay, action);
  }

  void _scheduleShow() {
    _hideTimer?.cancel();
    if (_controller.isShowing) return;
    _showTimer?.cancel();
    _showTimer = _after(_motion.long, _show);
  }

  void _scheduleHide() {
    _showTimer?.cancel();
    if (!_controller.isShowing) return;
    _hideTimer?.cancel();
    _hideTimer = _after(_motion.short, _hide);
  }

  void _handleFocusChange(bool focused) {
    if (focused &&
        FocusManager.instance.highlightMode == FocusHighlightMode.traditional) {
      _show();
    } else if (!focused) {
      _hide();
    }
  }

  // Esc fecha a dica sem mover o foco, aberta pelo foco ou pelo ponteiro.
  bool _handleKey(KeyEvent event) {
    if (event is KeyDownEvent &&
        event.logicalKey == LogicalKeyboardKey.escape &&
        _controller.isShowing) {
      _hide();
      return true;
    }
    return false;
  }

  @override
  void dispose() {
    _cancelTimers();
    if (_open == this) _open = null;
    if (_keyHandlerActive) {
      HardwareKeyboard.instance.removeHandler(_handleKey);
    }
    _controller.dispose();
    super.dispose();
  }

  Widget _bubble(BuildContext context) {
    final theme = RebicThemeData.of(context);
    return MouseRegion(
      onEnter: (_) => _hideTimer?.cancel(),
      onExit: (_) => _scheduleHide(),
      // A mensagem já está na semântica do filho.
      child: ExcludeSemantics(
        child: ConstrainedBox(
          constraints: BoxConstraints(
            maxWidth: theme.spacing.xxxl * _maxWidthSteps,
          ),
          child: RebicContainer(
            surface: RebicSurface.base,
            border: true,
            radius: RebicRadius.s,
            shadow: RebicShadow.popover,
            child: RebicSpacing.padding(
              horizontal: RebicSpace.s,
              vertical: RebicSpace.xs,
              child: RebicText(widget.message, variant: RebicTextVariant.label),
            ),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final overlay = RebicAnchoredOverlay(
      controller: _controller,
      placement: widget.placement,
      alignment: RebicOverlayAlignment.center,
      focusOnShow: false,
      onDismiss: _hide,
      overlayBuilder: _bubble,
      child: Focus(
        canRequestFocus: false,
        skipTraversal: true,
        onFocusChange: _handleFocusChange,
        child: MouseRegion(
          onEnter: (_) => _scheduleShow(),
          onExit: (_) => _scheduleHide(),
          // O toque longo só mostra a dica na tela; o leitor de tela já
          // recebe a mensagem, então a ação não entra na semântica.
          child: GestureDetector(
            behavior: HitTestBehavior.translucent,
            excludeFromSemantics: true,
            onLongPress: _show,
            child: widget.child,
          ),
        ),
      ),
    );
    if (widget.excludeFromSemantics) return overlay;
    return Semantics(tooltip: widget.message, child: overlay);
  }
}
