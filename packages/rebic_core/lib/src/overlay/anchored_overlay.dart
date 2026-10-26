import 'dart:math' as math;

import 'package:flutter/scheduler.dart';
import 'package:flutter/widgets.dart';
import 'package:rebic_foundation/rebic_foundation.dart';

import 'initial_focus.dart';

/// Lado preferido da sobreposição ancorada em relação à âncora.
enum RebicOverlaySide {
  /// Abaixo da âncora.
  below,

  /// Acima da âncora.
  above,

  /// No lado inicial da âncora (esquerda em LTR, direita em RTL).
  start,

  /// No lado final da âncora (direita em LTR, esquerda em RTL).
  end,
}

/// Alinhamento da sobreposição ao longo da âncora.
enum RebicOverlayAlignment {
  /// Alinhada ao início da âncora (borda inicial ou topo).
  start,

  /// Centralizada na âncora.
  center,

  /// Alinhada ao fim da âncora (borda final ou base).
  end,
}

/// Controla a abertura de uma [RebicAnchoredOverlay] e avisa as mudanças.
///
/// É um `OverlayPortalController` que notifica seus ouvintes em [show] e
/// [hide], para que a sobreposição guarde e devolva o foco.
class RebicAnchoredOverlayController extends OverlayPortalController
    with ChangeNotifier {
  /// Cria o controlador, fechado.
  RebicAnchoredOverlayController({super.debugLabel});

  @override
  void show() {
    if (isShowing) return;
    super.show();
    notifyListeners();
  }

  @override
  void hide() {
    if (!isShowing) return;
    super.hide();
    notifyListeners();
  }
}

/// Mostra um conteúdo junto de uma âncora, como o `Popover` do SAPUI5.
///
/// O conteúdo de [overlayBuilder] aparece no lado [side] da âncora [child],
/// alinhado por [alignment] e afastado [gap]. Sem espaço no lado preferido e
/// com espaço no oposto, vai para o oposto; e fica sempre a pelo menos
/// [margin] das bordas da área da sobreposição. Acompanha a âncora na rolagem.
///
/// Com [autoClose], fecha com um toque fora do conteúdo e da âncora, e com
/// Esc, chamando [onDismiss]. Com [focusOnShow], o foco vai para o conteúdo
/// ao abrir e volta para quem o tinha ao fechar.
///
/// [gap] e [margin] usam os espaçamentos `xs` e `s` do mapeamento de
/// referência quando omitidos, até existir o tema.
class RebicAnchoredOverlay extends StatefulWidget {
  /// Cria a sobreposição ancorada.
  const RebicAnchoredOverlay({
    required this.controller,
    required this.overlayBuilder,
    required this.child,
    this.side = RebicOverlaySide.below,
    this.alignment = RebicOverlayAlignment.start,
    this.gap,
    this.margin,
    this.autoClose = true,
    this.focusOnShow = true,
    this.onDismiss,
    super.key,
  });

  /// Abre e fecha a sobreposição.
  final RebicAnchoredOverlayController controller;

  /// Constrói o conteúdo da sobreposição.
  final WidgetBuilder overlayBuilder;

  /// A âncora.
  final Widget child;

  /// Lado preferido.
  final RebicOverlaySide side;

  /// Alinhamento ao longo da âncora.
  final RebicOverlayAlignment alignment;

  /// Distância entre a âncora e o conteúdo.
  final double? gap;

  /// Distância mínima entre o conteúdo e as bordas da área da sobreposição.
  final double? margin;

  /// Se um toque fora e Esc fecham a sobreposição.
  final bool autoClose;

  /// Se o foco vai para o conteúdo ao abrir e volta ao fechar.
  final bool focusOnShow;

  /// Chamado quando a sobreposição é fechada por toque fora ou Esc.
  final VoidCallback? onDismiss;

  @override
  State<RebicAnchoredOverlay> createState() => _RebicAnchoredOverlayState();
}

class _RebicAnchoredOverlayState extends State<RebicAnchoredOverlay> {
  final _anchorKey = GlobalKey();
  final List<ScrollPosition> _positions = [];
  FocusNode? _focusBeforeShow;
  bool _wasShowing = false;

  static const _spacing = RebicSpacingTokens.fallback();

  @override
  void initState() {
    super.initState();
    widget.controller.addListener(_handleControllerChange);
  }

  @override
  void didUpdateWidget(RebicAnchoredOverlay oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.controller != widget.controller) {
      oldWidget.controller.removeListener(_handleControllerChange);
      widget.controller.addListener(_handleControllerChange);
    }
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _listenToScrolling();
  }

  @override
  void dispose() {
    widget.controller.removeListener(_handleControllerChange);
    for (final position in _positions) {
      position.removeListener(_handleScroll);
    }
    super.dispose();
  }

  /// Ouve as rolagens de todos os `Scrollable` acima da âncora.
  void _listenToScrolling() {
    for (final position in _positions) {
      position.removeListener(_handleScroll);
    }
    _positions.clear();
    var scrollable = Scrollable.maybeOf(context);
    while (scrollable != null) {
      _positions.add(scrollable.position..addListener(_handleScroll));
      scrollable = Scrollable.maybeOf(scrollable.context);
    }
  }

  // A posição da âncora só é atualizada no layout que segue a rolagem; o
  // conteúdo é reposicionado logo depois dele.
  void _handleScroll() {
    if (!widget.controller.isShowing) return;
    SchedulerBinding.instance
      ..addPostFrameCallback((_) {
        if (mounted && widget.controller.isShowing) setState(() {});
      })
      ..ensureVisualUpdate();
  }

  void _handleControllerChange() {
    final showing = widget.controller.isShowing;
    if (showing == _wasShowing) return;
    _wasShowing = showing;
    if (!widget.focusOnShow) return;
    if (showing) {
      _focusBeforeShow = FocusManager.instance.primaryFocus;
    } else {
      final previous = _focusBeforeShow;
      _focusBeforeShow = null;
      if (previous != null && previous.context != null) {
        previous.requestFocus();
      }
    }
  }

  void _dismiss() {
    widget.controller.hide();
    widget.onDismiss?.call();
  }

  /// Retângulo da âncora nas coordenadas do `Overlay`, ou nulo antes do
  /// primeiro layout.
  Rect? _anchorRect(BuildContext overlayContext) {
    final anchor = _anchorKey.currentContext?.findRenderObject();
    final overlay = Overlay.of(context).context.findRenderObject();
    if (anchor is! RenderBox || overlay is! RenderBox || !anchor.hasSize) {
      return null;
    }
    final origin = anchor.localToGlobal(Offset.zero, ancestor: overlay);
    return origin & anchor.size;
  }

  Widget _buildOverlay(BuildContext overlayContext) {
    final anchorRect = _anchorRect(overlayContext);
    if (anchorRect == null) return const SizedBox.shrink();
    Widget content = widget.overlayBuilder(overlayContext);
    if (widget.focusOnShow) {
      content = FocusScope(child: RebicInitialFocus(child: content));
    }
    content = Actions(
      actions: {
        DismissIntent: CallbackAction<DismissIntent>(
          onInvoke: (_) {
            if (widget.autoClose) _dismiss();
            return null;
          },
        ),
      },
      child: TapRegion(
        groupId: this,
        onTapOutside: widget.autoClose ? (_) => _dismiss() : null,
        child: content,
      ),
    );
    return CustomSingleChildLayout(
      delegate: _AnchoredLayoutDelegate(
        anchor: anchorRect,
        side: widget.side,
        alignment: widget.alignment,
        gap: widget.gap ?? _spacing.xs,
        margin: widget.margin ?? _spacing.s,
        textDirection: Directionality.of(context),
      ),
      child: content,
    );
  }

  @override
  Widget build(BuildContext context) {
    return OverlayPortal(
      controller: widget.controller,
      overlayChildBuilder: _buildOverlay,
      child: TapRegion(
        groupId: this,
        child: KeyedSubtree(key: _anchorKey, child: widget.child),
      ),
    );
  }
}

/// Posiciona o conteúdo junto da âncora, com inversão e limite de bordas.
class _AnchoredLayoutDelegate extends SingleChildLayoutDelegate {
  _AnchoredLayoutDelegate({
    required this.anchor,
    required this.side,
    required this.alignment,
    required this.gap,
    required this.margin,
    required this.textDirection,
  });

  final Rect anchor;
  final RebicOverlaySide side;
  final RebicOverlayAlignment alignment;
  final double gap;
  final double margin;
  final TextDirection textDirection;

  @override
  BoxConstraints getConstraintsForChild(BoxConstraints constraints) {
    return BoxConstraints.loose(
      Size(
        math.max(0, constraints.maxWidth - 2 * margin),
        math.max(0, constraints.maxHeight - 2 * margin),
      ),
    );
  }

  @override
  Offset getPositionForChild(Size size, Size childSize) {
    final rtl = textDirection == TextDirection.rtl;
    final w = childSize.width;
    final h = childSize.height;

    // Posição ao longo da âncora, pelo alinhamento resolvido na direção.
    double along(
      double start,
      double end,
      double extent, {
      required bool horizontal,
    }) {
      final flip = horizontal && rtl;
      return switch (alignment) {
        RebicOverlayAlignment.center => (start + end - extent) / 2,
        RebicOverlayAlignment.start => flip ? end - extent : start,
        RebicOverlayAlignment.end => flip ? start : end - extent,
      };
    }

    final double x;
    final double y;
    switch (side) {
      case RebicOverlaySide.below:
      case RebicOverlaySide.above:
        final belowY = anchor.bottom + gap;
        final aboveY = anchor.top - gap - h;
        final fitsBelow = belowY + h <= size.height - margin;
        final fitsAbove = aboveY >= margin;
        final wantsBelow = side == RebicOverlaySide.below;
        final goBelow = wantsBelow
            ? (fitsBelow || !fitsAbove)
            : !(fitsAbove || !fitsBelow);
        y = goBelow ? belowY : aboveY;
        x = along(anchor.left, anchor.right, w, horizontal: true);
      case RebicOverlaySide.start:
      case RebicOverlaySide.end:
        final rightX = anchor.right + gap;
        final leftX = anchor.left - gap - w;
        final fitsRight = rightX + w <= size.width - margin;
        final fitsLeft = leftX >= margin;
        final wantsRight = (side == RebicOverlaySide.end) != rtl;
        final goRight = wantsRight
            ? (fitsRight || !fitsLeft)
            : !(fitsLeft || !fitsRight);
        x = goRight ? rightX : leftX;
        y = along(anchor.top, anchor.bottom, h, horizontal: false);
    }
    return Offset(
      _clamp(x, margin, size.width - margin - w),
      _clamp(y, margin, size.height - margin - h),
    );
  }

  static double _clamp(double value, double min, double max) =>
      max < min ? min : value.clamp(min, max);

  @override
  bool shouldRelayout(_AnchoredLayoutDelegate old) =>
      old.anchor != anchor ||
      old.side != side ||
      old.alignment != alignment ||
      old.gap != gap ||
      old.margin != margin ||
      old.textDirection != textDirection;
}
