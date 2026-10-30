import 'package:flutter/widgets.dart';
import 'package:rebic_foundation/rebic_foundation.dart';

/// Desenho de uma [RebicBar], como o `sap.m.BarDesign` do SAPUI5.
enum RebicBarDesign {
  /// O desenho da área de `RebicPage` em que a barra está; fora de uma
  /// página, [header].
  auto,

  /// Cabeçalho: com a sombra de cabeçalho.
  header,

  /// Subcabeçalho: só o fundo.
  subHeader,

  /// Rodapé: com uma borda no topo.
  footer,

  /// Rodapé flutuante: com borda em volta e cantos arredondados.
  floatingFooter,
}

/// Alinhamento do conteúdo central de uma [RebicBar] e do título de
/// `RebicPage`, como o `sap.m.TitleAlignment` do SAPUI5.
enum RebicTitleAlignment {
  /// Centrado na barra quando couber, como o padrão da `sap.m.Bar`.
  none,

  /// Logo depois do conteúdo do início.
  start,

  /// Centrado na barra quando couber.
  center,

  /// O do tema: no Horizon, [start].
  auto,
}

/// Barra horizontal de três áreas, como o `sap.m.Bar` do SAPUI5.
///
/// [contentLeft] fica no início, [contentRight] no fim e [contentMiddle]
/// entre eles, centrado ou logo depois do início conforme [titleAlignment].
/// Os conteúdos das pontas mantêm o tamanho; o central recebe o espaço que
/// sobra. O [design] define a borda e a sombra; com `auto`, vale o da área de
/// `RebicPage` em que a barra está. A altura é `density.barHeight`.
///
/// ```dart
/// RebicBar(
///   contentMiddle: const [RebicTitle('Pedido 4711')],
///   contentRight: [RebicButton(label: 'Salvar', onPressed: save)],
/// )
/// ```
class RebicBar extends StatelessWidget {
  /// Cria a barra.
  const RebicBar({
    this.contentLeft = const [],
    this.contentMiddle = const [],
    this.contentRight = const [],
    this.design = RebicBarDesign.auto,
    this.titleAlignment = RebicTitleAlignment.none,
    super.key,
  });

  /// Conteúdo do início.
  final List<Widget> contentLeft;

  /// Conteúdo central.
  final List<Widget> contentMiddle;

  /// Conteúdo do fim.
  final List<Widget> contentRight;

  /// Desenho da barra.
  final RebicBarDesign design;

  /// Alinhamento do conteúdo central.
  final RebicTitleAlignment titleAlignment;

  @override
  Widget build(BuildContext context) {
    final theme = RebicThemeData.of(context);
    final resolved = design == RebicBarDesign.auto
        ? RebicBarScope.designOf(context)
        : design;
    final colors = theme.colors;
    final decoration = switch (resolved) {
      RebicBarDesign.header || RebicBarDesign.auto => BoxDecoration(
        color: colors.base,
        boxShadow: theme.shadows.boxShadows(
          theme.shadows.header,
          colors.shadow,
        ),
      ),
      RebicBarDesign.subHeader => BoxDecoration(color: colors.base),
      RebicBarDesign.footer => BoxDecoration(
        color: colors.base,
        border: Border(top: BorderSide(color: colors.separator)),
      ),
      RebicBarDesign.floatingFooter => BoxDecoration(
        color: colors.base,
        border: Border.all(color: colors.separator),
        borderRadius: BorderRadius.circular(theme.radius.s),
      ),
    };
    final gap = theme.spacing.xs;
    Widget group(List<Widget> children, {bool flexible = false}) => Row(
      mainAxisSize: MainAxisSize.min,
      spacing: gap,
      children: [
        for (final child in children) flexible ? Flexible(child: child) : child,
      ],
    );
    final center = switch (titleAlignment) {
      RebicTitleAlignment.none || RebicTitleAlignment.center => true,
      RebicTitleAlignment.start || RebicTitleAlignment.auto => false,
    };
    return DecoratedBox(
      decoration: decoration,
      child: SizedBox(
        height: theme.density.barHeight,
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: theme.spacing.s),
          child: CustomMultiChildLayout(
            delegate: _BarLayout(
              gap: gap,
              center: center,
              direction: Directionality.of(context),
            ),
            children: [
              if (contentLeft.isNotEmpty)
                LayoutId(id: _Slot.left, child: group(contentLeft)),
              if (contentMiddle.isNotEmpty)
                LayoutId(
                  id: _Slot.middle,
                  child: group(contentMiddle, flexible: true),
                ),
              if (contentRight.isNotEmpty)
                LayoutId(id: _Slot.right, child: group(contentRight)),
            ],
          ),
        ),
      ),
    );
  }
}

/// Área de `RebicPage` em que uma [RebicBar] com desenho `auto` está.
///
/// Uso interno do framework: a página o coloca em volta do cabeçalho, do
/// subcabeçalho e do rodapé.
class RebicBarScope extends InheritedWidget {
  /// Define [design] para as barras automáticas de [child].
  const RebicBarScope({required this.design, required super.child, super.key});

  /// Desenho das barras automáticas da subárvore.
  final RebicBarDesign design;

  /// Desenho das barras automáticas em [context]; fora de uma área, `header`.
  static RebicBarDesign designOf(BuildContext context) =>
      context.dependOnInheritedWidgetOfExactType<RebicBarScope>()?.design ??
      RebicBarDesign.header;

  @override
  bool updateShouldNotify(RebicBarScope oldWidget) =>
      design != oldWidget.design;
}

enum _Slot { left, middle, right }

/// Dispõe as pontas com a largura própria e o meio com o espaço que sobra,
/// centrado na barra quando couber ou logo depois do início.
class _BarLayout extends MultiChildLayoutDelegate {
  _BarLayout({
    required this.gap,
    required this.center,
    required this.direction,
  });

  final double gap;
  final bool center;
  final TextDirection direction;

  @override
  void performLayout(Size size) {
    final loose = BoxConstraints(maxHeight: size.height);
    final left = hasChild(_Slot.left)
        ? layoutChild(_Slot.left, loose)
        : Size.zero;
    final right = hasChild(_Slot.right)
        ? layoutChild(_Slot.right, loose)
        : Size.zero;
    final leftEnd = left.width == 0 ? 0.0 : left.width + gap;
    final rightStart = size.width - (right.width == 0 ? 0 : right.width + gap);

    double x(double start, double width) =>
        direction == TextDirection.ltr ? start : size.width - start - width;
    double y(Size child) => (size.height - child.height) / 2;

    if (hasChild(_Slot.left)) {
      positionChild(_Slot.left, Offset(x(0, left.width), y(left)));
    }
    if (hasChild(_Slot.right)) {
      positionChild(
        _Slot.right,
        Offset(x(size.width - right.width, right.width), y(right)),
      );
    }
    if (hasChild(_Slot.middle)) {
      final available = (rightStart - leftEnd).clamp(0.0, size.width);
      final middle = layoutChild(
        _Slot.middle,
        BoxConstraints(maxWidth: available, maxHeight: size.height),
      );
      var start = leftEnd;
      if (center) {
        final centered = (size.width - middle.width) / 2;
        // Centrado na barra só se não invadir as pontas.
        if (centered >= leftEnd && centered + middle.width <= rightStart) {
          start = centered;
        }
      }
      positionChild(_Slot.middle, Offset(x(start, middle.width), y(middle)));
    }
  }

  @override
  bool shouldRelayout(_BarLayout oldDelegate) =>
      gap != oldDelegate.gap ||
      center != oldDelegate.center ||
      direction != oldDelegate.direction;
}
