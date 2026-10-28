import 'package:flutter/widgets.dart';
import 'package:rebic_core/rebic_core.dart';
import 'package:rebic_foundation/rebic_foundation.dart';

import '../../fundacao_layout/icon/rebic_icon.dart';
import 'rebic_progress_view.dart';

/// Indicador de progresso, como o `sap.m.ProgressIndicator` (barra
/// determinada) e o `sap.m.BusyIndicator` (indeterminado) do SAPUI5.
///
/// [RebicProgressIndicator.linear] ocupa a largura disponível, com a
/// espessura `spacing.xs`; [RebicProgressIndicator.circular] tem o tamanho de
/// um ícone do tema ([size]), com o traço `spacing.xxs`. Com [value] (0 a 1),
/// o preenchimento mostra o andamento e chega a cada novo valor em
/// `motion.short`; sem ele, o indicador é animado continuamente. Com
/// movimento reduzido, o indeterminado fica parado num desenho estático.
///
/// O preenchimento usa `colors.brand` em [RebicValueState.none] e a cor do
/// estado nos demais ([state]). O leitor de tela anuncia [semanticLabel] (ou
/// o texto `loading`) e, no determinado, o valor em porcentagem.
///
/// ```dart
/// RebicProgressIndicator.linear(value: enviados / total)
/// const RebicProgressIndicator.circular(semanticLabel: 'Salvando pedido')
/// ```
class RebicProgressIndicator extends StatelessWidget {
  /// Barra na largura disponível.
  const RebicProgressIndicator.linear({
    this.value,
    this.state = RebicValueState.none,
    this.semanticLabel,
    super.key,
  }) : size = RebicIconSize.control,
       _circular = false,
       assert(
         value == null || (value >= 0 && value <= 1),
         'value deve estar entre 0 e 1: $value',
       );

  /// Círculo no tamanho do ícone [size].
  const RebicProgressIndicator.circular({
    this.value,
    this.state = RebicValueState.none,
    this.size = RebicIconSize.control,
    this.semanticLabel,
    super.key,
  }) : _circular = true,
       assert(
         value == null || (value >= 0 && value <= 1),
         'value deve estar entre 0 e 1: $value',
       );

  /// Andamento, de 0 a 1; nulo torna o indicador indeterminado.
  final double? value;

  /// Estado de valor, que define a cor do preenchimento.
  final RebicValueState state;

  /// Tamanho do círculo, entre os tamanhos de ícone do tema.
  final RebicIconSize size;

  /// Rótulo do leitor de tela; nulo usa o texto `loading`.
  final String? semanticLabel;

  final bool _circular;

  @override
  Widget build(BuildContext context) {
    final theme = RebicThemeData.of(context);
    final localizations = RebicLocalizations.of(context);
    final colors = theme.colors;
    final value = this.value;
    return Semantics(
      container: true,
      label: semanticLabel ?? localizations.loading,
      value: value == null
          ? null
          : '${localizations.formatInteger((value * 100).round())}%',
      excludeSemantics: true,
      child: RebicProgressView(
        circular: _circular,
        value: value,
        fill: state == RebicValueState.none
            ? colors.brand
            : colors.stateColors(state).foreground,
        track: colors.separator,
        extent: _circular ? _iconSize(theme.icons, size) : theme.spacing.xs,
      ),
    );
  }
}

/// Lado de um ícone de tamanho [size].
double _iconSize(RebicIconTokens t, RebicIconSize size) => switch (size) {
  RebicIconSize.small => t.small,
  RebicIconSize.medium => t.medium,
  RebicIconSize.large => t.large,
  RebicIconSize.xLarge => t.xLarge,
  RebicIconSize.inline => t.inline,
  RebicIconSize.control => t.control,
};
