import 'package:flutter/widgets.dart';
import 'package:rebic_foundation/rebic_foundation.dart';

import '../spacing/rebic_spacing.dart';
import 'rebic_flex_enums.dart';

// Montagem comum de `RebicHBox` e `RebicVBox`. Não exportado: a API pública
// são os dois widgets e os enums do FlexBox.

MainAxisAlignment _main(RebicFlexJustifyContent value) => switch (value) {
  RebicFlexJustifyContent.start => MainAxisAlignment.start,
  RebicFlexJustifyContent.center => MainAxisAlignment.center,
  RebicFlexJustifyContent.end => MainAxisAlignment.end,
  RebicFlexJustifyContent.spaceBetween => MainAxisAlignment.spaceBetween,
  RebicFlexJustifyContent.spaceAround => MainAxisAlignment.spaceAround,
};

/// `Flex` com o espaço [gap] do tema só entre os itens.
Widget buildRebicFlex(
  BuildContext context, {
  required Axis axis,
  required List<Widget> items,
  required RebicSpace gap,
  required RebicFlexJustifyContent justifyContent,
  required RebicFlexAlignItems alignItems,
  required bool displayInline,
}) {
  final spacing = RebicThemeData.of(context).spacing;
  // Numa coluna, `baseline` cai em `start`, como `align-items: baseline` no
  // CSS de uma coluna.
  final baseline =
      axis == Axis.horizontal && alignItems == RebicFlexAlignItems.baseline;
  return Flex(
    direction: axis,
    spacing: RebicSpacing.resolve(spacing, gap),
    mainAxisAlignment: _main(justifyContent),
    crossAxisAlignment: switch (alignItems) {
      RebicFlexAlignItems.start => CrossAxisAlignment.start,
      RebicFlexAlignItems.center => CrossAxisAlignment.center,
      RebicFlexAlignItems.end => CrossAxisAlignment.end,
      RebicFlexAlignItems.baseline =>
        baseline ? CrossAxisAlignment.baseline : CrossAxisAlignment.start,
      RebicFlexAlignItems.stretch => CrossAxisAlignment.stretch,
    },
    textBaseline: baseline ? TextBaseline.alphabetic : null,
    mainAxisSize: displayInline ? MainAxisSize.min : MainAxisSize.max,
    children: items,
  );
}

/// `Wrap` com o espaço [gap] do tema entre os itens e entre as linhas.
Widget buildRebicWrap(
  BuildContext context, {
  required List<Widget> items,
  required RebicSpace gap,
  required RebicFlexJustifyContent justifyContent,
  required RebicFlexAlignItems alignItems,
}) {
  assert(
    items.every((c) => c is! Flexible),
    'RebicHBox com wrap não aceita itens Expanded ou Flexible',
  );
  assert(
    alignItems != RebicFlexAlignItems.stretch &&
        alignItems != RebicFlexAlignItems.baseline,
    'RebicHBox com wrap: alignItems stretch e baseline não se aplicam à '
    'quebra',
  );
  final value = RebicSpacing.resolve(RebicThemeData.of(context).spacing, gap);
  return Wrap(
    spacing: value,
    runSpacing: value,
    alignment: switch (justifyContent) {
      RebicFlexJustifyContent.start => WrapAlignment.start,
      RebicFlexJustifyContent.center => WrapAlignment.center,
      RebicFlexJustifyContent.end => WrapAlignment.end,
      RebicFlexJustifyContent.spaceBetween => WrapAlignment.spaceBetween,
      RebicFlexJustifyContent.spaceAround => WrapAlignment.spaceAround,
    },
    crossAxisAlignment: switch (alignItems) {
      RebicFlexAlignItems.center => WrapCrossAlignment.center,
      RebicFlexAlignItems.end => WrapCrossAlignment.end,
      _ => WrapCrossAlignment.start,
    },
    children: items,
  );
}
