import 'package:flutter/widgets.dart';

import '../flex/rebic_flex_alignment.dart';
import '../flex/rebic_flex_layout.dart';
import '../spacing/rebic_spacing.dart';

/// Empilha filhos na vertical, como o `sap.m.VBox` do SAPUI5.
///
/// O espaço [gap] do tema entra só entre os filhos, nunca nas pontas, e muda
/// com a densidade. O alinhamento cruzado segue a direção do texto.
/// `Expanded` e `Flexible` ocupam o espaço livre.
///
/// ```dart
/// const RebicColumn(
///   children: [
///     RebicText('Pedido 4711', variant: RebicTextVariant.title),
///     RebicText('Aguardando aprovação', tone: RebicTextTone.muted),
///   ],
/// )
/// ```
class RebicColumn extends StatelessWidget {
  /// Cria a coluna.
  const RebicColumn({
    required this.children,
    this.gap = RebicSpace.stackGap,
    this.mainAlignment = RebicMainAlignment.start,
    this.crossAlignment = RebicCrossAlignment.start,
    this.shrinkWrap = false,
    super.key,
  });

  /// Filhos, de cima para baixo.
  final List<Widget> children;

  /// Espaço entre filhos consecutivos.
  final RebicSpace gap;

  /// Alinhamento vertical.
  final RebicMainAlignment mainAlignment;

  /// Alinhamento horizontal.
  final RebicCrossAlignment crossAlignment;

  /// Se ocupa só a altura necessária, em vez de toda a disponível.
  final bool shrinkWrap;

  @override
  Widget build(BuildContext context) => buildRebicFlex(
    context,
    axis: Axis.vertical,
    children: children,
    gap: gap,
    mainAlignment: mainAlignment,
    crossAlignment: crossAlignment,
    shrinkWrap: shrinkWrap,
  );
}
