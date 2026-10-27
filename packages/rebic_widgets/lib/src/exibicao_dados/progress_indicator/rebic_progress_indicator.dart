import 'dart:ui' show lerpDouble;

import 'package:flutter/widgets.dart';
import 'package:rebic_core/rebic_core.dart';
import 'package:rebic_foundation/rebic_foundation.dart';

import '../../fundacao_layout/icon/rebic_icon.dart';
import 'rebic_progress_painter.dart';

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
class RebicProgressIndicator extends StatefulWidget {
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
  State<RebicProgressIndicator> createState() => _RebicProgressIndicatorState();
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

/// Ciclos do indeterminado por `motion.long`: 4 × 300 ms nos tokens de
/// referência, perto do ciclo do `BusyIndicator`.
const _cyclesPerLong = 4;

class _RebicProgressIndicatorState extends State<RebicProgressIndicator>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller = AnimationController(vsync: this);

  /// Valor de onde parte a transição determinada em curso.
  double _from = 0;
  RebicMotionTokens? _motion;

  /// Valor exibido agora no modo determinado.
  double _shown(Curve curve) => lerpDouble(
    _from,
    widget.value ?? _from,
    curve.transform(_controller.value),
  )!;

  @override
  void initState() {
    super.initState();
    _from = widget.value ?? 0;
    _controller.value = 1;
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _motion = RebicThemeData.of(context).motion;
    if (widget.value == null) _runIndeterminate();
  }

  @override
  void didUpdateWidget(RebicProgressIndicator oldWidget) {
    super.didUpdateWidget(oldWidget);
    final motion = _motion!;
    final value = widget.value;
    if (value == null) {
      _runIndeterminate();
    } else if (oldWidget.value == null) {
      _controller.stop();
      _from = value;
      _controller.value = 1;
    } else if (value != oldWidget.value) {
      _from = lerpDouble(
        _from,
        oldWidget.value,
        motion.standard.transform(_controller.value),
      )!;
      _controller.duration = motion.short;
      _controller.forward(from: 0);
    }
  }

  void _runIndeterminate() {
    final period = _motion!.long * _cyclesPerLong;
    if (period == Duration.zero) {
      _controller.stop();
      return;
    }
    if (_controller.isAnimating && _controller.duration == period) return;
    _controller.duration = period;
    _controller.repeat();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = RebicThemeData.of(context);
    final localizations = RebicLocalizations.of(context);
    final colors = theme.colors;
    final fill = widget.state == RebicValueState.none
        ? colors.brand
        : colors.stateColors(widget.state).foreground;
    final value = widget.value;
    final textDirection = Directionality.of(context);

    final paint = AnimatedBuilder(
      animation: _controller,
      builder: (context, _) => CustomPaint(
        painter: RebicProgressPainter(
          circular: widget._circular,
          value: value == null ? null : _shown(theme.motion.standard),
          phase: value == null && _controller.isAnimating
              ? _controller.value
              : null,
          fill: fill,
          track: colors.separator,
          thickness: theme.spacing.xxs,
          textDirection: textDirection,
        ),
      ),
    );

    return Semantics(
      container: true,
      label: widget.semanticLabel ?? localizations.loading,
      value: value == null
          ? null
          : '${localizations.formatInteger((value * 100).round())}%',
      excludeSemantics: true,
      child: widget._circular
          ? SizedBox.square(
              dimension: _iconSize(theme.icons, widget.size),
              child: paint,
            )
          : SizedBox(
              height: theme.spacing.xs,
              width: double.infinity,
              child: paint,
            ),
    );
  }
}
