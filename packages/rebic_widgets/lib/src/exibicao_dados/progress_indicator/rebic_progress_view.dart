import 'dart:ui' show lerpDouble;

import 'package:flutter/widgets.dart';
import 'package:rebic_foundation/rebic_foundation.dart';

import 'rebic_progress_painter.dart';

/// Animação e pintura do indicador de progresso, internas ao pacote (não
/// exportadas), com as cores recebidas.
///
/// Usada pelo `RebicProgressIndicator`, que resolve as cores do tema e a
/// semântica, e pelo `RebicButton` ocupado, na cor do texto do estado. Com
/// [value], anima até cada novo valor em `motion.short`; sem ele, roda o
/// ciclo indeterminado, parado com movimento reduzido. Não tem semântica.
class RebicProgressView extends StatefulWidget {
  /// Cria a pintura animada.
  const RebicProgressView({
    required this.circular,
    required this.value,
    required this.fill,
    required this.track,
    required this.extent,
    super.key,
  });

  /// Se desenha o círculo; senão, a barra.
  final bool circular;

  /// Andamento, de 0 a 1; nulo torna o indicador indeterminado.
  final double? value;

  /// Cor do preenchimento.
  final Color fill;

  /// Cor da trilha.
  final Color track;

  /// Lado do círculo ou altura da barra (que ocupa a largura disponível).
  final double extent;

  @override
  State<RebicProgressView> createState() => _RebicProgressViewState();
}

/// Ciclos do indeterminado por `motion.long`: 4 × 300 ms nos tokens de
/// referência, perto do ciclo do `BusyIndicator`.
const _cyclesPerLong = 4;

class _RebicProgressViewState extends State<RebicProgressView>
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
  void didUpdateWidget(RebicProgressView oldWidget) {
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
    final value = widget.value;
    final textDirection = Directionality.of(context);
    final paint = AnimatedBuilder(
      animation: _controller,
      builder: (context, _) => CustomPaint(
        painter: RebicProgressPainter(
          circular: widget.circular,
          value: value == null ? null : _shown(theme.motion.standard),
          phase: value == null && _controller.isAnimating
              ? _controller.value
              : null,
          fill: widget.fill,
          track: widget.track,
          thickness: theme.spacing.xxs,
          textDirection: textDirection,
        ),
      ),
    );
    return widget.circular
        ? SizedBox.square(dimension: widget.extent, child: paint)
        : SizedBox(height: widget.extent, width: double.infinity, child: paint);
  }
}
