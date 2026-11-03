import 'package:flutter/widgets.dart';
import 'package:rebic_core/rebic_core.dart';
import 'package:rebic_foundation/rebic_foundation.dart';

import '../spacing/rebic_spacing.dart';

/// Span próprio de um item de [RebicGrid], como o `GridData` do SAPUI5.
///
/// Envolve o item em [RebicGrid.content], como o `layoutData` do UI5; fora de
/// uma grade, só mostra [child].
class RebicGridData extends StatelessWidget {
  /// Dá a [child] o [span] próprio.
  const RebicGridData({required this.span, required this.child, super.key});

  /// Colunas ocupadas por classe de tamanho (de 1 a 12), com herança da
  /// classe menor.
  final RebicResponsiveValue<int> span;

  /// O item.
  final Widget child;

  @override
  Widget build(BuildContext context) => child;
}

/// Grade de 12 colunas, como o `sap.ui.layout.Grid` do SAPUI5.
///
/// Cada item de [content] ocupa um número de colunas por classe de tamanho:
/// o `span` do seu [RebicGridData] ou, sem ele, [defaultSpan], com herança da
/// classe menor. Os itens fluem em linhas na ordem dada; um item que não cabe
/// no restante da linha começa a seguinte. O espaço entre colunas
/// ([hSpacing]) e entre linhas ([vSpacing]) vem do tema. Em RTL, a primeira
/// coluna fica à direita.
///
/// Como no UI5, a classe vem da largura da tela; numa área mais estreita que
/// a tela (um conteúdo lateral, um cartão), use [containerQuery] `true` para
/// medir a largura disponível. Diferente do UI5, a grade não tem margem
/// externa nem espaço depois da última linha: a margem vem da página.
///
/// ```dart
/// RebicGrid(content: [for (final p in pedidos) PedidoCard(p)])
///
/// const RebicGrid(content: [
///   RebicGridData(
///     span: RebicResponsiveValue(small: 12, large: 6),
///     child: Resumo(),
///   ),
///   Atalhos(),
/// ])
/// ```
class RebicGrid extends StatelessWidget {
  /// Cria a grade de [content].
  const RebicGrid({
    required this.content,
    this.defaultSpan = standardSpan,
    this.hSpacing = RebicSpace.l,
    this.vSpacing = RebicSpace.l,
    this.containerQuery = false,
    super.key,
  });

  /// Número de colunas da grade.
  static const columns = 12;

  /// Span padrão, o `XL3 L3 M6 S12` do UI5: 1, 2, 4 e 4 itens por linha de
  /// `small` a `extraLarge`.
  static const standardSpan = RebicResponsiveValue(
    small: 12,
    medium: 6,
    large: 3,
    extraLarge: 3,
  );

  /// Itens, na ordem de leitura; envolva um item em [RebicGridData] para dar
  /// a ele um span próprio.
  final List<Widget> content;

  /// Colunas ocupadas por item sem [RebicGridData].
  final RebicResponsiveValue<int> defaultSpan;

  /// Espaço entre colunas.
  final RebicSpace hSpacing;

  /// Espaço entre linhas.
  final RebicSpace vSpacing;

  /// Se a classe vem da largura disponível para a grade, em vez da tela.
  final bool containerQuery;

  @override
  Widget build(BuildContext context) {
    final theme = RebicThemeData.of(context);
    final screenClass = containerQuery
        ? null
        : RebicResponsive.screenSizeClassOf(context);
    return LayoutBuilder(
      builder: (context, constraints) {
        final width = constraints.maxWidth;
        assert(
          width.isFinite,
          'RebicGrid precisa de largura limitada (recebeu $width)',
        );
        final sizeClass = screenClass ?? theme.breakpoints.classify(width);
        final g = RebicSpacing.resolve(theme.spacing, hSpacing);
        final column = (width - (columns - 1) * g) / columns;

        final rows = <List<(int, Widget)>>[];
        var used = columns;
        for (final (index, item) in content.indexed) {
          final data = item is RebicGridData ? item.span : null;
          final span = (data ?? defaultSpan).resolve(sizeClass);
          assert(
            span >= 1 && span <= columns,
            'span do item $index deve estar entre 1 e $columns: $span',
          );
          if (used + span > columns) {
            rows.add([]);
            used = 0;
          }
          rows.last.add((span, item));
          used += span;
        }

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          spacing: RebicSpacing.resolve(theme.spacing, vSpacing),
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
