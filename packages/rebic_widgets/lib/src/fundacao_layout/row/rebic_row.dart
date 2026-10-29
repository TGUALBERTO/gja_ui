import 'package:flutter/widgets.dart';

import '../flex/rebic_flex_alignment.dart';
import '../flex/rebic_flex_layout.dart';
import '../spacing/rebic_spacing.dart';

/// Organiza filhos lado a lado, como o `sap.m.HBox` do SAPUI5.
///
/// O espaço [gap] do tema entra só entre os filhos, nunca nas pontas, e muda
/// com a densidade. O início segue a direção do texto. `Expanded` e
/// `Flexible` ocupam o espaço livre.
///
/// ```dart
/// const RebicRow(
///   children: [RebicIcon(RebicIcons.information), RebicText('Detalhes')],
/// )
/// ```
///
/// Use [RebicRow.wrap] para quebrar em linhas quando falta largura.
class RebicRow extends StatelessWidget {
  /// Cria a linha.
  const RebicRow({
    required this.children,
    this.gap = RebicSpace.inlineGap,
    this.mainAlignment = RebicMainAlignment.start,
    this.crossAlignment = RebicCrossAlignment.center,
    this.shrinkWrap = false,
    super.key,
  }) : _wrap = false;

  /// Cria uma linha que leva para a linha seguinte os filhos que não cabem,
  /// com [gap] entre os filhos e entre as linhas.
  ///
  /// Não aceita filhos `Expanded` ou `Flexible`.
  const RebicRow.wrap({
    required this.children,
    this.gap = RebicSpace.inlineGap,
    this.mainAlignment = RebicMainAlignment.start,
    super.key,
  }) : crossAlignment = RebicCrossAlignment.start,
       shrinkWrap = false,
       _wrap = true;

  /// Filhos, na ordem visual.
  final List<Widget> children;

  /// Espaço entre filhos consecutivos (e entre linhas, em [RebicRow.wrap]).
  final RebicSpace gap;

  /// Alinhamento horizontal.
  final RebicMainAlignment mainAlignment;

  /// Alinhamento vertical; não se aplica em [RebicRow.wrap].
  final RebicCrossAlignment crossAlignment;

  /// Se ocupa só a largura necessária, em vez de toda a disponível.
  final bool shrinkWrap;

  final bool _wrap;

  @override
  Widget build(BuildContext context) {
    if (_wrap) {
      return buildRebicWrap(
        context,
        children: children,
        gap: gap,
        mainAlignment: mainAlignment,
      );
    }
    return buildRebicFlex(
      context,
      axis: Axis.horizontal,
      children: children,
      gap: gap,
      mainAlignment: mainAlignment,
      crossAlignment: crossAlignment,
      shrinkWrap: shrinkWrap,
    );
  }
}
