import 'package:flutter/widgets.dart';
import 'package:rebic_core/rebic_core.dart';
import 'package:rebic_foundation/rebic_foundation.dart';

import '../responsive_layout/rebic_responsive_layout.dart';
import '../spacing/rebic_spacing.dart';

/// Item de um [RebicGrid] com span próprio, como o `GridData` do SAPUI5.
///
/// É uma configuração, não um widget: use em [RebicGrid.cells].
@immutable
class RebicGridCell {
  /// Cria a célula de [child], com [span] próprio opcional.
  const RebicGridCell({required this.child, this.span});

  /// Conteúdo da célula.
  final Widget child;

  /// Colunas ocupadas por classe de tamanho (de 1 a 12); nulo usa o
  /// `defaultSpan` da grade.
  final RebicResponsiveValue<int>? span;
}

/// Grade de 12 colunas, como o `sap.ui.layout.Grid` do SAPUI5.
///
/// Cada item ocupa um número de colunas por classe de tamanho ([defaultSpan]
/// ou o `span` da sua [RebicGridCell]), com herança da classe menor. Os itens
/// fluem em linhas na ordem dada; um item que não cabe no restante da linha
/// começa a seguinte. O espaço entre colunas ([gap]) e entre linhas
/// ([runGap]) vem do tema. Em RTL, a primeira coluna fica à direita.
///
/// ```dart
/// RebicGrid(children: [for (final p in pedidos) PedidoCard(p)])
///
/// const RebicGrid.cells(cells: [
///   RebicGridCell(
///     child: Resumo(),
///     span: RebicResponsiveValue(small: 12, large: 8),
///   ),
///   RebicGridCell(child: Atalhos()),
/// ])
/// ```
class RebicGrid extends StatelessWidget {
  /// Grade em que todos os [children] usam [defaultSpan].
  RebicGrid({
    required List<Widget> children,
    this.defaultSpan = standardSpan,
    this.gap = RebicSpace.l,
    this.runGap = RebicSpace.l,
    this.basis = RebicLayoutBasis.container,
    super.key,
  }) : cells = [for (final child in children) RebicGridCell(child: child)];

  /// Grade de [cells], cada uma com span próprio opcional.
  const RebicGrid.cells({
    required this.cells,
    this.defaultSpan = standardSpan,
    this.gap = RebicSpace.l,
    this.runGap = RebicSpace.l,
    this.basis = RebicLayoutBasis.container,
    super.key,
  });

  /// Número de colunas da grade.
  static const columns = 12;

  /// Span padrão, como o `XL3 L4 M6 S12` do UI5: 1, 2, 3 e 4 itens por
  /// linha de `small` a `extraLarge`.
  static const standardSpan = RebicResponsiveValue(
    small: 12,
    medium: 6,
    large: 4,
    extraLarge: 3,
  );

  /// Itens, na ordem de leitura.
  final List<RebicGridCell> cells;

  /// Colunas ocupadas por item sem span próprio.
  final RebicResponsiveValue<int> defaultSpan;

  /// Espaço entre colunas.
  final RebicSpace gap;

  /// Espaço entre linhas.
  final RebicSpace runGap;

  /// De onde a classe de tamanho é medida.
  final RebicLayoutBasis basis;

  @override
  Widget build(BuildContext context) {
    final theme = RebicThemeData.of(context);
    final screenClass = basis == RebicLayoutBasis.screen
        ? RebicResponsive.screenSizeClassOf(context)
        : null;
    return LayoutBuilder(
      builder: (context, constraints) {
        final width = constraints.maxWidth;
        assert(
          width.isFinite,
          'RebicGrid precisa de largura limitada (recebeu $width)',
        );
        final sizeClass = screenClass ?? theme.breakpoints.classify(width);
        final g = RebicSpacing.resolve(theme.spacing, gap);
        final column = (width - (columns - 1) * g) / columns;

        final rows = <List<(int, Widget)>>[];
        var used = columns;
        for (final (index, cell) in cells.indexed) {
          final span = (cell.span ?? defaultSpan).resolve(sizeClass);
          assert(
            span >= 1 && span <= columns,
            'span da célula $index deve estar entre 1 e $columns: $span',
          );
          if (used + span > columns) {
            rows.add([]);
            used = 0;
          }
          rows.last.add((span, cell.child));
          used += span;
        }

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          spacing: RebicSpacing.resolve(theme.spacing, runGap),
          children: [
            for (final row in rows)
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                spacing: g,
                children: [
                  for (final (span, child) in row)
                    SizedBox(
                      width: span * column + (span - 1) * g,
                      child: child,
                    ),
                ],
              ),
          ],
        );
      },
    );
  }
}
