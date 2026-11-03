import 'package:flutter/widgets.dart';

import '../flex/rebic_flex_enums.dart';
import '../flex/rebic_flex_layout.dart';
import '../spacing/rebic_spacing.dart';

/// Empilha itens na vertical, como o `sap.m.VBox` do SAPUI5.
///
/// O espaço [gap] do tema entra só entre os itens, nunca nas pontas. O
/// alinhamento cruzado segue a direção do texto. `Expanded` e `Flexible`
/// ocupam o espaço livre.
///
/// Diferente do UI5, [gap] tem o padrão `stackGap`, e não nenhum, porque no
/// Rebic o espaço vem do tema; e [alignItems] tem o padrão `start`, e não
/// `stretch`, porque esticar num eixo sem limite falha no Flutter.
///
/// ```dart
/// const RebicVBox(
///   items: [
///     RebicTitle('Pedido 4711', titleStyle: RebicTitleLevel.h3),
///     RebicLabel('Aguardando aprovação'),
///   ],
/// )
/// ```
class RebicVBox extends StatelessWidget {
  /// Cria a caixa vertical.
  const RebicVBox({
    required this.items,
    this.gap = RebicSpace.stackGap,
    this.justifyContent = RebicFlexJustifyContent.start,
    this.alignItems = RebicFlexAlignItems.start,
    this.displayInline = false,
    super.key,
  });

  /// Itens, de cima para baixo.
  final List<Widget> items;

  /// Espaço entre itens consecutivos.
  final RebicSpace gap;

  /// Alinhamento vertical.
  final RebicFlexJustifyContent justifyContent;

  /// Alinhamento horizontal; `baseline` vale como `start`.
  final RebicFlexAlignItems alignItems;

  /// Se ocupa só a altura necessária, em vez de toda a disponível.
  final bool displayInline;

  @override
  Widget build(BuildContext context) => buildRebicFlex(
    context,
    axis: Axis.vertical,
    items: items,
    gap: gap,
    justifyContent: justifyContent,
    alignItems: alignItems,
    displayInline: displayInline,
  );
}
