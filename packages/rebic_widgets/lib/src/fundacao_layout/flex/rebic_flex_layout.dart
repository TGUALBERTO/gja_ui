import 'package:flutter/widgets.dart';
import 'package:rebic_foundation/rebic_foundation.dart';

import '../spacing/rebic_spacing.dart';
import 'rebic_flex_alignment.dart';

// Montagem comum de `RebicRow` e `RebicColumn`. Não exportado: a API pública
// são os dois widgets e os enums de alinhamento.

/// `Flex` com o espaço [gap] do tema só entre os filhos.
Widget buildRebicFlex(
  BuildContext context, {
  required Axis axis,
  required List<Widget> children,
  required RebicSpace gap,
  required RebicMainAlignment mainAlignment,
  required RebicCrossAlignment crossAlignment,
  required bool shrinkWrap,
}) {
  final spacing = RebicThemeData.of(context).spacing;
  return Flex(
    direction: axis,
    spacing: RebicSpacing.resolve(spacing, gap),
    mainAxisAlignment: switch (mainAlignment) {
      RebicMainAlignment.start => MainAxisAlignment.start,
      RebicMainAlignment.center => MainAxisAlignment.center,
      RebicMainAlignment.end => MainAxisAlignment.end,
      RebicMainAlignment.spaceBetween => MainAxisAlignment.spaceBetween,
    },
    crossAxisAlignment: switch (crossAlignment) {
      RebicCrossAlignment.start => CrossAxisAlignment.start,
      RebicCrossAlignment.center => CrossAxisAlignment.center,
      RebicCrossAlignment.end => CrossAxisAlignment.end,
      RebicCrossAlignment.stretch => CrossAxisAlignment.stretch,
    },
    mainAxisSize: shrinkWrap ? MainAxisSize.min : MainAxisSize.max,
    children: children,
  );
}

/// `Wrap` com o espaço [gap] do tema entre os filhos e entre as linhas.
Widget buildRebicWrap(
  BuildContext context, {
  required List<Widget> children,
  required RebicSpace gap,
  required RebicMainAlignment mainAlignment,
}) {
  assert(
    children.every((c) => c is! Flexible),
    'RebicRow.wrap não aceita filhos Expanded ou Flexible',
  );
  final value = RebicSpacing.resolve(RebicThemeData.of(context).spacing, gap);
  return Wrap(
    spacing: value,
    runSpacing: value,
    alignment: switch (mainAlignment) {
      RebicMainAlignment.start => WrapAlignment.start,
      RebicMainAlignment.center => WrapAlignment.center,
      RebicMainAlignment.end => WrapAlignment.end,
      RebicMainAlignment.spaceBetween => WrapAlignment.spaceBetween,
    },
    children: children,
  );
}
