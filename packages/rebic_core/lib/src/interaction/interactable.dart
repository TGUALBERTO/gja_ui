import 'package:flutter/widgets.dart';
import 'package:rebic_foundation/rebic_foundation.dart';

import 'focus_ring.dart';

/// Constrói o conteúdo de um [RebicInteractable] a partir dos estados ativos.
typedef RebicInteractableBuilder =
    Widget Function(BuildContext context, Set<RebicInteractionState> states);

/// Elemento interativo base do Rebic.
///
/// Detecta hover, pressionado e foco; ativa por toque e por Enter, Enter
/// numérico ou Espaço (atalhos nativos do `WidgetsApp`); desabilita-se quando
/// [onPressed] é nulo; ocupa pelo menos [minTargetSize] em cada dimensão;
/// expõe semântica de botão; e desenha o anel de foco somente quando o foco
/// vem do teclado. O widget que o usa pinta a própria aparência no
/// [builder], normalmente com `RebicControlColors.resolve` da família do
/// controle e `RebicInteractionStateTokens.opacity`.
///
/// Os valores visuais omitidos vêm do tema ativo (`RebicThemeData.of`):
/// alvo da densidade, tokens de interação, cor `focus` e raio `control`. Um
/// valor passado tem precedência sobre o do tema.
class RebicInteractable extends StatefulWidget {
  /// Cria o elemento.
  const RebicInteractable({
    required this.builder,
    this.onPressed,
    this.selected = false,
    this.semanticLabel,
    this.focusNode,
    this.autofocus = false,
    this.minTargetSize,
    this.interactionTokens,
    this.focusColor,
    this.focusRingBorderRadius,
    super.key,
  });

  /// Constrói o conteúdo a partir dos estados ativos.
  final RebicInteractableBuilder builder;

  /// Ação do elemento; nula deixa o elemento desabilitado.
  final VoidCallback? onPressed;

  /// Se o elemento está selecionado (informado pelo widget que o usa).
  final bool selected;

  /// Rótulo lido pelo leitor de tela.
  final String? semanticLabel;

  /// Nó de foco externo; um interno é criado quando nulo.
  final FocusNode? focusNode;

  /// Se o elemento pede foco ao ser inserido.
  final bool autofocus;

  /// Lado mínimo da área de interação, em pixels lógicos; nulo usa o alvo
  /// da densidade do tema ativo.
  final double? minTargetSize;

  /// Regras e valores dos estados de interação; nulo usa os do tema ativo.
  final RebicInteractionStateTokens? interactionTokens;

  /// Cor do anel de foco; nula usa o papel `focus` do tema ativo.
  final Color? focusColor;

  /// Cantos do conteúdo, para o anel de foco acompanhar a curva; nulo usa o
  /// raio `control` do tema ativo.
  final BorderRadius? focusRingBorderRadius;

  @override
  State<RebicInteractable> createState() => _RebicInteractableState();
}

class _RebicInteractableState extends State<RebicInteractable> {
  FocusNode? _internalFocusNode;
  bool _hovered = false;
  bool _pressed = false;
  bool _focused = false;
  bool _focusHighlight = false;

  FocusNode get _focusNode =>
      widget.focusNode ?? (_internalFocusNode ??= FocusNode());

  bool get _enabled => widget.onPressed != null;

  Set<RebicInteractionState> get _states => {
    if (!_enabled) RebicInteractionState.disabled,
    if (_enabled && _hovered) RebicInteractionState.hovered,
    if (_enabled && _pressed) RebicInteractionState.pressed,
    if (_enabled && _focused) RebicInteractionState.focused,
    if (widget.selected) RebicInteractionState.selected,
  };

  @override
  void didUpdateWidget(RebicInteractable oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (!_enabled) {
      _hovered = false;
      _pressed = false;
    }
  }

  @override
  void dispose() {
    _internalFocusNode?.dispose();
    super.dispose();
  }

  void _activate() => widget.onPressed?.call();

  void _setPressed(bool value) {
    if (_pressed != value) setState(() => _pressed = value);
  }

  @override
  Widget build(BuildContext context) {
    final states = _states;
    final theme = RebicThemeData.of(context);
    final tokens = widget.interactionTokens ?? theme.interaction;
    final minTargetSize = widget.minTargetSize ?? theme.density.minTargetSize;
    final showRing = _focusHighlight && tokens.showsFocusRing(states);

    return Semantics(
      container: true,
      button: true,
      enabled: _enabled,
      selected: widget.selected,
      label: widget.semanticLabel,
      onTap: _enabled ? _activate : null,
      child: FocusableActionDetector(
        enabled: _enabled,
        focusNode: _focusNode,
        autofocus: widget.autofocus,
        mouseCursor: _enabled
            ? SystemMouseCursors.click
            : SystemMouseCursors.basic,
        actions: <Type, Action<Intent>>{
          ActivateIntent: CallbackAction<ActivateIntent>(
            onInvoke: (_) => _activate(),
          ),
          ButtonActivateIntent: CallbackAction<ButtonActivateIntent>(
            onInvoke: (_) => _activate(),
          ),
        },
        onShowFocusHighlight: (value) =>
            setState(() => _focusHighlight = value),
        onFocusChange: (value) => setState(() => _focused = value),
        // Hover é o fato de o ponteiro estar sobre o elemento; o destaque de
        // hover do FocusableActionDetector depende do modo de destaque.
        child: MouseRegion(
          onEnter: _enabled ? (_) => setState(() => _hovered = true) : null,
          onExit: (_) {
            if (_hovered) setState(() => _hovered = false);
          },
          child: GestureDetector(
            behavior: HitTestBehavior.opaque,
            onTapDown: _enabled
                ? (_) {
                    _focusNode.requestFocus();
                    _setPressed(true);
                  }
                : null,
            onTapUp: _enabled ? (_) => _setPressed(false) : null,
            onTapCancel: _enabled ? () => _setPressed(false) : null,
            onTap: _enabled ? _activate : null,
            child: ConstrainedBox(
              constraints: BoxConstraints(
                minWidth: minTargetSize,
                minHeight: minTargetSize,
              ),
              child: Center(
                widthFactor: 1,
                heightFactor: 1,
                child: RebicFocusRing(
                  visible: showRing,
                  width: tokens.focusWidth,
                  offset: tokens.focusOffset,
                  color: widget.focusColor ?? theme.colors.focus,
                  borderRadius:
                      widget.focusRingBorderRadius ??
                      BorderRadius.circular(theme.radius.control),
                  child: widget.builder(context, states),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
