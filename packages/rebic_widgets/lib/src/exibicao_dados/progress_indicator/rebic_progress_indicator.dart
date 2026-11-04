import 'package:flutter/widgets.dart';
import 'package:rebic_core/rebic_core.dart';
import 'package:rebic_foundation/rebic_foundation.dart';

import 'rebic_progress_view.dart';

/// Indicador de progresso, como o `sap.m.ProgressIndicator` do SAPUI5.
///
/// Uma barra na largura disponível, com a espessura `spacing.xs`, preenchida
/// até [percentValue] (de 0 a 100); chega a cada novo valor em
/// `motion.short`, ou de imediato com movimento reduzido. Para uma operação
/// sem andamento medível, use `RebicBusyIndicator`.
///
/// O preenchimento usa `colors.brand` em [RebicValueState.none] e a cor do
/// estado nos demais ([state]). O leitor de tela anuncia [semanticLabel] (ou
/// o texto `loading`) e o valor em porcentagem.
///
/// ```dart
/// RebicProgressIndicator(percentValue: enviados / total * 100)
/// ```
class RebicProgressIndicator extends StatelessWidget {
  /// Cria a barra com [percentValue].
  const RebicProgressIndicator({
    required this.percentValue,
    this.state = RebicValueState.none,
    this.semanticLabel,
    super.key,
  }) : assert(
         percentValue >= 0 && percentValue <= 100,
         'percentValue deve estar entre 0 e 100: $percentValue',
       );

  /// Andamento, de 0 a 100.
  final double percentValue;

  /// Estado de valor, que define a cor do preenchimento.
  final RebicValueState state;

  /// Rótulo do leitor de tela; nulo usa o texto `loading`.
  final String? semanticLabel;

  @override
  Widget build(BuildContext context) {
    final theme = RebicThemeData.of(context);
    final localizations = RebicLocalizations.of(context);
    final colors = theme.colors;
    return Semantics(
      container: true,
      label: semanticLabel ?? localizations.loading,
      value: '${localizations.formatInteger(percentValue.round())}%',
      excludeSemantics: true,
      child: RebicProgressView(
        circular: false,
        value: percentValue / 100,
        fill: state == RebicValueState.none
            ? colors.brand
            : colors.stateColors(state).foreground,
        track: colors.separator,
        extent: theme.spacing.xs,
      ),
    );
  }
}
